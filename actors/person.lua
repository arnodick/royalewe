local person={}

person.make = function(g,a,c,size,spr,hp)
	--a.cinit=love.math.random(16)
	--a.c=a.cinit
	a.size=size or 1
	a.spr=spr or math.choose(193,209,225,241)
	a.sprinit=a.spr
	a.hp=hp or 4
	a.scalex=1
	a.scaley=1
	a.angle=math.randomfraction(math.pi*2)
	a.diveroll=false

	--a.hand={l=8,d=math.pi/4,x=0,y=0}
	--a.hand={l=6,d=math.pi/4,x=0,y=0}
	a.hand={l=6,d=math.pi/3,x=0,y=0}
	a.hand.x=a.x+(math.cos(a.d+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.d+a.hand.d)*a.hand.l)

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.hitradius,4)
	module.make(a,EM.inventory,1)
	module.make(a,EM.desires,{"item","kill"})

	a.flags=flags.set(a.flags,EF.damageable,EF.shootable)

	if not g.actors.persons then
		g.actors.persons={}
	end
	table.insert(g.actors.persons,a)
	--g.actors.persons[a]=a

	--print(a)
	--print(g.actors.persons[#g.actors.persons])
end

person.control = function(g,a)
	local m=g.level.map
	local cx,cy=map.getcell(m,a.x,a.y)
	if flags.get(m[cy][cx],EF.kill,16) then
		actor.damage(a,a.hp)
	end
	if a.desires then
		desires.control(a,a.desires)
	end
--[[
	if g.players[1] then
		if not a.controller then
			module.make(a,EM.controller,EMC.move,EMCI.ai,g.players[1])
			module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
		end
	else
		a.controller=nil
	end
--]]
	

	a.hand.x=a.x+(math.cos(a.angle+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.angle+a.hand.d)*a.hand.l)

	if a.controller then
		local c=a.controller.move
		if not a.diveroll then
			a.spr=a.sprinit
			if not a.controller.action.action then
				a.speed=1
				if not a.transition then
					if c then
						if c.horizontal~=0 or c.vertical~=0 then
							local controllerdirection=vector.direction(c.horizontal,-c.vertical)
							local controllerdifference=controllerdirection+a.angle
							local controllerdifference2=a.angle-(math.pi*2-controllerdirection)
							if math.abs(controllerdifference)>math.abs(controllerdifference2) then
								controllerdifference=controllerdifference2
							end
							module.make(a,EM.transition,easing.linear,"angle",a.angle,-controllerdifference,math.abs(controllerdifference*10))
						end
					end
				end
			else
				a.speed=0.8
				a.angle=vector.direction(a.controller.aim.horizontal,a.controller.aim.vertical)
				a.d=a.angle
			end
		else
			a.spr=a.sprinit+4
			a.angle=-a.d
			a.speed=a.speed-0.1
			if a.speed<=1 then
				a.speed=1
				a.diveroll=false
			end
		end
		if #a.inventory<=0 then
			if not a.diveroll then
				if a.controller.action.use then
					a.diveroll=true
					a.speed=3
				end
			end
		end
	end

	if a.vel>0 then
		if not a.animation then
			module.make(a,EM.animation,EM.animations.frames,10,4)
		end
	else
		if a.animation then
			a.animation=nil
		end
	end
end

person.damage = function(a)
	local dir=math.randomfraction(math.pi*2)
	local bloodcount=math.choose(1,2,4)
	for i=1,bloodcount do
		actor.make(Game,EA.blood,a.x,a.y,dir+math.randomfraction(math.pi/4))
	end
end

---[[
person.draw = function(g,a)
	--LG.setColor(g.palette[EC.blue])
	--LG.line(a.x,a.y,a.hand.x,a.hand.y)
	if Debugger.debugging then
		if a.desires then
			for i,v in ipairs(a.desires.queue) do
				LG.print(v,a.x+10,a.y+i*8)
			end

			if a.controller then
				if a.controller.move.target then
					if a.blocked then
						LG.setColor(g.palette[EC.red])
					else
						LG.setColor(g.palette[EC.green])
					end
					LG.line(a.x,a.y,a.controller.move.target.x,a.controller.move.target.y)
					LG.setColor(g.palette[EC.pure_white])
				end
			end
		end
	end
end
--]]

person.dead = function(a)
	local b=actor.make(Game,EA.body,a.x,a.y)
	b.spr=a.sprinit+4
	if flags.get(a.flags,EF.player) then
		b.player=true
		module.make(Game.camera,EM.target,b)
	end
	--if b.player==true then
		--module.make(g.camera,EM.target,a)
	--end
end

return person