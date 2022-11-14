vim.api.nvim_create_augroup('textedit', {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufNew"}, {
  group = "textedit",
  pattern = {"*.py"},
  callback = function()
      -- vim.diagnostic.disable(0)
      -- vim.cmd('ALEDisableBuffer')
  end,
})

for i=#dap.configurations.python,1,-1 do
  if dap.configurations.python[i].request == "attach" then
    table.remove(dap.configurations.python, i)
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

-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
require("lspconfig").pyright.setup{
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = function()
      return "/Volumes/dev/work/joytest/joycloud"
    end,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          verboseOutput = true,
          extraPaths = {"./env/lib/python3.9/site-packages"}
        },
      },
    },
    single_file_support = true
}