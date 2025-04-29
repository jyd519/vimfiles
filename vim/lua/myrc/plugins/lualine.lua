return {
  {
    "nvim-lualine/lualine.nvim",
    -- event = "VeryLazy",
    dependencies = {
      -- The icon font for Visual Studio Code
      { "ChristianChiarulli/neovim-codicons", lazy = true },
      { "arkav/lualine-lsp-progress" },
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    config = function() require("myrc.config.lualine") end,
  },
}
