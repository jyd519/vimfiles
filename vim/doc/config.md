# config

## 初始化顺序

`init > exrc > plugins`

> https://neovim.io/doc/user/starting.html#_initialization

## vim-test 插件配置选项

```vim
" 禁止cache
let g:test#go#gotest#options = '-v --count=1'


```

```lua
-- INFO: read filenames on lsp/ directory and enable those
local lsp_files = {}
local lsp_dir = vim.fn.stdpath("config") .. "/lsp/"

for _, file in ipairs(vim.fn.globpath(lsp_dir, "*.lua", false, true)) do
    -- Read the first line of the file
    local f = io.open(file, "r")
    local first_line = f and f:read("*l") or ""
    if f then
        f:close()
    end
    -- Only include the file if it doesn't start with "-- disable"
    if not first_line:match("^%-%- disable") then
        local name = vim.fn.fnamemodify(file, ":t:r") -- `:t` gets filename, `:r` removes extension
        table.insert(lsp_files, name)
    end
end
```
## powershell

```lua
--- Use PowerShell as default Shell on Windows
if vim.fn.has "win32" == 1 then
  opt.shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell"
  opt.shellcmdflag =
    "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
  opt.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
  opt.shellpipe = '2>&1 | %{ "$_" } | tee %s; exit $LastExitCode'
  opt.shellquote = ""
  opt.shellxquote = ""
end
```

## exrc
项目本地配置文件

```
set exrc

Nvim will execute any .nvim.lua, .nvimrc, or .exrc file found in the current-directory and all parent directories
(ordered upwards), if the files are in the trust list.


```

**To achieve project-local LSP configuration:**

1. Enable 'exrc'.
2. Place LSP configs at ".nvim/lsp/*.lua" in your project root.
3. Create ".nvim.lua" in your project root directory with this line:

`vim.cmd[[set runtimepath+=.nvim]]`

> https://neovim.io/doc/user/options.html#'exrc'
