vim.fn.jobstart({'uname'}, {
    on_stdout = function(chan_id, data, name)
        print(data[1])
    end,
})

local function print_stdout(chan_id, data, name)
    print(data[1])
end

vim.fn.jobstart('ls', { on_stdout = print_stdout })


vim.fn.jobstart({'ls'}, {
    on_stdout = function(chan_id, data, name)
        print(vim.inspect(data)) -- ?? ""
    end
})

-- BAD: Neovim will be paused while the external process completes execution.
local result = vim.fn.system("fd")
if vim.api.nvim_get_vvar("shell_error") ~= 0 then
    -- Error handling.
    print("failed")
else
    -- Success handling.
    print(result)
end
