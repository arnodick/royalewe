local function load(positional,pitchupdate)
	local s = {}
	s.sources={}
	s.pitchoffs={}
	local files = love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			if ext == "ogg" or ext == "wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				--table.insert(s.sources,love.audio.newSource("sfx/"..filename,"static"))
				table.insert(s.sources,love.sound.newSoundData("sfx/"..filename))
			end
			table.insert(s.pitchoffs,0)
		end
	end
	if positional then
		love.audio.setDistanceModel("exponent")
		love.audio.setOrientation(0,0,-1,0,1,0)
	end
	s.positional=positional
	s.pitchupdate=pitchupdate
	return s
end

local function play(index,x,y)
	local interrupt = interrupt or true
	--local i=tostring(index)
	local i=index
	local source = SFX.sources[i]
	--local source = love.audio.newSource("sfx/"..SFX[tostring(index)],"static")
	if source~=nil then
--[[
		if interrupt then
			love.audio.stop(source)
		end
--]]
		source=love.audio.newSource(source,"static")
		local play=false
		if not SFX.positional then
			play=true
		elseif x~=nil and y~=nil and SFX.positional then
			source:setRelative(false)
			source:setPosition(x,y,0)
			--source:setRolloff(0.05)
			source:setRolloff(0.4)
			if vector.distance(x,y,Game.camera.x,Game.camera.y)<320 then
				play=true
			end
		end
		if play then
			local pitch=math.clamp(Game.speed,0.2,1)
			SFX.pitchoffs[i]=math.randomfraction(0.2)-0.1
			source:setPitch(pitch+SFX.pitchoffs[i])
			love.audio.play(source)
		end
	end
end

local function update(s,gs)
--[[
	if s.pitchupdate then
		for i,v in pairs(s.sources) do
			local pitch=math.clamp(gs,0.2,1)
			v:setPitch(pitch+s.pitchoffs[i])
		end
	end
--]]
end

return
{
	load = load,
	play = play,
	update = update,
}