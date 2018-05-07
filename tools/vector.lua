--TODO maybe put this in math?

local function components(x,y,x2,y2)
	return x2-x, y2-y
end

local function normalize(vx,vy)
	local l = vector.length(vx,vy)
	return vx/l, vy/l
end

local function length(x,y)
	return math.sqrt(x^2+y^2)
end

local function distance(x,y,x2,y2)
	local w,h = x2 - x, y2 - y
	return vector.length(w,h)
end

local function direction(vx,vy)
--this works with witchwizz
---[[
	local hack=0
	if vy<0 then
		hack=math.pi*2
	end
	return math.atan2(vy,vx)+hack
--]]
	--NOTE this works with protosnake
	--return math.atan2(vy,vx)
	--return math.clamp(math.atan2(vy,vx),0,math.pi*2,true)
end

local function mirror(vx,vy,hor)
	hor = hor or true
	if hor then
		vx = -vx
	else
		vy = -vy
	end
	return vx, vy
end

return
{
	components = components,
	normalize = normalize,
	length = length,
	distance = distance,
	direction = direction,
	mirror = mirror,
}