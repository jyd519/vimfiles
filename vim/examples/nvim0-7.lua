-- Using a Lua function in a key mapping in 0.7
vim.api.nvim_set_keymap("n", "<leader>H", "", {
    noremap = true,
    callback = function()
        print("Hello world!")
    end,
})

-- Creating an autocommand in 0.7
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function(args)
        print("Entered buffer " .. args.buf .. "!")
    end,
    desc = "Tell me when I enter a buffer",
})

-- Creating a custom user command in 0.7
vim.api.nvim_create_user_command("SayHello", function(args)
    print("Hello " .. args.args)
    put(args)
end, {
    nargs = "*",
    desc = "Say hi to someone",
})


vim.api.nvim_buf_create_user_command(0, "SayHelloBuf", function(args)
  vim.cmd("new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man |" 
          .. "r !ansible-doc " ..  table.concat(args.artgs, " "))
end, {
    nargs = "*",
    desc = "Lookup ansible document",
})


vim.api.nvim_buf_create_user_command(0, "ADoc", function(args)
  vim.cmd("new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man |"
          .. "r !ansible-doc " ..  args.args .. "")
  vim.defer_fn(function() vim.cmd('exec "norm gg"') end, 100)
end, {
    nargs = "+",
    desc = "Lookup ansible document",
})

-- Pros of keymap.set
--   It can accept either a string or a Lua function as its 3rd argument.
--   It sets noremap by default, as this is what users want 99% of the time.
vim.keymap.set("n", "<leader>H", function() print("Hello world!") end)

-- autogroup
local au_id = vim.api.nvim_create_augroup("autest", {clear = true})
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"},{
    group = au_id, -- or "autest",
    pattern = {"*.lua"},
    callback = function ()
      vim.defer_fn(function()
        print(">>> read a lua file")
      end, 100)
    end,
})

-- print(vim.lsp.get_log_path())
