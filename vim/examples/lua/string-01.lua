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
local str1 = "NeoVim"
local str2 = "neovim"

-- 如果返回 0，说明忽略大小写后两者相等
if vim.stricmp(str1, str2) == 0 then
    print("字符串相等")
end
