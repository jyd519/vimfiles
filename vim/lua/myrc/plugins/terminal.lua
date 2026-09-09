return {
-- ToggleTerm {{{1
  {
    "akinsho/toggleterm.nvim",
    branch = "main",
    event = "VeryLazy",
    config = function()
      local is_window = vim.fn.has("win32") == 1
      require("toggleterm").setup({
        shell = is_window and "pwsh.exe" or vim.o.shell,
        direction  = "float",
        start_in_insert = true,
        persist_mode  = false,
        highlights = { },
        size = function (term)
          if term.direction == "horizontal" then
            return math.floor(vim.o.lines * 0.3)
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
          end
        end,
        float_opts = {
          border = 'single',
          width = math.ceil(0.9 * vim.o.columns),
          title_pos  = 'center',
        },
      })
    end,
  },
-- }}}
}
-- vim: set fdm=marker fdl=1:
