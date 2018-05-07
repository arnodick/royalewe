local function make(g,a,c)
	a.c=c or EC.yellow
	a.d=math.randomfraction(math.pi*2)
	a.vel=math.randomfraction(2)+2
	a.decel=0.1
	a.flags=flags.set(a.flags,EF.bouncy,EF.persistent)
end

local function control(g,a)
	if a.vel<=0 then
		a.delete=true
	end
end

local function draw(g,a)
	LG.points(a.x,a.y)
	if a.vel<=0 then
		LG.setCanvas(g.level.canvas.background)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.points(a.x+xcamoff,a.y+ycamoff)
		LG.setCanvas(g.canvas.main)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}