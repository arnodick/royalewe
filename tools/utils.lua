	local function clamp(v,mi,ma,wrap)--TODO recursive clamp
	wrap=wrap or false
	if not wrap then
		if v<mi then v=mi
		elseif v>ma then v=ma
		end
	else
		--if v<mi then v=ma
		if v<mi then v=ma+1+v-mi
		elseif v>ma then v=mi-1+v-ma
		end
	end
	return v
end

local function choose(...)
	local arg={...}
	return arg[love.math.random(#arg)]
end

local function randomfraction(n)
	return love.math.random(n*1000000)/1000000
end

local function snap(v,inc,snapto)--TODO does this need a negative version
	if v-inc<=snapto+inc then--TODO make this addition instead of subtraction?
		return snapto
	else
		return v-inc
	end
end

--loads a bunch of files that share an extension from a specific directory
--returns a table with all the directory/filenames of those files
--NOTE: unpack() the output to use it as an argument in another function
local function getfiles(dir,ext)
	local filelist = {}
	local files = love.filesystem.getDirectoryItems(dir)
	for i = #files,1,-1 do --decrements bc had to delete files from a table before
		local filedata = love.filesystem.newFileData("code", files[i])
		local filename = filedata:getFilename() --get the file's name
		if filedata:getExtension() == ext
		and filename ~= "conf.lua"
		and filename ~= "main.lua" then --it's a library, so include it
			table.insert(filelist,dir.."/"..filename)
		end
	end
	return filelist
end

local function filterfiles(folder,ext)
	local files = love.filesystem.getDirectoryItems(folder)
	for i=#files,1,-1 do
		local filedata = love.filesystem.newFileData("code", files[i])
		if filedata:getExtension()~=ext then
			table.remove(files,i)
		end
	end
	return files
end

function copytable(copyto,copyfrom)
	--copies the values and tables from a source table and adds them to the target table
	--a new table is NOT made, so references to the target table are not broken
	--also retains any values that were in the target table before copying (unless the source table has a value with the same key, in which case the value in the target table with that key is overwritten)
	for k,v in pairs(copyfrom) do
		if type(v)~="table" then
			copyto[k]=v
		else
			copyto[k]={}
			copytable(copyto[k],v)
		end
	end
end

local function drawbox(x,y,w,a)
	for i=0,3 do
		LG.line(x+math.cos(a+i*0.25*math.pi*2)*w/2,y+math.sin(a+i*0.25*math.pi*2)*w/2,x+math.cos(a+(i+1)*0.25*math.pi*2)*w/2,y+math.sin(a+(i+1)*0.25*math.pi*2)*w/2)
	end
end

local function printformat(text,x,y,limit,align,c1,c2,alpha)
	limit=limit or Game.width - x
	align=align or "left"
	alpha=alpha or 255
	for xoff=0,1 do
		for yoff=1,1 do
			local r,g,b=unpack(Game.palette[c2])
			LG.setColor(r,g,b,alpha)
			LG.printf(text,x+xoff,y+yoff,limit,align)

			r,g,b=unpack(Game.palette[c1])
			LG.setColor(r,g,b,alpha)
			LG.printf(text,x,y,limit,align)
		end
	end
	LG.setColor(Game.palette[EC.pure_white])
end

local function lightness(r,g,b)
	r,g,b=r/255,g/255,b/255
	max=math.max(r,g,b)
	min=math.min(r,g,b)
	return (max+min)/2
end

local function textify(image,scale,chars,smallcanvas,bigcanvas,charw,charh)
	--local g=Game
	LG.setCanvas(smallcanvas)
		LG.clear()
		LG.draw(image,0,0,0,scale,scale)
	LG.setCanvas(bigcanvas)
		LG.clear()
		local imgdata=smallcanvas:newImageData(0,0,smallcanvas:getWidth(),smallcanvas:getHeight())
		for y=0,imgdata:getWidth()-1 do
			for x=0,imgdata:getHeight()-1 do
				local r,gr,b=imgdata:getPixel(x,y)
				local l=LG.lightness(r,gr,b)
				l=math.ceil(l*10)
				LG.setColor(r,gr,b)
				LG.print(chars[l+1],x*charw,y*charh)
			end
		end
		LG.setColor(255,255,255) --sets draw colour back to normal
		local mainimgdata=bigcanvas:newImageData(0,0,bigcanvas:getWidth(),bigcanvas:getHeight())
	return LG.newImage(mainimgdata)
end

local function drawtobackground(background,drawable,x,y,a,scale,scale,xoff,yoff,alpha)
	local g=Game
	local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
	LG.setCanvas(background)
		if alpha then
			LG.setColor(255,255,255,alpha)
		end
		LG.draw(drawable,x+xcamoff,y+ycamoff,a,scale,scale,xoff,yoff)
	LG.setCanvas(g.canvas.main)
end

math.clamp = clamp
math.choose = choose
math.randomfraction = randomfraction
math.snap = snap
love.filesystem.getfiles = getfiles
love.filesystem.filterfiles = filterfiles
love.graphics.drawbox = drawbox
love.graphics.printformat = printformat
love.graphics.lightness = lightness
love.graphics.textify = textify
love.graphics.drawtobackground = drawtobackground
