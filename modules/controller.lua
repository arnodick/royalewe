local function make(a,cont,t,input,ai1,ai2)
	local controllertypename=EMC[t]
	cont[controllertypename]={}--this gives the controller a table named after the controller's type (ie controller.move)
	local c=cont[controllertypename]--c is the controller's type sub-table (ie move)
	c.t=t
	c.input=input

	if input==EMCI.gamepad then
		c.id=ai1 or 1
	end

	if t==EMC["action"] then
		module.make(c,EM.chance,ai1,ai2)
	else
		module.make(c,EM.target,ai1,ai2)
	end

	run(EMC[t],"make",a,c)
end

local function update(a,gs)
	local c=a.controller

	if c then
		for k,v in pairs(c) do
			local controllername=EMC[v.t]

			if _G[controllername]["control"] then
				local inputname=EMCI[v.input]
				
				local command1,command2=_G[inputname][controllername](a,v)
				_G[controllername]["control"](a,v,gs,command1,command2)
			end
		end
	end
end

local function gamepadpressed(a,button)
	local c=a.controller
	if c then
		for k,v in pairs(c) do
			if _G[EMC[v.t]]["gamepadpressed"] then
				_G[EMC[v.t]]["gamepadpressed"](a,v,button)
			end
		end
	end
end

local function deadzone(c,dz)
	local l=vector.length(c.horizontal,c.vertical)
	if l<dz then
		c.horizontal=0
		c.vertical=0
	end
--[[
	local axes={"horizontal","vertical"}
	for i=1,#axes do
		if c[axes[i] ]>0 and c[axes[i] ]<dz then
			c[axes[i] ]=0
		end

		if c[axes[i] ]<0 and c[axes[i] ]>-dz then
			c[axes[i] ]=0
		end
	end
--]]
end

return
{
	make = make,
	update = update,
	gamepadpressed = gamepadpressed,
	deadzone = deadzone
}