return {
  { "stevanmilic/nvim-lspimport",
  ft = { "python" },
  config = function()
    vim.keymap.set("n", "<leader>xf", require("lspimport").import, { noremap = true , desc="lsp import"})
  end,
}
}
