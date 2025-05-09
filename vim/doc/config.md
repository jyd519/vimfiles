# vim-test 插件配置选项

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
