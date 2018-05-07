local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	--TODO get rid of 1 beloew
	module.make(m,EM.controller,EMC.move,EMCI.gamepad)
	module.make(m,EM.controller,EMC.action,EMCI.gamepad)
	--module.make(m,EM.controller,EMC.select,EMC.selects.gamepad_menu_select)
end

local function control(m,gs)
	controller.update(m,gs)
	local c=m.controller.move

	if c.vertical<0 then
		if c.last.vertical>=0 or (c.duration.vertical>30 and math.floor(Game.timer)%4==0) then
			m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif c.vertical>0 then
		if c.last.vertical<=0 or (c.duration.vertical>30 and math.floor(Game.timer)%4==0) then
			m.text.index=math.clamp(m.text.index+1,1,#m.text,true)
		end
	end
end

local function gamepadpressed(m,button)
	if not m.controller.action.lastuse then
		if button=='start' or button=='a' then
			local i=m.text.index
			if m.menu_functions[i] then
				m.menu_functions[i](unpack(m.menu_function_args[i]))
			end
		end
	end
end

--[[
local function draw(m)
end
--]]

return
{
	make = make,
	control = control,
	gamepadpressed = gamepadpressed,
}