local menu={}

menu.make = function(a,m,t,x,y,w,h,text,c1,c2,align,...)
	--TODO put if type(t)=="number" then m.t=t else m.t=EMM[t]
	if type(t)=="number" then
		m.t=t
	else 
		m.t=EMM[t]
	end
	m.x=math.floor(x)
	m.y=math.floor(y)
	m.w=w
	m.h=h
	m.text=text--this can be a table or string
	m.c1=c1
	m.c2=c2
	m.align=align or "left"
	m.font=LG.newFont("fonts/Kongtext Regular.ttf",8)--TODO make fonts an array in game, then menu can select from them

	local menuname=EMM[m.t]
	run(menuname,"make",m,...)
end

menu.control = function(m,gs)
	run(EMM[m.t],"control",m,gs)
end

menu.keypressed = function(m,key)
	run(EMM[m.t],"keypressed",m,key)
end

menu.keyreleased = function(m,key)
	run(EMM[m.t],"keyreleased",m,key)
end

menu.gamepadpressed = function(m,button)
	run(EMM[m.t],"gamepadpressed",m,button)
end

menu.draw = function(m)
	local g=Game
	if m.border then
		border.draw(m,m.border)
	end
	LG.setFont(m.font)
	if not run(EMM[m.t],"draw",m) then
		run("text","draw",m)
	end
	LG.setFont(g.font)
---[[
	if Debugger.debugging then
		LG.setColor(Game.palette[EC.red])
		LG.points(m.x,m.y)
	end
--]]
end

return menu