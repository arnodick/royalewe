local function make(a,m)
	local g=Game
	local gw=640
	local gh=640

	local cw=gw/g.tile.width
	local ch=gh/g.tile.height
	m.letters={}
	for y=1,ch do
		for x=1,cw do
			table.insert(m.letters,{char=g.chars[love.math.random(#g.chars)],x=x,y=y})
		end
	end
	m.letters.maxsize=#m.letters
end

local function control(a,m)
	--print(a.transition_timer)
end

local function draw(g,l,m)
	LG.setCanvas(g.canvas.main) --sets drawing to the primary canvas but does NOT refresh every frame
---[[
		if #m.letters>0 then
			for i=1,150 do
				if #m.letters>0 then
					local randindex=love.math.random(#m.letters)
					local letter=m.letters[randindex]
					LG.setColor(g.palette[EC.black])
					LG.rectangle("fill",letter.x*g.tile.width,letter.y*g.tile.height,g.tile.width,g.tile.height)
					LG.setColor(g.palette[EC.white])
					LG.print(letter.char,letter.x*g.tile.width,letter.y*g.tile.height)
					table.remove(m.letters,randindex)
				end
			end
		else
			for i=1,150 do
				local x,y=love.math.random(80),love.math.random(80)
				LG.setColor(g.palette[EC.black])
				LG.rectangle("fill",x*g.tile.width,y*g.tile.height,g.tile.width,g.tile.height)
				LG.setColor(g.palette[EC.white])
				LG.print(g.chars[love.math.random(#g.chars)],x*g.tile.width,y*g.tile.height)
			end
		end

		LG.setColor(g.palette[EC.pure_white])
--]]
	LG.setCanvas() --sets drawing back to screen
end

return
{
	make = make,
	control = control,
	draw = draw,
}