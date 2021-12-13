--https://jacobsimpson.github.io/nvim-lua-manual/docs/apis/
---@diagnostic disable: undefined-field
--
-- string
print(vim.trim("  abc ") == "abc") -- true
-- 拆分字符串，分隔符前后的空格会被保留
for v in vim.gsplit("a , b,c,d", ",", true) do
  print("|" .. v .. "|")
end

print(string.find("abc.ext", ".", 1, true) == 4) -- true 
print(not string.find("abc", ".", 1, true)) -- false

print(vim.inspect(vim.tbl_keys(package.loaded)))

-- vim.loop: libuv library functions
dump(vim.loop.os_homedir())
assert(vim.loop.os_homedir() == os.getenv("HOME"))
dump(vim.loop.version_string())
dump(vim.loop.exepath())
dump(vim.loop.os_uname())
-- {
--   machine = "x86_64",
--   release = "20.6.0",
--   sysname = "Darwin",
--   version = "Darwin Kernel Version 20.6.0: Mon Aug 30 06:12:21 PDT 2021; root:xnu-7195.141.6~3/RELEASE_X86_64"
-- }
--

if _G.jit then
  print(_G.jit.os) -- OSX
end


-- 全局变量
print(vim.api.nvim_eval("g:mysnippets_dir"))
print(vim.g.mysnippets_dir)

-- 环境变量
print(os.getenv("VIMFILES"))
print(vim.env.VIMFILES)
print(vim.api.nvim_eval("$VIMFILES"))
print(vim.api.nvim_eval("expand('$VIMFILES')"))

