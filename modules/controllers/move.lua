local function make(a,c)
	c.horizontal=0
	c.vertical=0
	c.last={}
	c.last.vertical=0
	c.last.horizontal=0
	c.duration={}
	c.duration.horizontal=0
	c.duration.vertical=0
end

local function control(a,c,gs,c1,c2)	
	c.last.vertical=c.vertical
	c.last.horizontal=c.horizontal
	if c.last.vertical~=0 then
		c.duration.vertical=c.duration.vertical+gs
	else
		c.duration.vertical=0
	end

	c.horizontal,c.vertical=c1,c2
	controller.deadzone(c,0.25)
end

return
{
	make = make,
	control = control,
}