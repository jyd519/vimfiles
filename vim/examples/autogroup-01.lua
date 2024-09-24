-- Creating an autocommand in 0.7
--
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


vim.api.nvim_create_autocmd("BufEnter", {
    group = au_id,
    pattern = "*",
    callback = function(args)
        print("Entered buffer " .. args.buf .. "!")
    end,
    desc = "Tell me when I enter a buffer",
})

-- nvim_del_augroup_by_id()
