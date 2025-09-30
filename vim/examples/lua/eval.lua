-- call functions defined in vimscript
print(vim.fn.has('nvim')) -- 1

PATH_SEPARATOR = package.config:sub(1,1)
IS_WINDOWS = PATH_SEPARATOR == '\\'
IS_POSIX = PATH_SEPARATOR == '/'
print(PATH_SEPARATOR, IS_WINDOWS, IS_POSIX)

dump(vim.split(package.path, ';'))

local tbl = {1, 2, 3}
local newtbl = vim.fn.map(tbl, function(_, v) return v * 2 end)
print(vim.inspect(tbl)) -- { 1, 2, 3 }
print(vim.inspect(newtbl)) -- { 2, 4, 6 }

--
-- 执行vimscript表达式
-- Data types are converted correctly
print(vim.api.nvim_eval('1 + 1')) -- 2
print(vim.inspect(vim.api.nvim_eval('[1, 2, 3]'))) -- { 1, 2, 3 }
print(vim.inspect(vim.api.nvim_eval('{"foo": "bar", "baz": "qux"}'))) -- { baz = "qux", foo = "bar" }
print(vim.api.nvim_eval('v:true')) -- true
print(vim.api.nvim_eval('v:null')) -- nil

-- 执行vimscript代码
local result = vim.api.nvim_exec([[
let s:mytext = 'hello world'

function! s:MyFunction(text)
    echo a:text
endfunction

call s:MyFunction(s:mytext)
]], true)

print(result) -- 'hello world'

-- 等价于  vim.api.nvim_exec('buffers', false)
vim.cmd('buffers')
vim.cmd([[
let g:multiline_list = [
            \ 1,
            \ 2,
            \ 3,
            \ ]

echo g:multiline_list
]])

-- 执行vim 命令
vim.api.nvim_command('set number!')

print(vim.o.smarttab)
print(vim.bo.shiftwidth)

put(vim.g.fzf_action)
put(vim.api.nvim_get_var("fzf_action"))


