local function load(spr,tw,th)
	--takes in a spritesheet file(PNG) and some tile sizes
	--returns the spritesheet object and its QUADS
	local spritesheet=LG.newImage(spr)
	local quads={}
	local spritesheetW,spritesheetH=spritesheet:getWidth(),spritesheet:getHeight()
	local spritesheetTilesW,spritesheetTilesH=spritesheetW/tw,spritesheetH/th
	for b=0, spritesheetTilesH-1 do
		for a=0, spritesheetTilesW-1 do
			quads[a+b*spritesheetTilesW]=LG.newQuad(a*tw,b*th,tw,th,spritesheetW,spritesheetH)
		end
	end
	return spritesheet,quads
end

local function make(a)
--TODO this sprinit
end

--TODO this should maybe just go in actor? actor.draw with drawmode?
local function draw(a)
	local spr=a.spr
--[[
	if Game.actordata[EA[a.t] ] then
		spr=Game.actordata[EA[a.t] ].spr
	end
--]]
	if spr then
		--local size=a.size or Game.actordata[EA[a.t]].size
		local size=a.size or 1

		local anim={}
		anim.frames=0

		if a.animation then
			for k,v in pairs(a.animation) do
				anim[k]=animation.draw(k,v)
			end
		end

		local scalex,scaley=1,1
		if a.scalex then scalex=a.scalex end
		if a.scaley then scaley=a.scaley end
		
		--LG.draw(Spritesheet[a.size],Quads[a.size][a.spr+anim.frames],a.x,a.y,a.angle,scalex,scaley,(a.size*8)/2,(a.size*8)/2)
		LG.draw(Spritesheet[size],Quads[size][spr+anim.frames],a.x,a.y,a.angle,scalex,scaley,(size*8)/2,(size*8)/2)
	end
end

local function blink(a,spd)
	if math.floor(Game.timer/spd)%2==0 then
		if a.spr then
			a.spr=nil
		end
	else
		a.spr=a.sprinit
	end
end

return
{
	load = load,
	draw = draw,
	blink = blink,
}