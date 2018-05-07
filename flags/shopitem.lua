local function control(a,target)
	if vector.distance(a.x,a.y,target.x,target.y)<30 then
		sprites.blink(a,24)
		if target.controller.action.action then
			if target.coin>=a.cost then
				a.flags=flags.switch(a.flags,EF.shopitem)
				actor.corpse(a.menu,a.menu.w+1,a.menu.h+1,true)
				actor.make(Game,EA.explosion,a.x,a.y,0,0,EC.white,40)
				a.menu=nil
				target.coin=target.coin-a.cost
			else
				sfx.play(11)
			end
		end
	else
		a.spr=a.sprinit--TOOD this is probably causing weird no sprite actors when they are put in shop
	end
end

return
{
	control = control,
}