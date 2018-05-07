local function move(a,c)
	local tarx,tary=a.x+1,a.y+1
	if c.target then
		tarx,tary=c.target.x,c.target.y
	end
	local dir=vector.direction(vector.components(a.x,a.y,tarx,tary))
	--local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
	return math.cos(dir),math.sin(dir)
end

local function aim(a,c)
	local dir=vector.direction(vector.components(a.x,a.y,c.target.x,c.target.y))
	return math.cos(dir),math.sin(dir)
end

local function action(a,c)
	local use=false
	local action=false

	if math.randomfraction(1)<=c.chance[1] then
		use=true
	end
	if math.randomfraction(1)<=c.chance[2] then
		action=true
	end

	return use, action
end


return
{
	move = move,
	aim = aim,
	action = action,
}