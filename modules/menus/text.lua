text={}

text.draw = function(m)
	if type(m.text)=="table" then
		for i=1,#m.text do
			local linealpha=255
			if m.text.index then
				if m.text.index~=i then
					linealpha=50
				end
			end
			LG.printformat(m.text[i],m.x-m.w/2,m.y-m.h/2+12*i,m.w,m.align,m.c1,m.c2,linealpha)
		end
	else
		LG.printformat(m.text,m.x-m.w/2,m.y-m.h/2,m.w,m.align,m.c1,m.c2)
	end
end

return text