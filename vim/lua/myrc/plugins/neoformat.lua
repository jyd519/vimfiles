return {
  {
    "jyd519/neoformat",
    lazy = true,
    cmd = { "Neoformat" },
    init = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_basic_format_align = 1
      vim.g.neoformat_basic_format_retab = 1
      vim.g.neoformat_basic_format_trim = 1
      vim.g.neoformat_enabled_javascript = { "prettierd", "prettier", "jsbeautify" }
      vim.g.neoformat_enabled_typescript = { "prettierd", "prettier", "tsfmt" }
      vim.g.neoformat_enabled_css = { "prettierd", "prettier", "tsfmt" }
      vim.g.neoformat_enabled_html = { "prettierd", "prettier", "htmlbeautify" }
      vim.g.neoformat_enabled_python = { "ruff", "black", "isort" }
      vim.g.neoformat_c_clangformat = {
        exe = "clang-format",
        args = { "-assume-filename=", '"%:p"' },
        stdin = 1,
      }
      vim.g.neoformat_cpp_clangformat = vim.g.neoformat_c_clangformat

      vim.keymap.set("n", "<leader>F", ":Neoformat<CR>")
    end,
  },
}
