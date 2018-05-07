local function make(a,c)
	c.horizontal=0
	c.vertical=0
end

local function control(a,c,gs,c1,c2)
	if c.input==EMCI.mouse then
		local dir=vector.direction(vector.components(a.x,a.y,c1,c2))
		c1=math.cos(dir)
		c2=math.sin(dir)
	end
	c.horizontal,c.vertical=c1,c2
	--controller.deadzone(c,0.25)
end

return
{
	make = make,
	control = control,
}