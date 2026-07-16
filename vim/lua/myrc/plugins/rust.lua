return {
  {
    "rust-lang/rust.vim",
    ft = { "rust", "rs" },
    cond = vim.g.enabled_plugins.rust == 1,
    init = function() vim.g.rustfmt_autosave = 1 end,
  },
  {
    "mrcjkb/rustaceanvim",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          cmd = function()
            local mason_registry = require("mason-registry")
            if mason_registry.is_installed("rust-analyzer") then
              local ra = mason_registry.get_package("rust-analyzer")
              local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
              return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
            else
              return { "rust-analyzer" }
            end
          end,
        },
      }
    end,
    cond = vim.g.enabled_plugins.rust == 1,
    lazy = false,
  },
  { "saecki/crates.nvim", config = true, ft = { "toml" } },
}
