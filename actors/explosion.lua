local function make(g,a,c,size)
	sfx.play(1,a.x,a.y)
	a.cinit=c or EC.white
	a.c=a.cinit
	a.size=size or 20
	a.r=0
	g.screen.shake=a.size--TODO make shake module, does this then deletes itself
	--instead of having an explosion actor, have an explosion flag, which does all the stuff an explosion would normally do
	a.flags=flags.set(a.flags,EF.persistent)
end

local function control(g,a,gs)
	local delta = (g.timer-a.delta)
	a.r = a.size*(delta/6)
	if a.r>=a.size then
		for j=1,6*a.size do
			local s = math.randomfraction(a.size/2)
			local dir = math.randomfraction(math.pi*2)
			local d = math.randomfraction(math.pi*2)
			actor.make(g,EA.cloud,a.x+math.cos(dir)*s,a.y+math.sin(dir)*s,d,math.randomfraction(0.5))
		end
		a.delete=true
	end
end

local function draw(g,a)
	LG.circle("fill",a.x,a.y,a.r,16)
	if Debugger.debugging then
		LG.setColor(g.palette[11])
		LG.circle("line",a.x,a.y,a.r)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}