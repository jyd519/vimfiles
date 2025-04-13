return {
  { "Mofiqul/vscode.nvim", lazy = true },
  { "NLKNguyen/papercolor-theme", lazy = true },
  { "rakr/vim-one", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "latte", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
      })
    end,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = true,
    config = function() vim.g.material_style = "lighter" end,
  },
}
