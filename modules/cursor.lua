local cursor={}

cursor.make = function(a,c,t,snap)
	local g=Game
	c.t=t
	local x,y=g.camera.x,g.camera.y
	love.mouse.setPosition(x,y)
	c.x=x
	c.y=y
	c.snap=snap or false

	if c.t then
		cursor[c.t].make(c)
	end
end

cursor.update = function(c,a)
--[[
	local g=Game
	local x,y=love.mouse.getPosition()
	--if a.vel>0 then
		--x=x+a.controller.move.horizontal*a.vel*a.speed
		--y=y+a.controller.move.vertical  *a.vel*a.speed
		x=x+a.vec[1]*a.vel*a.speed
		y=y-a.vec[2]*a.vel*a.speed
		print(a.vec[2]*a.vel*a.speed)
	--end
	x=math.clamp(x,a.x-g.width/2+8,a.x+g.width/2)
	y=math.clamp(y,a.y-g.height/2+8,a.y+g.height/2)

	love.mouse.setPosition(x,y)
	c.x,c.y=x,y
--]]

	c.x=c.x+a.vec[1]*a.vel*a.speed
	c.y=c.y-a.vec[2]*a.vel*a.speed
	--print(a.vec[2]*a.vel*a.speed)
end

cursor.mousepressed = function(g,c,x,y,button)
	if c.t then
		cursor[c.t].mousepressed(g,c,x,y,button)
	end
end

cursor.mousemoved = function(c,a,g,x,y,dx,dy)
	c.x,c.y=c.x+dx,c.y+dy
	c.x=math.clamp(c.x,a.x-g.width/2+8,a.x+g.width/2)
	c.y=math.clamp(c.y,a.y-g.height/2+8,a.y+g.height/2)
end

cursor.wheelmoved = function(g,c,x,y)
	if c.t then
		cursor[c.t].wheelmoved(g,c,x,y)
	end
end

cursor.draw = function(c)
	--cursor.editor.draw(c)
	LG.rectangle("line",c.x-8,c.y-8,8,8)
---[[
	if c.t then
		cursor[c.t].draw(c)
	end
--]]
end

cursor.editor={}

cursor.editor.make = function(c)
	c.value=1
end

cursor.editor.mousepressed = function(g,c,x,y,button)
	if button==1 then
		map.setcellvalue(g.level.map,c.x,c.y,c.value,true)
		c.draw=true
	elseif button==2 then
		map.setcellflag(g.level.map,c.x,c.y,EF.solid,true)
	elseif button==3 then
		map.erasecellflags(g.level.map,c.x,c.y,true)
	end
end

cursor.editor.wheelmoved = function(g,c,x,y)
	c.value=math.clamp(c.value+y,0,255)--TODO make this limit more dynamic?
end

--TODO input Game into this
cursor.editor.draw = function(c)
	local g=Game
	local m=g.level.map
	local tw,th=m.tile.width,m.tile.height

	local cx,cy=c.x,c.y
	local cell=map.getcellvalue(g.level.map,c.x,c.y)
	if c.snap then
		cx,cy=map.getcell(g.level.map,c.x,c.y)
		cx,cy=(cx-1)*tw,(cy-1)*th
	end

	if c.draw==true then
		c.draw=false
		LG.setCanvas(g.level.canvas.background)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.translate(xcamoff,ycamoff)
				LG.draw(Spritesheet[1],Quads[1][c.value],cx,cy)
			LG.translate(-xcamoff,-ycamoff)
		LG.setCanvas(g.canvas.main)
	end
	for i=1,#Enums.flags do
		LG.setColor(g.palette[EC.white])
		if flags.get(cell,i,16) then
			LG.setColor(g.palette[EC.red])
		end
		LG.points(cx+i*2,cy-5)
	end
	LG.print(c.value,cx+tw,cy+th)
	LG.draw(Spritesheet[1],Quads[1][c.value],cx,cy)

	local p=g.palette[EC.red]
	p[4]=180
	LG.setColor(p)
	if c.snap then
		LG.line(cx-1,cy,cx+2,cy)
		LG.line(cx,cy,cx,cy+2)
		LG.line(cx+tw,cy,cx+tw-3,cy)
		LG.line(cx+tw,cy,cx+tw,cy+2)
		LG.line(cx,cy+th,cx,cy+th-3)
		LG.line(cx,cy+th,cx+2,cy+th)
		LG.line(cx+tw,cy+th-1,cx+tw,cy+th-3)
		LG.line(cx+tw,cy+th,cx+tw-3,cy+th)
	else
		LG.rectangle("line",c.x-tw,c.y-th,tw,th)
	end
	
	LG.setColor(g.palette[EC.pure_white])
end

return cursor