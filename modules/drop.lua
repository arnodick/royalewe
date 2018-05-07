local function make(a,drop,dropname,level)
	drop.name=dropname
	drop.level=level
end

local function spawn(a,x,y)
	local dropname=a.drop.name
	if dropname then
		local drop=actor.make(Game,EA[dropname],math.floor(x),math.floor(y))
		if a.drop.level then --TODO clean this up
			drop.level=a.drop.level
		end
	end
end

return
{
	make = make,
	spawn = spawn,
}