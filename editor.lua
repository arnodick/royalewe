local editor={}

editor.make = function(g)
	g.editor={}
	--module.make(g.editor,EM.cursor,"editor",true)
	if g.level then
		module.make(g.editor,"cursor","editor",true)
	end
end

editor.control = function(g)
	if g.editor.cursor then
		cursor.update(g.editor.cursor)
	end
end

editor.keypressed = function(g,key)
	if love.keyboard.isDown('lctrl') then
		if key=="s" then
			love.keyboard.setTextInput(true)
			module.make(g.hud,EM.menu,EMM.text,100,100,200,200,{"type file name",""},EC.orange,EC.dark_green)
		end
	elseif key=="return" then
		if g.hud.menu then
			map.save(g.level.map,g.hud.menu.text[2]..".txt")
			--love.keyboard.setTextInput(false)
			g.hud.menu=nil
		end
	elseif key=="up" then
		g.camera.y=g.camera.y-8
	elseif key=="down" then
		g.camera.y=g.camera.y+8
	elseif key=="left" then
		g.camera.x=g.camera.x-8
	elseif key=="right" then
		g.camera.x=g.camera.x+8
	end
end

function love.textinput(t)
	local g=Game
	if g.hud.menu then
		g.hud.menu.text[2]=g.hud.menu.text[2]..t
	end
end

editor.mousepressed = function(g,x,y,button)
	if g.editor.cursor then
		cursor.mousepressed(g,g.editor.cursor,x,y,button)
	end
end

editor.wheelmoved = function(g,x,y)
	if love.keyboard.isDown('lctrl') then
		g.camera.zoom=g.camera.zoom+y/10
	else
		if g.editor.cursor then
			cursor.wheelmoved(g,g.editor.cursor,x,y)
		end
	end
end

editor.draw = function(g)
	LG.printformat("EDITOR",g.camera.x-g.width/2,g.camera.y-15,g.width,"center",EC.red,EC.blue)
end

return editor