local function make(g,a,c,bc)
	--a.c=c or EC.green
	a.bc=bc
	a.size=1
	a.sprinit=178
	a.spr=a.sprinit
	--a.projvel=4
	a.projvel=6
	a.rof=10
	a.num=1
	a.acc=0.015
	a.snd=2
	a.proj=EA.bigbullet
	a.scalex=1
	a.scaley=1
	module.make(a,EM.item)
	module.make(a,EM.sound,6,"get")
end

local function draw(g,a)
	if Debugger.debugging then
		LG.print(a.hp,a.x,a.y)
	end
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