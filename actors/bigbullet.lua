local bullet={}

bullet.make = function(g,a,c)
	--a.cinit=c or EC.green
	--a.c=a.cinit
	a.spr=66
	a.size=1
	a.angle=-a.d
	a.draw=false
end

bullet.control = function(g,a)
	local dam=1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(enemy,dam)
				end
			end
		end
	end
end

bullet.collision = function(a,cx,cy)
	if cx and cy then
		local m=Game.level.map
		local cell=m[cy][cx]
		map.erasecellflags(m,cx,cy)
		map.setcellvalue(m,cx,cy,1)
		--map.setcellflag(m,cx,cy,EF.solid,false)
		sfx.play(17,a.x,a.y)
		a.draw=true
		a.cx=cx
		a.cy=cy
	end
end

bullet.draw = function(g,a)
	if a.draw==true then
		a.draw=false

		local m=g.level.map
		local tw,th=m.tile.width,m.tile.height
		--local cx,cy=map.getcell(m,a.x,a.y)
		--cx,cy=(cx-1)*tw,(cy-1)*th
		local cx,cy=a.cx,a.cy
		cx,cy=(cx-1)*tw,(cy-1)*th
		LG.setCanvas(g.level.canvas.background)
			LG.setBlendMode("replace")
			LG.setColor(g.palette[EC.pure_white])
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.translate(xcamoff,ycamoff)
				--LG.draw(Spritesheet[1],Quads[1][0],cx,cy)
				LG.draw(Spritesheet[1],Quads[1][1],cx,cy)
			LG.translate(-xcamoff,-ycamoff)
			LG.setBlendMode("alpha")
		LG.setCanvas(g.canvas.main)
		a.delete=true
	end
end

return bullet