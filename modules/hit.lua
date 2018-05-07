local function make(a,m,sound,time,colour)
	m.hit=0
	m.sfx=sound
	m.time=time
	m.colour=colour
end

local function control(m,a,gs)
	if m.hit>0 then
		m.hit=m.hit-gs
	else
		a.c=a.cinit--TODO this is probably where weird colour stuff is happenin with snakes
	end
end

local function damage(m,a)
	if m.time then
		if m.hit<m.time then
			m.hit=m.time
		end
		a.c=m.colour
	end
end

return
{
	make = make,
	control = control,
	damage = damage,
}