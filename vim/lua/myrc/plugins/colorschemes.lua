return {
  { "Mofiqul/vscode.nvim" },
  { "NLKNguyen/papercolor-theme" },
  { "rakr/vim-one" },
  { "ellisonleao/gruvbox.nvim", opts = { transparent_mode = true } },
  { "navarasu/onedark.nvim" },
  { "marko-cerovac/material.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
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
}
