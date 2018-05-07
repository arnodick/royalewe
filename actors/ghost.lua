local ghost={}

ghost.make = function(g,a,c,size,spr,hp)
	--a.cinit=love.math.random(16)
	--a.c=a.cinit
	a.size=size or 1
	a.spr=spr or 180
	a.alpha=230
	a.scalex=1
	a.scaley=1
	module.make(a,EM.animation,EM.animations.frames,10,6)
end

ghost.control = function(g,a)
	if a.controller then
		local c=a.controller.move
		if not a.controller.action.action then
			if not a.transition then
				if c then
					if c.horizontal~=0 or c.vertical~=0 then
						local controllerdirection=vector.direction(c.horizontal,-c.vertical)
						local controllerdifference=controllerdirection+a.angle
						local controllerdifference2=a.angle-(math.pi*2-controllerdirection)
						if math.abs(controllerdifference)>math.abs(controllerdifference2) then
							controllerdifference=controllerdifference2
						end
						module.make(a,EM.transition,easing.linear,"angle",a.angle,-controllerdifference,math.abs(controllerdifference*5))
					end
				end
			end
		else
			a.angle=vector.direction(a.controller.aim.horizontal,a.controller.aim.vertical)
			a.d=a.angle
		end
		local done=false
		for i,v in ipairs(g.actors.persons) do
			if not v.delete and v.hp>0 then
				if vector.distance(a.x,a.y,v.x,v.y)<10 then
					a.delete=true
					player.make(g,v)
					done=true
				end
				if done then
					break
				end
			end
		end
	end

--[[
	if a.vel>0 then
		if not a.animation then
			module.make(a,EM.animation,EM.animations.frames,10,4)
		end
	else
		if a.animation then
			a.animation=nil
		end
	end
--]]
end

return ghost