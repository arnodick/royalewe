local function make(a,m,easing,variablename,startvalue,change,duration,complete,complete_args,t)
	m.starttime=Game.timer
	m.easing=easing
	m.variablename=variablename
	m.startvalue=startvalue
	m.change=change
	m.duration=duration
	m.complete=complete
	m.complete_args=complete_args
	m.t=t
	if m.t then
		run(EM.transitions[m.t],"make",a,m)
	end
	a[m.variablename]=startvalue
	--print(startvalue)
	--print(startvalue+change)
end

local function control(a,m)
	local timeelapsed=Game.timer-m.starttime
	a[m.variablename]=m.easing(timeelapsed,m.startvalue,m.change,m.duration)

	if m.t then
		run(EM.transitions[m.t],"control",a,m)
	end

	if timeelapsed>=m.duration then
		if m.complete then
			m.complete(unpack(m.complete_args))
		end
		a[m.variablename]=m.startvalue+m.change
		a.transition=nil
	end
end

return
{
	make = make,
	control = control,
}