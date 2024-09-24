s = "hello world from Lua"
for w in string.gmatch(s, "%a+") do
  print(w)
end

s = "from=world, to=Lua"
-- ( ) is a capture group
for k, v in string.gmatch(s, "(%w+)=(%w+)") do
  print(k, ">", v)
end

x = string.gsub("hello world", "(%w+)", "%1 %1")
put(x)
--> x="hello hello world world"
--
--
local t = { name = "lua", version = "5.1" }
x = string.gsub("$name%-$version.tar.gz", "%$(%w+)", t)
--> x="lua-5.1.tar.gz"
--
