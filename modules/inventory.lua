local function make(a,m,size)
	m.i=1
	m.max=size or 1
end

local function control(a,inventory)
	for i,v in ipairs(inventory) do
		item.carry(v,a)
	end
end

return
{
	make = make,
	control = control,
}