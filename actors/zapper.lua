local function make(g,a)
	a.c=c or EC.blue
	a.projvel=0
	a.rof=20
	a.num=1
	a.acc=0.1
	a.snd=2
	a.proj=EA.lightning
end

local function draw(a)

end

local function shoot(a)
	for b=1,a.num do
		local rand = love.math.random(-a.acc/2*100,a.acc/2*100)/50*math.pi
		actor.make(Game,a.proj,a.x,a.y,-a.angle+rand,a.projvel+math.randomfraction(0.5),a.bc)
	end
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}