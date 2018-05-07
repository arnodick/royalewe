local function make(g,a,c,size,spr,hp)
	local e=Enums

	a.size=size or 1
	a.spr=spr or 193
	a.hp=hp or 8

	a.hand={l=8,d=math.pi/4,x=0,y=0}
	a.hand.x=a.x+(math.cos(a.d+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.d+a.hand.d)*a.hand.l)

	module.make(a,EM.sound,4,"damage")
	module.make(a,EM.hitradius,4)
	module.make(a,EM.inventory,1)

	a.flags=flags.set(a.flags,EF.damageable,EF.shootable)
end

local function control(g,a)
	if g.players[1] then
		if not a.controller then
			module.make(a,EM.controller,EMC.move,EMCI.ai,g.players[1])
			module.make(a,EM.controller,EMC.action,EMCI.ai,0.01,0)
		end
	else
		a.controller=nil
	end

	a.hand.x=a.x+(math.cos(a.angle+a.hand.d)*a.hand.l)
	a.hand.y=a.y+(math.sin(a.angle+a.hand.d)*a.hand.l)

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


return
{
	make = make,
	control = control,
}