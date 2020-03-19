local filename = ""
if arg[1] then
	filename = arg[1]
else
	print("Input file not provided!")
	return
end

local handle = assert(io.open(filename, "rb"), "Failed to open file.")
local inp = handle:read("*all")
local zlib = require("zlib")

local i = 1
for v in inp:gmatch("stream\n(.-)\nendstream") do
	local inflate = zlib.inflate()
	if tonumber(string.byte(v:sub(1,1))) == 0x78 then
		local file = io.open(i.."_compresed.bin", "wb")
		local inflated, eof, bytes_in, bytes_out = inflate(v)
		file:write(inflated)
		file:close()
	else
		local file = io.open(i.."_uncompresed.bin", "wb")
		file:write(v)
		file:close()
	end
	i = i + 1
end