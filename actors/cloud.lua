--TODO for load actor attributes like c, size, angle etc from ini, do a[variablename]=valuefromini
-- maybe even do modules through ini? what would this look like?
-- [modulename ie explosion]
-- r=12
local function make(g,a,c,size)
	a.cinit=c or EC.indigo
	a.c=a.cinit
	a.size=size or 6
	a.angle=-a.d
	a.anglespeed=0.02
	a.pointdirs={}
	for i=0,3 do
		table.insert(a.pointdirs, math.randomfraction(math.pi/2) + (math.pi/2)*i )
	end
	a.r=size
	a.alpha=255
	a.flags=flags.set(a.flags,EF.bouncy)
end

local function control(g,a)
	local delta=g.timer-a.delta
	a.r=a.size-delta/5
	a.alpha=a.alpha-2
	if a.r<1 then
		a.delete=true
	end
end

local function draw(g,a)
	--local r,g,b=
	--LG.setColor(100,100,100,a.alpha)
	local points={}
	for i=1,#a.pointdirs do
		table.insert(points,a.x+math.cos(a.pointdirs[i]+a.angle)*a.r)
		table.insert(points,a.y+math.sin(a.pointdirs[i]+a.angle)*a.r/2.5)
	end
	LG.polygon("fill",points)
--[[
	LG.setCanvas(g.level.canvas.background)
		local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
		LG.translate(xcamoff,ycamoff)
			LG.polygon("fill",points)
		LG.translate(-xcamoff,-ycamoff)
	LG.setCanvas(g.canvas.main)
	--]]

	if Debugger.debugging then
		LG.setColor(g.palette[EC.green])
		LG.points(a.x,a.y)
		LG.setColor(g.palette[EC.red])
		for i=1,#points,2 do
			LG.points(points[i],points[i+1])
		end
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}