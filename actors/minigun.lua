local function make(g,a,c,bc)
	a.c=c or EC.blue
	a.bc=EC.blue
	a.size=1
	a.sprinit=163
	a.spr=a.sprinit
	a.projvel=8
	--a.rof=1
	--a.num=2
	a.rof=3
	a.num=6
	a.acc=0.2
	a.snd=2
	a.proj=EA.bullet
	module.make(a,EM.item)
	module.make(a,EM.sound,6,"get")
end

local function draw(a)

end

local function shoot(a)
	for b=1,a.num do
		actor.make(Game,EA.cloud,a.x,a.y,-a.angle+math.randomfraction(1)-0.5,math.randomfraction(1))
		local rand = love.math.random(-a.acc/2*100,a.acc/2*100)/50*math.pi
		actor.make(Game,a.proj,a.x,a.y,-a.angle+rand,a.projvel+math.randomfraction(0.5),a.bc)
		--local d=-a.angle+rand
		--actor.load(Game,"bullet",a.x,a.y,-a.angle+rand,-d,a.projvel+math.randomfraction(0.5),a.bc)
	end
end

return
{
	make = make,
	draw = draw,
	shoot = shoot,
}