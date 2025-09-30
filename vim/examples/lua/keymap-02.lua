-- Using a Lua function in a key mapping in 0.7
vim.api.nvim_set_keymap("n", "<leader>H", "", {
    noremap = true,
    callback = function()
        print("Hello world!")
    end,
})

-- Pros of keymap.set
--   It can accept either a string or a Lua function as its 3rd argument.
--   It sets noremap by default, as this is what users want 99% of the time.
vim.keymap.set("n", "<leader>H", function() print("Hello world!") end)

-- print(vim.lsp.get_log_path())
