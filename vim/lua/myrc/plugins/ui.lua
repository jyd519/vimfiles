return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    enabled = false,
    config = function()
      vim.notify = require("notify")
      require("notify").setup({
        timeout = 1000,
        background_colour = "#000000",
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {
    },
  },
}
