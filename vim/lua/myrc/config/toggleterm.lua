local is_window = vim.fn.has("win32") == 1
require("toggleterm").setup({
  shell = is_window and "pwsh.exe" or vim.o.shell,
  direction  = "float",
  float_opts = {
    border = 'single',
    -- like `size`, width and height can be a number or function which is passed the current terminal
    width = math.ceil(0.8 * vim.o.columns),
    -- height = <value>,
  },
})
