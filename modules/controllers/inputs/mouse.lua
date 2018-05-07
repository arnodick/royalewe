local function aim(a)--TODO actor in here
	local g=Game
	--local mx,my=love.mouse.getPosition()
	--return mx/(g.screen.width/g.width),my/(g.screen.height/g.height)

--[[
	local x,y=love.mouse.getPosition()
	local maxdistance=30
	if vector.distance(a.x,a.y,x,y)>maxdistance then
		local dir=vector.direction(a.x,a.y,x,y)
		x,y=a.x+math.cos(dir)*maxdistance,a.y+math.sin(dir)*maxdistance
	--	love.mouse.setPosition(x,y)
	end
	x=math.clamp(x,0,map.width(g.level.map))
	y=math.clamp(y,0,map.height(g.level.map))
	love.mouse.setPosition(x,y)


	return x,y
--]]
	return a.cursor.x,a.cursor.y
end

local function action()
	local use,action=false,false

	if love.mouse.isDown(1) then
		use=true
	end
	if love.mouse.isDown(2) then
		action=true
	end

	return use,action
end


return
{
	aim = aim,
	action = action,
}