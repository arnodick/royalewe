local function make(a,m,r)
	m.r=r
end

local function collision(r,dist)
	if dist<r then
		return true
	else
		return false
	end
end

local function draw(a)
	LG.circle("line",a.x,a.y,a.hitradius.r)
end

return
{
	make = make,
	collision = collision,
	draw = draw,
}