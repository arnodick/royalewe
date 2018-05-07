local function move(a)
	local j=Joysticks[a.controller.move.id]
	return j:getGamepadAxis("leftx"),j:getGamepadAxis("lefty")
end

local function aim(a)
	local j=Joysticks[a.controller.move.id]
	return j:getGamepadAxis("rightx"),j:getGamepadAxis("righty")
end

local function action(a)
	local j=Joysticks[a.controller.move.id]
	local use,action=false,false

	if j:isDown(3) or j:getGamepadAxis("triggerright")>0 then
		use=true
	end
	if j:isDown(1) or j:getGamepadAxis("triggerleft")>0 then
		action=true
	end

	return use,action
end

return
{
	move = move,
	aim = aim,
	action = action,
}