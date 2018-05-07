local player={}

player.make = function(g,a,singleplayer)
	if singleplayer then
		g.player=a
	else
		table.insert(g.players,a)
	end
	a.flags=flags.set(a.flags,EF.player,EF.persistent)
	game.state.run(g.name,"player","make",g,a)
end

player.control = function(g,a)
	game.state.run(g.name,"player","control",g,a)
end

player.draw = function(g,a)
	game.state.run(g.name,"player","draw",g,a)
end

player.damage = function(g,a)
	game.state.run(g.name,"player","damage",g,a)
end

player.dead = function(g,a)
	game.state.run(g.name,"player","dead",g,a)
end

return player