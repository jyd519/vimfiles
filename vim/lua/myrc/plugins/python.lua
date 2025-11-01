return {
  { "stevanmilic/nvim-lspimport",
  ft = { "python" },
  enabled = vim.g.enabled_plugins.python== 1,
  config = function()
    vim.keymap.set("n", "<leader>xf", require("lspimport").import, { noremap = true , desc="lsp import"})
  end,
}
}
