--do this like denver, array of function like generators.wall
--send string "wall" into generator function to call the generators.wall function
--if table of string, do each of those generators in array order

local map={}
local generators={}
local drawmodes={}

map.generate = function(m,gen)
	local w,h=m.w,m.h
	local args=m.args

	for y=1,h do
		table.insert(m,{})
		for x=1,w do
			table.insert(m[y],0)
			if type(gen)=="table" then
				for i,v in ipairs(gen) do
					generators[v](m,w,h,x,y,args)
				end
			else
				generators[gen](m,w,h,x,y,args)
			end
		end
	end
	m.width=map.width(m)
	m.height=map.height(m)
end

map.load = function(m,filename)
	--loads map sprites and walls/entities from a hex populated textfile
	--returns map array
	local mapgrid=textfile.load(filename) --each cell (flags + integer) is loaded into map array
	copytable(m,mapgrid)

	--TODO do actorspawn flag stuff here to load actor from value of tile
--[[
	for a=1,map.width(m) do
		for b=1,map.height(m) do
			--TODO make this dynamic, loads entities based on flag value
			if getflag(m[a][b],Enums.wall) then
				actor.make(Game,0,0,(b-1)*TileW+TileW/2, (a-1)*TileH+TileH/2, TileW, TileH) --each cell that has a wall flag loads a wall entity
			end
		end
	end
--]]
	map.init(m,map.cellwidth(m),map.cellheight(m))
	m.width=map.width(m)
	m.height=map.height(m)
	return m
end

--TODO could probably do away with this by just checking if m.tile exists in code
map.init = function(m,w,h)
	if w and h then
		m.w,m.h=w,h
	end
	if not m.tile then
		m.tile={width=8,height=8}
	end
	--m.width=map.width(m)
	--m.height=map.height(m)
end

map.save = function(m,filename)
	textfile.save(m,filename)
end

map.draw = function(m,drawmode)
	for y=1,m.h do
		for x=1,m.w do
			if type(drawmode)=="table" then
				for i,v in ipairs(drawmode) do
					drawmodes[v](m,x,y)
				end
			else
				drawmodes[drawmode](m,x,y)
			end
		end
	end
end

map.cellwidth = function(m)
	return #m[1]
end

map.width = function(m)
	return map.cellwidth(m)*m.tile.width
end

map.cellheight = function(m)
	return #m
end

map.height = function(m)
	return map.cellheight(m)*m.tile.height
end

map.getcell = function(m,x,y)--returns the cell coords of worldspace coords
	local tw,th=m.tile.width,m.tile.height
	local cx,cy=math.floor((x+tw)/tw),math.floor((y+th)/th)
	cx=math.clamp(cx,1,m.w)
	cy=math.clamp(cy,1,m.h)
	return cx,cy
end

map.getcellvalue = function(m,x,y)--takes world x,y coordinates and returns the value of the cell under those coordinates
	local cx,cy=map.getcell(m,x,y)
	local c=flags.strip(m[cy][cx])
	return c
end

map.setcellvalue = function(m,x,y,v,worldcoords)--sets the value of a map cell in the low 16 bits while retaining the flags in the high 16 bits
	if worldcoords then
		x,y=map.getcell(m,x,y)
	end
	m[y][x]=bit.bor(flags.isolate(m[y][x]),v)
end

map.setcellflag = function(m,x,y,v,worldcoords)--sets a flag on the high 16 bits of a map cell while retaining the value in the low 16 bits
	local f=flags.fromenum(v)
	f=bit.lshift(f,16)
	if worldcoords then
		x,y=map.getcell(m,x,y)
	end
	m[y][x]=bit.bor(m[y][x],f)
end

map.erasecellflags = function(m,x,y,worldcoords)
	if worldcoords then
		x,y=map.getcell(m,x,y)
	end
	m[y][x]=flags.strip(m[y][x])
end

generators.walls = function(m,w,h,x,y)
	if x==1 or x==w or y==1 or y==h then
		map.setcellflag(m,x,y,EF.solid)
		--map.setcellvalue(m,x,y,3)
	end
end

generators.random = function(m,w,h,x,y,args)
	local pool=args.pool
	local v=pool[love.math.random(#pool)]
	m[y][x]=v
	--[[
	if v==2 or v==3 or v==4 then
		map.setcellflag(m,x,y,EF.animated)
	end
--]]
end

generators.increment = function(m,w,h,x,y)
	m[y][x]=x+(y-1)*w
end

generators.solid = function(m,w,h,x,y,args)
	local c=m[y][x]
	for i,v in ipairs(args.solid) do
		if v==c then
			--print(c)
			map.setcellflag(m,x,y,EF.solid)
		end
	end
end

generators.buildings = function(m,w,h,x,y,args)
	if love.math.random(args.buildings.chance)==1 then
		local door=false
		local width,height=love.math.random(args.buildings.width.min,args.buildings.width.max),love.math.random(args.buildings.width.min,args.buildings.width.max)
		for i=x,x-width,-1 do
			if i>0 and i<w then
				if door==false and love.math.random(10)==1 then
					m[y][i]=59
					door=true
				else
					m[y][i]=43
					map.setcellflag(m,i,y,EF.solid)
				end
				if y-height>0 and y-height<h then
					m[y-height][i]=11
					map.setcellflag(m,i,y-height,EF.solid)
				end
			end
		end
		for i=y,y-height,-1 do
			if i>0 and i<h then
				if i==y then
					m[i][x]=44
				elseif i==y-height then
					m[i][x]=12
				else
					m[i][x]=28
				end
				map.setcellflag(m,x,i,EF.solid)

				if x-width>0 and x-width<w then
					if i==y then
						m[i][x-width]=42
					elseif i==y-height then
						m[i][x-width]=10
					else
						m[i][x-width]=26
					end
					map.setcellflag(m,x-width,i,EF.solid)
				end
			end
		end
	end
end

drawmodes.grid = function(m,x,y)
	local g=Game
	if x==1 or y==1 then
		local tw,th=m.tile.width,m.tile.height
--TODO make a palette.fromenum function or something to input EC.red and get r,gr,b
		local c=g.palette[g.level.c or EC.white]
		local r,gr,b=c[1],c[2],c[3]
		LG.setColor(r,gr,b,120)

		if x==1 then
			--LG.line(0,y*th,map.width(m),y*th)
			LG.line(0,y*th,map.width(m),y*th)
		end
		if y==1 then
			LG.line(x*tw,0,x*tw,map.height(m))
		end
		LG.setColor(g.palette[16])
	end
end

drawmodes.numbers = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	local value=m[y][x]
	LG.print(value,(x-1)*tw,(y-1)*th)
end

drawmodes.sprites = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	local value=flags.strip(m[y][x])
	LG.draw(Spritesheet[1],Quads[1][value],(x-1)*tw,(y-1)*th)
end

drawmodes.isometric = function(m,x,y)
	local tw,th=m.tile.width,m.tile.height
	local t=Game.timer

	--if (y-1)*#m[y]+x<=t then
	local isox,isoy=(x-1)*tw/2+m.width/2,(y-1)*th/4+m.height/2
	local value=flags.strip(m[y][x])

	--LG.draw(Spritesheet[3],Quads[3][value],isox+230,isoy+50,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
	LG.draw(Spritesheet[3],Quads[3][value],isox,isoy,0,1,1,(y-1)*tw/2,(x-1)*-th/4)
	if Debugger.debugging then
		LG.points(isox,isoy)
	end	
	--end
end

return map