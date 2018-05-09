local function load()
	if not love.filesystem.exists("scores.ini") then
		local h={}
		local n={}
		for i=1,5 do
			table.insert(h,i*5)
			table.insert(n,"ASH")
		end
		local scores=
		{
			high=h,
			names=n,
			--saved=false
		}
		
		LIP.save("scores.ini",scores)
	end
	return LIP.load("scores.ini")
end

local function update()
	local scores=scores.load()
	local s={}
	for j=1,#scores.high do
		table.insert(s,{scores.names[j],scores.high[j]})
	end
	local score=Game.score
	table.insert(s,{"",score})

	local function scoresort(a,b)
		if a[2]>b[2] then
			return true
		else
			return false
		end
	end

	table.sort(s,scoresort)

	for i=#s,1,-1 do
		if i>5 then
			table.remove(s,i)
		end
	end

	scores.high={}
	scores.names={}
	for k=1,#s do
		scores.names[k]=s[k][1]
		scores.high[k]=s[k][2]
	end

	Game.scores=scores
end

local function save()
	--for i,v in ipairs(Game.scores.names) do
	for i=1,#Game.scores.names do
		if Game.scores.names[i]=="" then
			Game.scores.names[i]="X"
		end
	end
	LIP.save("scores.ini",Game.scores)
	Game.scores.saved=true
end

return
{
	load = load,
	update = update,
	save = save,
}