local function load(dir,...)
	local e={}
--[[
	--NOTE bring this back if you want to load manually generated enums from the enums.ini files in enums directory!
	if dir=="" then
		e=LIP.load("enums/enums.ini")
	end
--]]
	local dirstoread={...}
	local filesindir = love.filesystem.getDirectoryItems(dir)
	for i,fileordir in pairs(filesindir) do
		if dir~="" then --just to make subfolders have the proper syntax
			fileordir=dir.."/"..fileordir
		end
		if love.filesystem.isFile(fileordir) then
			local filedata = love.filesystem.newFileData("code", fileordir)
			local filename = filedata:getFilename()
			local enumdir=false
			for j=1,#dirstoread do
				if dir~="" or dir==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				local enumname=string.gsub(filename, ".*/", "")--gets rid of any directory strings in filename ie: actors/dog.lua becomes dog.lua
				enumname=string.gsub(enumname, ".lua", "")
				table.insert(e,enumname)
				e[enumname]=#e
			end
		elseif love.filesystem.isDirectory(fileordir) then
			local enumname=string.gsub(fileordir, ".*/", "")--gets rid of any directory strings in filename ie: actors/dog.lua becomes dog.lua
			local enumdir=false
			for j=1,#dirstoread do
				if dir~="" or enumname==dirstoread[j] then
					enumdir=true
				end
			end
			if enumdir then
				e[enumname]=enums.load(fileordir,...)
			end
		end
	end
	return e
end

local function constants(e) --NOTE this function has side effects! makes global variables
	--if e.games then
		--TODO here is where change to EA=e.actors
		if e.actors then
			EA=e.actors
		end
	--end
	if e.modules then
		EM=e.modules
		if EM.menus then
			EMM=EM.menus
		end
		if EM.controllers then
			EMC=EM.controllers
			if EMC.inputs then
				EMCI=EMC.inputs
			end
		end

	end
	if e.flags then
		EF=e.flags
	end
	LG=love.graphics
end

return
{
	load = load,
	constants = constants,
}