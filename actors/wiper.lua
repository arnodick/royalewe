local function make(g,a,c)
	a.c=c or EC.red
	a.d=0
	a.vel=1
end

local function draw(g,a)
	LG.line(a.x,0,a.x,g.level.map.height)
	LG.setCanvas(g.level.canvas.background)
		local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
		LG.translate(xcamoff,ycamoff)
			LG.setColor(g.palette[EC.black])
			LG.line(a.x,0,a.x,g.level.map.height)
		LG.translate(-xcamoff,-ycamoff)
	LG.setCanvas(g.canvas.main)
end

local function collision(a)
	a.delete=true
end

return
{
	make = make,
	draw = draw,
	collision = collision,
}