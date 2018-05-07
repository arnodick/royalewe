local function load(g,name,x,y,d,angle,vel,c)
	local a={}
	copytable(a,g.actordata[name])

	a.t=EA[name]
	a.name=name
	a.x=x or love.math.random(319)
	a.y=y or love.math.random(239)
	a.d=d or 0
	a.angle=angle or 0
	a.vel=vel or 0
	a.c=c or 1
	a.cinit=a.c
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.speed=1
	a.delta=g.timer
	a.delete=false
	a.flags=0x0
	if g.actordata[name].flags then
		a.flags=flags.set(a.flags,g.actordata[name].flags)
	end
	--game.counters(g,a,1)

	g.actordata[name].count=g.actordata[name].count+1

	table.insert(g.actors,a)
	return a
end

local function make(g,t,x,y,d,vel,...)
	local a={}
	a.t=t
	a.x=x or love.math.random(319)
	a.y=y or love.math.random(239)
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.angle=0
	a.speed=1
	a.delta=g.timer
	a.delete=false
	a.flags = 0x0
	run(EA[a.t],"make",g,a,...)--actor's specifc make function (ie snake.make)
	game.counters(g,a,1)
--[[
	if flags.get(a.flags,EF.queue) then
		g.actors[ EA[a.t].."s" ][ EA[a.t].."s" ]={}
	end
--]]

	--TODO in here do if inivalues.flags then flags.set(a,EF[flagname],...)

	table.insert(g.actors,a)
	--if t==EA.person then
	--print(a)
	--print(g.actors[#g.actors])
	--end
	return a
end

local function control(g,a,gs)
	controller.update(a,gs)
	
	if g.level then
		if g.level.mode then
			run(g.level.modename,"control",a,g.level.map,gs)
		end
	end

	if a.t then
		run(EA[a.t],"control",g,a,gs)--actor's specific type control (ie snake.control)
	end

	if a.controls then
		controls.run(g,a,gs)
	end

	if flags.get(a.flags,EF.player) then
		player.control(g,a)
	end

	if a.item then--if a IS an item, do its item stuff
		item.control(a,gs)
	end

	if a.collectible then--if a IS a collectible, do its collectible stuff
		collectible.control(a,gs)
	end

	if a.anglespeed then--TODO make angle module with speed and accel
		if a.anglespeeddecel then
			a.anglespeed=math.snap(a.anglespeed,a.anglespeeddecel,0)
		end
		a.angle = a.angle + a.anglespeed*a.vec[1]*math.pi*2*gs
	end

	if a.hit then
		hit.control(a.hit,a,gs)
	end

	if a.flash then
		flash.control(a,a.flash)
	end


	local decel=a.decel
--[[
	if g.actordata[EA[a.t] ] then
		decel=g.actordata[EA[a.t] ].decel
	end
--]]
	if decel then--TODO make decel module with speed OR velocity module? w speed and accel
		a.vel=math.snap(a.vel,decel*(g.timer-a.delta)/4*gs,0)
		--a.vel=math.snap(a.vel,a.decel*gs,0)
--[[
		if not a.transition then
			module.make(a,EM.transition,easing.linear,"vel",a.vel,-a.vel,30)
		else
			transition.control(a,a.transition)
		end
--]]
	end

	if a.transition then
		transition.control(a,a.transition)
	end

	if flags.get(a.flags,EF.shopitem) then
		shopitem.control(a,g.player)
	end

	if a.inventory then
		inventory.control(a,a.inventory)
	end

--[[
	if a.item then
		game.state.run(g.name,"item","control",g,a)
	end
--]]

---[[
	if a.tail then
		if a.controller then
			local c=a.controller.aim
			tail.control(a.tail,gs,a,c.horizontal,c.vertical)
		end
	end
--]]
	local m=g.level.map
	if a.x<-10
	or a.x>m.width+10
	or a.y>m.height+10
	or a.y<-10 then
		if not flags.get(a.flags,EF.persistent) then
			a.delete=true
	 	end
	end
end

local function draw(g,a)
	if a.menu then
		menu.draw(a.menu)
	end

	if g.level then
		if g.level.mode then
			run(g.level.modename,"draw",g,a)
		end
	end

	if flags.get(a.flags,EF.player) then
		player.draw(g,a)
	end
end

local function damage(a,d)
	local g=Game
	if not a.delete then
		--TODO game-specific
		module.make(a,EM.flash,"c",EC.white,a.cinit,6)
		if a.sound then
			if a.sound.damage then
				sfx.play(a.sound.damage,a.x,a.y)
			end
		end

		--TODO a lot of this stuff is game specific, or rather level specific (each level should have its own rules/"physics" and some games just have the same for every level, whereas games with different modes in different parts of the game will have different rules/physics in different levels)
		if flags.get(a.flags,EF.damageable) then
			a.hp=a.hp-d
			run(EA[a.t],"damage",a)
			if flags.get(a.flags,EF.player) then
				player.damage(g,a)
			end

			game.state.run(g.name,"actor","damage",g,a,d)

			if a.hit then
				hit.damage(a.hit,a)
			end

			if a.hp<1 then
				--sfx.play(a.deathsnd,a.x,a.y)
				a.delete=true

				game.state.run(g.name,"actor","dead",g,a)
				--run(EA[a.t],"dead",g,a)
				if flags.get(a.flags,EF.player) then
					player.dead(g,a)
				end

				--TODO sort of game-specific
				if flags.get(a.flags,EF.explosive) then
					actor.make(g,EA.explosion,a.x,a.y,0,0,EC.white,20*(a.size))
				end

				--TODO also sort of game specific
				if flags.get(a.flags,EF.character) then
					character.dead(a)
				end
				
				run(EA[a.t],"dead",a)
			end
		end
	end
end

local function impulse(a,dir,vel,glitch)
	glitch=glitch or false
	local vecx=math.cos(a.d)
	local vecy=math.sin(a.d)
	local impx=math.cos(dir)
	local impy=math.sin(dir)

	if glitch then
		impy = -impy
	end

	local outx,outy=vector.normalize(vecx+impx,vecy-impy)
	local outvel=a.vel+vel
	
	return vector.direction(outx,outy), outvel
end

local function collision(x,y,enemy)--TODO something other than enemy here?
	local dist=vector.distance(enemy.x,enemy.y,x,y)
	if enemy.hitradius then
		return hitradius.collision(enemy.hitradius.r,dist)
	elseif enemy.hitbox then
		return hitbox.collision(x,y,enemy)
	end
	return false
end

local function corpse(a,tw,th,hack)
	local g=Game
	local dir=math.randomfraction(math.pi*2)
	--local ix,iy=a.x-tw/2,a.y-th/2
	--local ix,iy=a.x-tw/2-8,a.y-th/2-8
	local ix,iy=a.x-tw/2-(g.camera.x-g.width/2),a.y-th/2-(g.camera.y-g.height/2)
	local ix2,iy2=ix+tw,iy+th

	if ix<0 then ix=0 end
	if iy<0 then iy=0 end
	if ix2>g.width then
		local diff=ix2-g.width
		tw=tw-diff
	end
	if iy2>g.height then
		local diff=iy2-g.height
		th=th-diff
	end
	
	local body=actor.make(g,EA.debris,a.x,a.y)
	body.decel=0.1
	if not hack then
		local choice=math.choose(1,2)
		if choice==1 then
			local imgdata=g.canvas.main:newImageData(ix,iy,tw,th)
			body.image=LG.newImage(imgdata)
		else
			local imgdata=g.canvas.main:newImageData(ix,iy,tw/2,th)
			body.image=LG.newImage(imgdata)
			body.d=dir

			local body2=actor.make(g,EA.debris,a.x,a.y)
			body2.decel=0.1
			local imgdata2=g.canvas.main:newImageData(ix+tw/2,iy,tw/2,th)
			body2.image=LG.newImage(imgdata2)
			body2.d=dir+math.randomfraction(0.5)-0.25
		end
	else
		body.decel=0.2
		local imgdata=g.canvas.main:newImageData(ix,iy,tw/2,th/2)
		body.image=LG.newImage(imgdata)
		body.d=math.randomfraction(math.pi*2)

		local body2=actor.make(g,EA.debris,a.x,a.y)
		body2.decel=0.2
		local imgdata2=g.canvas.main:newImageData(ix+tw/2,iy+th/2,tw/2,th/2)
		body2.image=LG.newImage(imgdata2)
		body2.d=math.randomfraction(math.pi*2)

		local body3=actor.make(g,EA.debris,a.x,a.y)
		body3.decel=0.2
		local imgdata3=g.canvas.main:newImageData(ix+tw/2,iy,tw/2,th/2)
		body3.image=LG.newImage(imgdata3)
		body3.d=math.randomfraction(math.pi*2)

		local body4=actor.make(g,EA.debris,a.x,a.y)
		body4.decel=0.2
		local imgdata4=g.canvas.main:newImageData(ix,iy,tw/2,th/2)
		body4.image=LG.newImage(imgdata4)
		body4.d=math.randomfraction(math.pi*2)
	end
end

return
{
	load = load,
	make = make,
	control = control,
	draw = draw,
	collision = collision,
	damage = damage,
	impulse = impulse,
	corpse = corpse,
}