local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
  sync_root_with_cwd = true,
  git = {
    enable = false
  },
  on_attach = my_on_attach,
  -- respect_buf_cwd = true,
  -- update_focused_file = {
  --   enable = true,
  --   update_root = true
  -- },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<cr>", { desc = "Find File in NvimTree" })
vim.keymap.set("n", "<leader>nF", ":NvimTreeFindFile!<cr>", { desc = "Find File in NvimTree" })
