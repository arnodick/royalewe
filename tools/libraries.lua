--loads all the library.lua files you've made
--it's dynamic ie if you put a library.lua file in the working directory it will load it into the game automatically
local function load(dir)
	local files = love.filesystem.getDirectoryItems(dir) --get all the files+directories in working dir
	for i = #files,1,-1 do --decrements bc had to delete files from a table before
		local filedir=files[i]
		if dir~="" then
			filedir=dir.."/"..files[i]
		end
		if love.filesystem.isFile(filedir) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("code", filedir)
			local filename = filedata:getFilename() --get the file's name
			if filedata:getExtension() == "lua" --if it's a lua file and isn't a reserved file
			and filename ~= "conf.lua"
			and filename ~= "main.lua" then --it's a library, so include it
				filename = string.gsub(filename, ".lua", "")
				local globalname = string.gsub(filename, ".*/", "") --global name cannot be "actors/actor", must be just "actor"
				_G[globalname] = require(filename)
			end
		elseif love.filesystem.isDirectory(filedir) then --if it's a dir, then recursively load any .lua files in there
			if filedir~=".git" and filedir~="__MACOSX" then
				libraries.load(filedir)
			end
		end
	end
end

return
{
	load = load,
}