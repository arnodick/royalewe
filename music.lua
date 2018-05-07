local function load()
	local s = {}
	s.sources={}
	local files = love.filesystem.getDirectoryItems("music") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("music/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			if ext == "ogg" or ext == "wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				table.insert(s.sources,love.audio.newSource("music/"..filename,"static"))
				s.sources[i]:setLooping(true)
			end
		end
	end
	return s
end

local function play(index)
	local i=index
	local source = Music.sources[i]
	if source~=nil then
		love.audio.play(source)
	end
end

return
{
	load = load,
	play = play,
	update = update,
}