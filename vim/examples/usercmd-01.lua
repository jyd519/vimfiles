vim.api.nvim_create_user_command('Upper', 'echo toupper(<q-args>)', { nargs = 1 })
-- :command! -nargs=1 Upper echo toupper(<q-args>)

vim.api.nvim_create_user_command(
    'Upper2',
    function(opts)
        print(string.upper(opts.args))
    end,
    { nargs = 1 }
)

vim.cmd('Upper hello world') -- prints "HELLO WORLD"
vim.cmd.Upper("sf test")

vim.cmd.Upper2("sf test")


vim.api.nvim_create_user_command('Upper',
  function(opts)
    print(string.upper(opts.fargs[1]))
  end,
  { nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos)
      -- return completion candidates as a list-like table
      return { "foo", "bar", "baz" }
    end,
})


vim.api.nvim_del_user_command('Upper')
vim.api.nvim_del_user_command('Upper2')

