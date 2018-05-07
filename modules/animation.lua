local function make(a,m,t,...)
	m[EM.animations[t]]={}
	run(EM.animations[t],"make",m[EM.animations[t]],...)
end

local function draw(animname,anim)
	if _G[animname]["draw"] then
		return _G[animname]["draw"](anim)--TODO why return here?
	end
end

return
{
	make = make,
	draw = draw,
}