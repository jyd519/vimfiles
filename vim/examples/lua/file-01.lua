io.output(io.open("file.txt", "w"))
io.write("test")
io.close()

for line in io.lines("file-01.lua") do
  put(line)
  break
end

file = assert(io.open("color.lua", "r"))
put(file:read())
-- put(file:lines())
file:close()
