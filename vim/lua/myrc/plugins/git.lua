return {
  { "tpope/vim-fugitive", event = "VeryLazy" },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("myrc.config.gitsigns") end,
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require("neogit").setup({
        kind = "vsplit", -- opens neogit in a split
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        integrations = { diffview = true, telescope = true },
      })
    end,
  },
}
