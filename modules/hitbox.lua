local function make(a,m,x,y,w,h)
	m.x=x
	m.y=y
	m.w=w
	m.h=h
end

local function collision(x,y,enemy)
	if x>enemy.x+enemy.hitbox.x then
		if x<enemy.x+enemy.hitbox.x+enemy.hitbox.w then
			if y>enemy.y+enemy.hitbox.y then
				if y<enemy.y+enemy.hitbox.y+enemy.hitbox.h then
					return true
				end
			end
		end
	end
	return false
end

local function draw(a)
	LG.rectangle("line",a.x+a.hitbox.x,a.y+a.hitbox.y,a.hitbox.w,a.hitbox.h)
end

return
{
	make = make,
	collision = collision,
	draw = draw,
}