local supper =
{
    _VERSION        = 'supper v1.0',
    _DESCRIPTION    = 'A dynamic function runner.',
    _LICENSE        = [[
Copyright (c) 2017 Ashley Pringle

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
}

--takes in a table t and a list of strings args
--recursively digs through the table to see if it has members tables whose keys match the string args
--if the last arg matches the key of a function in the table, run that function
--returns the results of the function that was found nested in the table, if possible
--ie: t = game (a table), args = {"level","cave","make"} will do the same as:
--game.level.cave.make(...)
supper.run = function(t,args,...)
	local r=nil
	if #args>0 then
		local f=t[args[1]]
		if f then
			table.remove(args,1)
			r=supper.run(f,args,...)
		end
	elseif type(t)=="function" then
		r=t(...)
	end
	if r then
		return r
	end
end

--puts a table called "names" in a table t
--the "names" tables is an enumerated list of all the key strings of the members of the table
--ie: t = {desert=function(...),cave=function(...),sewer=function(...)}
--then t.names[1]="desert", t.names[2]="cave", t.names[3]="sewer"
--these names can then be used to dynamically call member functions of the table t
supper.names = function(t)
	local n={}
	for k,v in pairs(t) do
		table.insert(n,k)
	end
	t.names=n
end

--gives a random entry in any integer-indexed table
supper.random = function(t)
	return t[math.random(#t)]
end

-- Supper:
-- Don't walk for your supper... RUN!

return supper