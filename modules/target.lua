local function make(c,m,target_or_x,y)
	if type(target_or_x)=='table' then
		c.target=target_or_x
	else
		m.x=target_or_x
		m.y=y
	end
end

return
{
	make = make,
}