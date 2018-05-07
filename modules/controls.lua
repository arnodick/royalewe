local controls={}

controls.run = function(g,a,gs)
	for i,v in ipairs(a.controls) do
		controls[v](g,a,gs)
	end
end

controls.bullet = function(g,a)
	local dam=1
	for i,enemy in ipairs(g.actors) do
		if flags.get(enemy.flags,EF.shootable) then
			if not enemy.delete then
				if actor.collision(a.x,a.y,enemy) then
					a.delete=true
					actor.damage(enemy,dam)
				end
			end
		end
	end
end

return controls