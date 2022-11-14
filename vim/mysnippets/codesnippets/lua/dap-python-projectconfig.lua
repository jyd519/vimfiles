vim.api.nvim_create_augroup('textedit', {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufNew"}, {
  group = "textedit",
  pattern = {"*.py"},
  callback = function()
      vim.diagnostic.disable(0)
      vim.cmd('ALEDisableBuffer')
  end,
})

for i=1,#dap.configurations.python do
  if dap.configurations.python[i].request == "attach" then
    table.remove(dap.configurations.python, i)
    i = i - 1;
  end
end

dap.adapters.pythonServer = {
    type = "server",
    host = "127.0.0.1",
    port = "5678",
    options = {
      source_filetype = 'python',
    }
}

table.insert(
    require("dap").configurations.python,
    {
        -- The first three options are required by nvim-dap
        type = "pythonServer", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "attach",
        name = "Attach Running Process",
        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
        connect = {
            host = "127.0.0.1",
            port = 5678,
        },
        pathMappings = {
          {
            localRoot= "${workspaceFolder}",
            remoteRoot= "/home/joycloud/joycloud"
          }
        },
        justMyCode = false,
    }
)