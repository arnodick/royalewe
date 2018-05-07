local function make(a,b,c1,c2)
	b.c1=c1
	b.c2=c2
end

local function draw(m,border)
	local alpha=230

	local r,g,b=unpack(Game.palette[border.c2])
	LG.setColor(r,g,b,alpha)
	local x,y=math.floor(m.x-m.w/2),math.floor(m.y-m.h/2)
	LG.rectangle("fill",x+1,y+1,m.w+1,m.h+1)

	LG.setColor(Game.palette[EC.black])
	LG.rectangle("fill",x,y,m.w,m.h)

	LG.setColor(Game.palette[border.c1])
	LG.rectangle("line",x,y,m.w,m.h)
end

return
{
	make = make,
	draw = draw,
}