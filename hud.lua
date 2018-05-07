local function make(g,...)
	g.hud={}
	if _G[g.name][g.state].hud then
		_G[g.name][g.state].hud.make(g,g.hud,...)
	end
end

local function draw(g,h,...)
	if _G[g.name][g.state].hud then
		_G[g.name][g.state].hud.draw(g,h,...)
	end

	if h.menu then
		menu.draw(h.menu)
	end
end

local function gamepadpressed(g,joystick,button)
	local m=g.hud.menu
--TODO comment this out and see if it still works after generalized to game
	if m then
		menu.gamepadpressed(m,button)
	end
end

return
{
	make = make,
	draw = draw,
	gamepadpressed = gamepadpressed,
}