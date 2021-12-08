print(vim.fn.has('nvim'))

local tbl = {1, 2, 3}
local newtbl = vim.fn.map(tbl, function(_, v) return v * 2 end)

print(vim.inspect(tbl)) -- { 1, 2, 3 }
print(vim.inspect(newtbl)) -- { 2, 4, 6 }

-- vim.fn.jobstart({'uname'}, {
--     on_stdout = function(chan_id, data, name)
--         print(vim.inspect(data), vim.inspect(name))
--     end
-- })
