local ray={}

ray.cast = function(x,y,d,dist,step)
	local r={}
	r.d=d
	for j=step,dist,step do
		local m=Game.level.map
		local cell=map.getcellvalue(m,x+(math.cos(d)*j),y+(math.sin(d)*j))
		if cell then
			--if cell~=0 then
			if flags.get(cell,EF.solid,16) then
				r.len=j
				return r
			end
		end
	end
	r.len=dist
	return r
end

return ray