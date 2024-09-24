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

