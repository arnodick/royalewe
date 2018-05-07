local item={}

item.make = function(a)
	a.angle=-0.79--TODO put this in actor.make
	a.delta=0--NOTE need this bc actor.make sets delta to Game.timer, so any actor not spawning at Game.timer==0 can't shoot
	a.held=false
	
	module.make(a,EM.sound,10,"get")

	local g=Game
	if not g.actors.items then
		g.actors.items={}
	end
	table.insert(g.actors.items,a)
	game.state.run(g.name,"item","make",g,a)
	return a
end

item.control = function(a,gs)
	local g=Game
	game.state.run(g.name,"item","control",g,a,gs)
end

item.carry = function(a,user)
	game.state.run(Game.name,"item","carry",a,user)
end

item.use = function(a,gs,user,vx,vy,shoot)
	a.angle=vector.direction(vx,vy)
	a.vec[1]=math.cos(a.angle)
	a.vec[2]=math.sin(a.angle)

	if a.delta<=0 then
		if shoot then
			sfx.play(a.snd,a.x,a.y)
			run(EA[a.t],"shoot",a,gs)
			a.delta=a.rof
		end
	else 
		a.delta=a.delta-1*gs
	end
end

item.pickup = function(a,user)
	local g=Game
	return game.state.run(g.name,"item","pickup",g,a,user)
end

return item