local function make(x,y)
	local c={}
	c.x=x
	c.y=y
	c.zoom=1
	c.hit=0
	return c
	--TODO this should insert itself into Game.cameras, can have multiple cameras and jump around from one to another
end

local function control(c,gs)
	if c.target then
		c.x=c.target.x
		c.y=c.target.y
	elseif c.transition then
		transition.control(c,c.transition)
	end
end

return
{
	make = make,
	control = control,
}