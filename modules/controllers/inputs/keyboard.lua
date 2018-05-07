local function move()
	local horizontal,vertical=0,0
	local moving=false

	if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
		horizontal=-1
		moving=true
	elseif love.keyboard.isDown('right') or love.keyboard.isDown('d')  then
		horizontal=1
		moving=true
	end

	if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
		vertical=-1
		moving=true
	elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
		vertical=1
		moving=true
	end

	if moving then
		local direction=vector.direction(horizontal,vertical)
		horizontal,vertical=math.cos(direction),math.sin(direction)
	end

	return horizontal,vertical
end

local function action()
	local use,action=false,false

	if love.keyboard.isDown('z') then
		use=true
	else
		use=false
	end

	if love.keyboard.isDown('x') then
		action=true
	else
		action=false
	end

	return use,action
end

return
{
	move = move,
	action = action,
}