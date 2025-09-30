return {
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "sass", "scss", "vue", "html", "javascript", "typescript" },
    config = function()
      require("colorizer").setup({
        "css",
        "sass",
        "scss",
        "vue",
        "html",
        javascript = { mode = "foreground" },
        typescript = { mode = "foreground" },
      }, { mode = "background" })
    end,
  },

  { "mattn/emmet-vim", ft = { "html", "jsx", "vue", "javascriptreact", "javascript", "css", "scss" } },

  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = true, -- run require("template-string").setup()
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    config = true
  },

  -- {
  --   "razak17/tailwind-fold.nvim",
  --   opts = {
  --     min_chars = 50,
  --   },
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  -- },
  --
  -- {
  --   "MaximilianLloyd/tw-values.nvim",
  --   keys = {
  --     { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
  --   },
  --   opts = {
  --     border = EcoVim.ui.float.border or "rounded", -- Valid window border style,
  --     show_unknown_classes = true                   -- Shows the unknown classes popup
  --   }
  -- },
  --
  -- {
  --   "laytan/tailwind-sorter.nvim",
  --   cmd = {
  --     "TailwindSort",
  --     "TailwindSortOnSaveToggle"
  --   },
  --   keys = {
  --     { "<Leader>cS", "<CMD>TailwindSortOnSaveToggle<CR>", desc = "toggle Tailwind CSS classes sort on save" },
  --
  --   },
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
  --   build = "cd formatter && npm i && npm run build",
  --   config = true,
  -- },
}
