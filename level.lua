local level={}

--[[
level.load = function(g,dir,ext)
	--loads a folder of ini files from a folder into the g.levels table, so they can be accessed quickly by the game
	--ie: ALL level info is loaded at the start of the game, each level is then accessed from the g.levels when it is loaded
	--each file in the folder gets its own table in l
	g.levels=game.files(g,dir,ext)
end
--]]

level.make = function(g,index,mode)
	local l={}
	if mode then
	--TODO put if mode==string then l.modename=mode etc
	--l.mode=Enums.games.modes[mode]
	--TODO put this in json file
		l.mode=mode
		l.modename=Enums.modes[mode]
	end
	if not g.levels then
		g.levels={}
	end
	g.levels.index=index
	if g.levels[index] then
		copytable(l,g.levels[index])
	end
	if l.map then
		if l.map.file then
			--l.map=map.load("/maps/"..l.map.file..".txt")
			map.load(l.map,"/maps/"..l.map.file..".txt")
		elseif l.map.generators then
			map.generate(l.map,l.map.generators)
		end
		l.canvas={background=LG.newCanvas(l.map.w*l.map.tile.width,l.map.h*l.map.tile.height)}
		l.bgdraw=true
	end
	g.level=l
	game.state.run(g.name,"level","make",g,l,index)
end

return level