local api = vim.api

local filetype_exclude = {
  "lspinfo",
  "checkhealth",
  "help",
  "man",
  "mason",
  "qf",
  "startify",
  "markdown",
  "alpha",
  "dashboard",
  "neo-tree",
  "lazy",
}

require("ibl").setup({
  indent = {
    char = "│",
  },
  -- filetype = { "python", "cpp", "c", "lua" },
  exclude = {
    filetypes = filetype_exclude,
    buftypes = { "terminal", "nofile" },
  },
  scope = { enabled = false },
})

local hooks = require("ibl.hooks")
hooks.register(
  hooks.type.ACTIVE,
  function(bufnr) return vim.b.large_buf == nil and vim.api.nvim_buf_line_count(bufnr) < 5000 end
)
