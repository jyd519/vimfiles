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