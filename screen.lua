local function update(g)
	local s={}
	local gw,gh=g.width,g.height
	s.width,s.height=LG.getDimensions()
	s.scale=math.floor(s.height/gh)
	s.xoff=(s.width-gw*s.scale)/2
	s.yoff=s.height%gh/2
--[[
	if s.width>=s.height then
		s.scale=math.floor(s.height/gh)
		s.xoff=(s.width-gw*s.scale)/2
		s.yoff=s.height%gh/2
	else
		s.scale=math.floor(s.width/gw)
		s.xoff=(s.height-gh*s.scale)/2
		s.yoff=s.width%gw/2
	end
--]]
	s.pixelscale=1
	s.shake=0

	s.font=LG.newFont("fonts/Kongtext Regular.ttf",8)
	--LG.setFont(s.font)


	s.canvas=LG.newCanvas(gw,gh)
	s.clear=true
	g.screen=s
end

local function control(g,s,gs)
	if s.shake>0 then
		s.shake=s.shake-gs
	end
	local shake=love.math.random(-s.shake/4,s.shake/4)*s.scale

	local x=(g.width*s.scale/2)+s.xoff+shake
	local y=(g.height*s.scale/2)+s.yoff
	local scale=(s.scale/s.pixelscale)*g.camera.zoom

	if s.transition then
		
		local tempcanvas=LG.newCanvas(g.width*s.pixelscale,g.height*s.pixelscale)
		LG.setCanvas(tempcanvas)
			local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
			LG.draw(g.canvas.background,0,0,0,s.pixelscale,s.pixelscale,xcamoff,ycamoff)
			if g.level then
				if g.level.canvas then
					LG.draw(g.level.canvas.background,0,0,0,s.pixelscale,s.pixelscale,xcamoff,ycamoff)
				end
			end
			LG.draw(g.canvas.main,      0,0,0,s.pixelscale,s.pixelscale)
		LG.setCanvas()
		LG.draw(tempcanvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale) --just like draws everything to the screen or whatever

		transition.control(s,s.transition)
		s.pixelscale=math.clamp(s.pixelscale,0.1,1)
	else
		LG.setCanvas(s.canvas)
			--local t=math.floor(g.timer/gs)%2 --this makes the game draw half as often, making it fake 30fps
			--if t==0 then
				if s.clear==true then
					LG.clear()
				end
				xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
				LG.draw(g.canvas.background,0,0,0,s.pixelscale,s.pixelscale,xcamoff,ycamoff)
				if g.level then
					if g.level.canvas then
						LG.draw(g.level.canvas.background,0,0,0,s.pixelscale,s.pixelscale,xcamoff,ycamoff)
					end
				end
				LG.draw(g.canvas.main,0,0,0,s.pixelscale,s.pixelscale)
			--end
		LG.setCanvas()
		LG.draw(s.canvas,x,y,0,scale,scale,g.width/2*s.pixelscale,g.height/2*s.pixelscale)
--[[
		LG.draw(g.canvas.background,x,y,0,scale,scale,g.camera.x,g.camera.y)
		if g.level then
			if g.level.canvas then
				LG.draw(g.level.canvas.background,x,y,0,scale,scale,g.camera.x,g.camera.y)
			end
		end
		LG.draw(g.canvas.main,      x,y,0,scale,scale,g.width/2,g.height/2) --just like draws everything to the screen or whatever
--]]
	end
	LG.draw(g.canvas.hud,(g.width*s.scale/2)+s.xoff,(g.height*s.scale/2)+s.yoff,0,s.scale,s.scale,g.width/2,g.height/2) --just like draws everything to the hud or whatever
	--LG.draw(g.canvas.hud,g.camera.x,g.camera.y,0,1,1,0,0) --just like draws everything to the hud or whatever
end

return
{
	update = update,
	control = control,
}