local royalewe={}

royalewe.level = 
{
	make = function(g,l)
		local m=l.map

		for i=1,199 do
			actor.make(g,EA.person,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)
		end
---[[
		for i=1,20 do
			actor.make(g,EA.handgun,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)
		end
--]]
		for i=1,50 do
			actor.make(g,EA.the_coin,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)
		end

		actor.make(g,EA.minigun,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)

		g.score=0
		g.scores=scores.load()
	end
}

royalewe.player =
{
	make = function(g,a)
---[[
		if #Joysticks>0 then
			module.make(a,EM.controller,EMC.move,EMCI.gamepad,1)
			module.make(a,EM.controller,EMC.aim,EMCI.gamepad,1)
			module.make(a,EM.controller,EMC.action,EMCI.gamepad,1)
		else
			module.make(a,EM.controller,EMC.move,EMCI.keyboard)
			module.make(a,EM.controller,EMC.aim,EMCI.mouse)
			module.make(a,EM.controller,EMC.action,EMCI.mouse)
			module.make(a,EM.cursor)
			a.cursor.x,a.cursor.y=a.x,a.y
		end
		module.make(g.camera,EM.target,a)
--]]
		a.desires=nil
		a.the_coin=0
	end,

	control = function(g,a)
		--g.camera.x=a.x
		--g.camera.y=a.y
		love.audio.setPosition(a.x,a.y,0)
---[[
		if a.cursor then
			cursor.update(a.cursor,a)
		end
--]]
	end,

	draw = function(g,a)
		if a.cursor then
			cursor.draw(a.cursor)
		end
	end,

	damage = function(g,a)
		g.screen.shake=30
	end,

	dead = function(g,a)
		g.score=g.score+a.the_coin
	end,

}

royalewe.make = function(g)
	
end

royalewe.gameplay =
{
	make = function(g)
		--love.keyboard.setTextInput(false)
		level.make(g,1,Enums.modes.topdown_tank)

		g.starttimer=0
		g.countdown=false

		g.camera.zoom=1
	end,

	control = function(g)
		if g.countdown then
			g.starttimer=g.starttimer+1
			if g.starttimer>180 then
				local m=g.level.map

				local a=supper.random(g.actors.persons)
				player.make(g,a)
				g.countdown=false
			end
		elseif not g.camera.transition and g.starttimer==0 then
				local upordown=love.math.random(2)
				if upordown==1 then
					local dest=love.math.random(g.level.map.width)
					local move=dest-g.camera.x
					module.make(g.camera,EM.transition,easing.linear,"x",g.camera.x,move,120)
				else
					local dest=love.math.random(g.level.map.height)
					local move=dest-g.camera.y
					module.make(g.camera,EM.transition,easing.linear,"y",g.camera.y,move,120)
				end
		end
		local m=g.level.map
---[[
		local cycles=g.level.timer.cycles
		if cycles<m.w/4 then
			if g.actors.persons then
				if #g.actors.persons<50 then
					for i=1,50 do
						local x,y=love.math.random(cycles,m.w-cycles)*m.tile.width,love.math.random(cycles,m.h-cycles)*m.tile.height
						if (x<g.camera.x-g.width/2 or x>g.camera.x+g.width) and (y<g.camera.y-g.height/2 or y>g.camera.y+g.height/2) then
							actor.make(g,EA.person,x,y)
						end
					end
				end
			end
		end
--]]
		if not g.pause and not g.countdown and g.starttimer~=0 then
			local gs=g.speed
			if g.level.timer.count>=g.level.timer.limit then
				g.level.timer.count=0
				g.level.timer.cycles=g.level.timer.cycles+1
				sfx.play(7,g.camera.x,g.camera.y)
				g.level.draw=true
			elseif g.level.timer.cycles<m.w/2 then
				g.level.timer.count=g.level.timer.count+gs
			end
		end
		if #g.actors.persons<=1 then
			--g.pause=true
			if g.players[1] then
				actor.damage(g.players[1],g.players[1].hp)
			end
--[[
			if not g.scores.saved then
				scores.save()
			end
--]]
			if not g.hud.menu then
				scores.update()
				module.make(g.hud,EM.menu,EMM.highscores,g.camera.x,g.camera.y+50,66,110,"",EC.red,EC.blue,"center")
			else
				function love.textinput(t)
					local m=g.hud.menu
					if m then
						if m.index==0 then
							for i=1,#g.scores.names do
								if g.scores.names[i]=="" then
									m.index=i
								end
							end
						end

						if m.index~=0 and #g.scores.names[m.index]<3 then
							g.scores.names[m.index]=g.scores.names[m.index]..t
						end
					end
				end
				menu.control(g.hud.menu)
			end
--[[
			if not g.hud.menu then
				module.make(g.hud,EM.menu,EMM.text,g.camera.x,g.camera.y+70,200,200,"you won! ya got "..g.score.." coinz ! coinz are very valuable to ghost goodjob",EC.red,EC.black,"center")
			end
--]]
		end
	end,

	keypressed = function(g,key)
		if g.starttimer==0 then
			g.countdown=true
		end
		if key=='escape' then
			if g.hud.menu then
				scores.save()
			end
			game.state.make(g,"title")
		elseif key=="return" then
			if g.hud.menu then
				scores.save()
				game.state.make(g,"title")
			end
		elseif key=='p' then
			g.pause = not g.pause
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if g.starttimer==0 then
			g.countdown=true
		end
		if button=="start" then
			g.pause = not g.pause
			if #g.actors.persons<=1 then
				--level.make(g,1,Enums.modes.topdown_tank)
				game.state.make(g,"gameplay")
			end
		elseif button=="a" then
			if #g.actors.persons<=1 then
				game.state.make(g,"gameplay")
			end			
		end
	end,

	mousepressed = function(g,x,y,button)
		if g.starttimer==0 then
			if button==1 then
				g.countdown=true
			end
		end
	end,

	mousemoved = function(g,x,y,dx,dy)
		if g.players[1] then
			local a=g.players[1]
			if a.cursor then
				cursor.mousemoved(a.cursor,a,g,x,y,dx,dy)
				--cursor.update(a.cursor,a,g,x,y,dx,dy)
			end
		end
	end,

	draw = function(g)
		if g.countdown then
			local c=3
			if g.starttimer>=120 then
				c=1
			elseif g.starttimer>=60 then
				c=2
			end
			local starttext="COUNTDOWN..."..c
			local colortexttable={}
			local l=string.len(starttext)
			for i=1,l do
				local index=math.clamp(i-math.floor(g.timer/10)%l,1,#g.titlecolours,true)
				table.insert(colortexttable,g.titlecolours[index])
				table.insert(colortexttable,string.sub(starttext,i,i))
			end
			LG.printf(colortexttable,g.camera.x-g.width/2,g.camera.y,g.width,"center")
			--LG.printformat("COUNTDOWN..."..c,g.camera.x-g.width/2,g.camera.y,g.width,"center",EC.red,EC.white)
		elseif g.starttimer==0 then
			local starttext="PRESS BUTTON TO BEGIN"
			local colortexttable={}
			local l=string.len(starttext)
			for i=1,l do
				local index=math.clamp(i-math.floor(g.timer/10)%l,1,#g.titlecolours,true)
				table.insert(colortexttable,g.titlecolours[index])
				table.insert(colortexttable,string.sub(starttext,i,i))
			end
			LG.printf(colortexttable,g.camera.x-g.width/2,g.camera.y,g.width,"center")
			--LG.printformat("PRESS BUTTON TO BEGIN",g.camera.x-g.width/2,g.camera.y,g.width,"center",EC.red,EC.green)
		end
		if g.pause then
			LG.printformat("PAUSE",g.camera.x-g.width/2,g.camera.y,g.width,"center",EC.red,EC.black)
		end
		if g.level.draw then
			local m=g.level.map
			local tw,th=m.tile.width,m.tile.height
			local v=166

			for x=1,m.w do
				local y=g.level.timer.cycles
				map.erasecellflags(m,x,y)
				map.setcellvalue(m,x,y,v)
				map.setcellflag(m,x,y,EF.kill)

				local othersidey=m.h+1-y
				map.erasecellflags(m,x,othersidey)
				map.setcellvalue(m,x,othersidey,v)
				map.setcellflag(m,x,othersidey,EF.kill)

				local sidex=y
				local sidey=x
				local sideotherx=m.w+1-sidex
				if x<=m.h then
					map.erasecellflags(m,sidex,sidey)
					map.setcellvalue(m,sidex,sidey,v)
					map.setcellflag(m,sidex,sidey,EF.kill)

					map.erasecellflags(m,sideotherx,sidey)
					map.setcellvalue(m,sideotherx,sidey,v)
					map.setcellflag(m,sideotherx,sidey,EF.kill)
				end
				
				local cx,cy,cothery,csidex,csidey,csideotherx=(x-1)*tw,(y-1)*tw,(othersidey-1)*tw,(sidex-1)*tw,(sidey-1)*tw,(sideotherx-1)*tw
				LG.setCanvas(g.level.canvas.background)
					LG.setBlendMode("replace")
					LG.setColor(g.palette[EC.pure_white])
					local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
					LG.translate(xcamoff,ycamoff)
						LG.draw(Spritesheet[1],Quads[1][v],cx,cy)
						LG.draw(Spritesheet[1],Quads[1][v],cx,cothery)
						if x<=m.h then
							LG.draw(Spritesheet[1],Quads[1][v],csidex,csidey)
							LG.draw(Spritesheet[1],Quads[1][v],csideotherx,csidey)
						end
					LG.translate(-xcamoff,-ycamoff)
					LG.setBlendMode("alpha")
				LG.setCanvas(g.canvas.main)
			end
			g.level.draw=false
		end

		if #g.actors.persons<=1 then
			local starttext="ya won! ya got "..g.score.." coinz ! coinz are very valuable to ghost goodjob"
			local colortexttable={}
			local l=string.len(starttext)
			for i=1,l do
				local index=math.clamp(i-math.floor(g.timer/10)%l,1,#g.titlecolours,true)
				table.insert(colortexttable,g.titlecolours[index])
				table.insert(colortexttable,string.sub(starttext,i,i))
			end
			LG.printf(colortexttable,g.camera.x-g.width/2,g.camera.y-32,g.width,"center")
			--LG.printf("you won! ya got "..g.score.." coinz ! coinz are very valuable to ghost goodjob",g.camera.x-g.width/2,g.camera.y-12,g.width,"center",0,1,1)
--[[
			if not g.hud.menu then
				module.make(g.hud,EM.menu,EMM.text,g.camera.x,g.camera.y+70,200,200,"you won! ya got "..g.score.." coinz ! coinz are very valuable to ghost goodjob",EC.red,EC.black,"center")
			end
--]]
		end
	end
}

royalewe.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" or key=="z" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		elseif button=="b" then
			game.state.make(g,"intro")
		end
	end,

	mousepressed = function(g,x,y,button)
		if button==1 then
			game.state.make(g,"gameplay")
		end
	end,

	draw = function(g)
		LG.printf("INSTRUCT ,",0,g.height/2-100,320,"center",0,1,1)

		local movetext="left stick: move"
		local shoottext="r trigger or x: dive or shoot"
		local aimtext="l trigger or a: pickup & aim"
		if #Joysticks<=0 then
			movetext="wasd or arrows: move"
			shoottext="mouse button 1: dive or shoot"
			aimtext="mouse button 2: pickup & aim"
		end

		LG.draw(Spritesheet[1],Quads[1][193],g.width/2-20,g.height/2-70,0,4,4)
		LG.printf(movetext,0,g.height/2-40,320,"center",0,1,1)
		LG.printf(shoottext,0,g.height/2-30,320,"center",0,1,1)
		LG.printf(aimtext,0,g.height/2-20,320,"center",0,1,1)
		LG.printf("coin: get",0,g.height/2-10,320,"center",0,1,1)

		LG.draw(Spritesheet[1],Quads[1][180],g.width/2-16,g.height/2+5,0,4,4)
		LG.printf(movetext,0,g.height/2+40,320,"center",0,1,1)
		LG.printf("touch person: possess",0,g.height/2+50,320,"center",0,1,1)

		LG.printf("f full screen",0,g.height/2+80,320,"center",0,1,1)
		LG.printf("esc bye",0,g.height/2+90,320,"center",0,1,1)
		LG.printf("~ tab",0,g.height/2+100,320,"center",0,1,1)
	end
}

royalewe.intro =
{
	make = function(g)
		music.play(1)
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",30)
		g.titlecolours={}
		for i=1,21 do
			table.insert(g.titlecolours,{love.math.random(255),love.math.random(255),love.math.random(255)})
		end
	end,

	keypressed = function(g,key)
		if key=="space" or key=="return" or key=="z" then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	mousepressed = function(g,x,y,button)
		if button==1 then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.setFont(g.hud.font)
		for i=1,16 do
			--print((g.timer+i)%16+1)
			if i==16 then 
				LG.setColor(g.palette[EC.white])
			else
				LG.setColor(g.palette[((math.floor(g.timer/i)))%8+9])
			end
			LG.printf("THE",   0,-i*1+g.height/2-60,320,"center",0,1,1,0,10,math.cos((g.timer+math.randomfraction(10))/20))
			LG.printf("ROYALE",0,-i*1+g.height/2,   320,"center",0,1,1,0,10,math.cos((g.timer+math.randomfraction(10))/20))
			LG.printf("WE",    0,-i*1+g.height/2+60,320,"center",0,1,1,0,10,math.cos((g.timer+math.randomfraction(10))/20))
		end
		LG.setFont(g.font)

		local starttext="press a or start"
		if #Joysticks<=0 then
			starttext="press enter or mouse 1"
		end
		local colortexttable={}
		local l=string.len(starttext)
		for i=1,l do
			--local index=math.clamp(i-math.floor(g.timer/10)%l,1,l,true)
			local index=math.clamp(i-math.floor(g.timer/10)%l,1,#g.titlecolours,true)
			--table.insert(colortexttable,{123-index*30,132,157})
			table.insert(colortexttable,g.titlecolours[index])
			table.insert(colortexttable,string.sub(starttext,i,i))
		end
		--if math.floor(g.timer/80)%2==0 then
			--LG.printf(starttext,0,g.height/2+90,320,"center",0,1,1)
			LG.printf(colortexttable,0,g.height/2+90,320,"center",0,1,1)
		--end
	end
}

royalewe.actor = {}

royalewe.item =
{
	make = function(g,a)
		a.flags=flags.set(a.flags,EF.damageable)
		a.hp=1
	end,

	control = function(g,a,gs)
		local players=g.players
		for i,p in ipairs(players) do
			item.pickup(a,p)
		end
		local m=g.level.map
		local cx,cy=map.getcell(m,a.x,a.y)
		if flags.get(m[cy][cx],EF.kill,16) then
			actor.damage(a,a.hp)
		end
	end,

	carry = function(a,user)
		a.x=user.hand.x
		a.y=user.hand.y
		--a.angle=user.angle
	end,

	pickup = function(g,a,user)
		if actor.collision(a.x,a.y,user) then
			if a.held==false then
				if user.controller.action.action and #user.inventory<1 then
					if a.sound then
						if a.sound.get then
							sfx.play(a.sound.get)
						end
					end
					a.flags=flags.set(a.flags,EF.persistent)
					table.insert(user.inventory,1,a)
					a.held=true
					--print("hpendo")
					return true
				end
			end
		end
		return false
	end,
}

return royalewe