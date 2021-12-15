-- this will not resolve to the realpath
local function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)"):sub(1, -2)
end