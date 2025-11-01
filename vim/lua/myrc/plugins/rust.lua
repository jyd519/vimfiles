return {
  {
    "rust-lang/rust.vim",
    ft = { "rust", "rs" },
    enabled = vim.g.enabled_plugins.rust == 1,
    init = function() vim.g.rustfmt_autosave = 1 end,
    config = function()
      local api = vim.api
      require("rust-tools").setup({
        server = {
          on_attach = function(client, bufnr)
            local set_option = api.nvim_set_option_value
            set_option("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
            set_option("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
            set_option("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
          end,
          dap = {
            adapter = require("dap").adapters.codelldb,
          },
        },
      })
    end,
  },
  { "simrat39/rust-tools.nvim", ft = { "rust" } },
  { "saecki/crates.nvim", config = true, ft = { "toml" } },
}
