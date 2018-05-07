local function make(a,m,variablename,flashvalue,startvalue,duration)
	m.starttime=Game.timer
	m.variablename=variablename
	m.flashvalue=flashvalue
	m.startvalue=startvalue
	m.duration=duration
end

local function control(a,m)
	local timeelapsed=Game.timer-m.starttime
	a[m.variablename]=m.flashvalue
	if timeelapsed>=m.duration then
		a[m.variablename]=m.startvalue
		a.flash=nil
	end
end

return
{
	make = make,
	control = control,
}