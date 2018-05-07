local function make(g,a,c,size,spr)
	a.c=c or EC.pure_white
	a.size=size or 1
	a.spr=spr or 1
	a.scalex=1
end

local function control(g,a)
	a.scalex=math.sin(g.timer)
	if g.timer-a.delta>=30 then
		sfx.play(8)
		for i=1,20 do
			actor.make(g,EA.spark,a.x,a.y)
			--actor.load(g,"spark",a.x,a.y,math.randomfraction(math.pi*2),nil,math.randomfraction(2)+2,EC.yellow)
		end
		a.delete=true
	end
end

return
{
	make = make,
	control = control,
}