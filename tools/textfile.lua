--TODO maybe put this in love.filesystem?

local byteamount=4--4 bytes (8 hex digits) per cell

function loadbytes(l)
	--converts a line of hex text into values and inserts them into a 1D array
	--returns the 1D array
	local ar={}
	for a=1, #l, byteamount*2 do
		table.insert( ar, tonumber(string.sub(l, a, a+byteamount*2-1),16) )
	end
	return ar
end

function load(m)
	--loads hex values from a textfile into an array row by row
	--returns a 2D array of datums
	local data={}
	for row in love.filesystem.lines(m) do
		table.insert(data,textfile.loadbytes(row))
	end
	return data
end

function save(m,n)
	--takes an array of hex data and a filename string
	--converts hex data into text and saves it in a file
	local str=""
	for y=1,#m do
		for x=1,#m[y] do
			str=str..string.format("%0"..tostring(byteamount*2).."x",m[y][x])
		end
		str=str.."\n"
	end
	love.filesystem.write(n,str)
end

return
{
	loadbytes = loadbytes,
	load = load,
	save = save,
}