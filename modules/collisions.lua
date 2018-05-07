local collisions={}

collisions.run = function(g,a)
	for i,v in ipairs(a.collisions) do
		collisions[v](g,a)
	end
end

collisions.destroy = function(g,a)
	a.delete=true
end

return collisions