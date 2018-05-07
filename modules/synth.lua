--make this play a synth every frame
--the synth it plays is input as {waveform= etc}
--can add transition module to a synth to change its freq
local function make(a,m,waveform,note,length,notes)
	m.waveform=waveform
	m.note=note
	m.length=length
	m.notes=notes--an array of strings with the notes in it
	if m.notes then
		m.range=#m.notes
	end
	m.start=Game.timer
end

local function control(a,m)
	
	local g=Game
	if g.timer-m.start<=m.length then
		local note=m.note
		if m.notes then
			note=m.notes[math.ceil(((g.timer-m.start)/m.length)*m.range)]
		end
		
		--if g.timer%2==0 then
		--local saw = denver.get({waveform=m.waveform, frequency=m.note+math.sin(g.timer/10)*100, length=1/60})

		--+noteoff+math.sin(g.timer/10)*100
		local saw = denver.get({waveform=m.waveform, frequency=note, length=1/60})
		saw:setLooping(false)
		love.audio.play(saw)
		--end
	else
		m.synth=nil
	end
end

return
{
	make = make,
	control = control,
}