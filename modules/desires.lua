local desires={}

desires.make = function(a,m,pool)
	m.pool=pool
	m.queue={}
--[[
	for i=1,10 do
		table.insert(m.queue,supper.random(pool))
	end
--]]
	table.insert(m.queue,"item")
	table.insert(m.queue,"kill")
end

desires.control = function(a,m)
	local g=Game
	if not a.controller then		
		if #m.queue>0 then
			if g.players[1] then
				if m.queue[1]=="item" and #g.actors.items>0 then
					local item=supper.random(g.actors.items)
--[[
					local dir=vector.direction(vector.components(a.x,a.y,item.x,item.y))
					local dist=vector.distance(a.x,a.y,item.x,item.y)
					local r=ray.cast(a.x,a.y,dir,dist,1)
					a.blocked=false
					if r.len<dist then
						a.blocked=true
					end
--]]
					if item.hp>0 and not item.held then					
						module.make(a,EM.controller,EMC.move,EMCI.ai,item)
						module.make(a,EM.controller,EMC.action,EMCI.ai,0,0)
						module.make(a,EM.controller,EMC.aim,EMCI.ai,item)
					end
				elseif m.queue[1]=="kill" and #g.actors.persons>1 then
					local person=supper.random(g.actors.persons)
---[[
					if g.players[1] then
						if g.players[1].t==EA.person then
							if vector.distance(a.x,a.y,g.players[1].x,g.players[1].y)<300 and love.math.random(20)==1 then
								person=g.players[1]
							end
						end
					end
--]]
					
					while person==a do
						person=supper.random(g.actors.persons)
					end
					module.make(a,EM.controller,EMC.move,EMCI.ai,person)
					module.make(a,EM.controller,EMC.action,EMCI.ai,1,0)
					module.make(a,EM.controller,EMC.aim,EMCI.ai,person)
				end
			end
		else
			for i=1,10 do
				table.insert(m.queue,supper.random(m.pool))
			end
		end
	else
		local t=a.controller.move.target
		if t.item then
			local cx,cy=map.getcell(g.level.map,t.x,t.y)
			if t.hp>0 and t.delete==false and not flags.get(g.level.map[cy][cx],EF.kill,16) then
				local pickedup=false
				if actor.collision(t.x,t.y,a) then
					a.controller.action.action=true
					--module.make(a,EM.controller,EMC.action,EMCI.ai,0,1)
					pickedup=item.pickup(t,a)
				end
				--local person=supper.random(Game.actors.persons)
				--module.make(a,EM.controller,EMC.aim,EMCI.ai,person)
				if pickedup then
					for i=#m.queue,1,-1 do
						if m.queue[i]=="item" then
							table.remove(m.queue,i)
						end
					end
					a.controller=nil
					a.vel=0
				end
			else
				a.contoller=nil
				a.vel=0
			end
		elseif m.queue[1]=="kill" then
			local del=false
			if a.controller.aim.target then
				if a.controller.aim.target.hp<=0 or a.delete==true then
					--a.controller=nil
					del=true
				end
			end
			local mt=a.controller.move.target
			if mt then
				local cx,cy=map.getcell(g.level.map,mt.x,mt.y)
				if mt.hp then
					if mt.hp<=0 or mt.delete==true or flags.get(g.level.map[cy][cx],EF.kill,16) then
						--a.controller=nil
						del=true
					end
					local mindist=80
					local playerdist=vector.distance(a.x,a.y,mt.x,mt.y)
					if playerdist<mindist then--if player is too close and you're cornered, then run to safety
						local playerdir=vector.direction(vector.components(a.x,a.y,mt.x,mt.y))
						--a.controller.move.target.x,a.controller.move.target.y=a.x-(math.cos(playerdir)*playerdist),a.y-(math.sin(playerdir)*playerdist)
						module.make(a,EM.controller,EMC.move,EMCI.ai,a.x-(math.cos(playerdir)*playerdist),a.y-(math.sin(playerdir)*playerdist))
						module.make(a,EM.controller,EMC.action,EMCI.ai,1,1)
					end
				else
					local dist=vector.distance(a.x,a.y,mt.x,mt.y)
					if dist<10 then
						del=true
					end
				end
			end
			if del then
				a.controller=nil
				a.vel=0
			end
		end
	end
end

return desires