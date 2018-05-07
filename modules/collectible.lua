local function control(a,gs)
	if not flags.get(a.flags,EF.shopitem) then
		local g=Game
		if g.player or g.players[1] then
			local p=g.player or g.players[1]
			if p.t~=EA.ghost then
				if actor.collision(a.x,a.y,p) then
					if p[EA[a.t]] then
						p[EA[a.t]] = p[EA[a.t]] + a.value
					end
		--[[
					for i,v in pairs(Game.actors) do
						if v.t==EA.coin then
							v.scalex=4
							v.scaley=4
							v.deltimer=0
							v.delta=Game.timer
						end
					end
		--]]

					if a.sound then
						if a.sound.get then
							sfx.play(a.sound.get,a.x,a.y)
						end
					end
					actor.make(Game,EA.collectibleget,a.x,a.y,math.pi/2,1,EC.pure_white,1,a.sprinit)
					run(EA[a.t],"get",a,gs)
					a.delete=true
				end
			end
		end
	end
end

return
{
	control = control,
}