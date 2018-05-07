local function make(a,c)
	c.use=false
	c.action=false
	c.lastuse=true
	c.lastaction=false
	c.useduration=0
	c.actionduration=0
end

local function control(a,c,gs,c1,c2)
	c.lastuse=c.use
	c.lastaction=c.action
	
	c.use,c.action=c1,c2

	if c.use then
		if c.lastuse then
			c.useduration=c.useduration+gs
		end
	else
		c.useduration=0
	end
end

return
{
	make = make,
	control = control,
}