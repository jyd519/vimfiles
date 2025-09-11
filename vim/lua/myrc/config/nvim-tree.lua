local function nvim_tree_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent,        opts("Up"))
  vim.keymap.set("n", "?",     api.tree.toggle_help,                  opts("Help"))
end

require("nvim-tree").setup({
  on_attach = nvim_tree_on_attach,
  view = {
    width = 40,
  },
  renderer = {
    root_folder_label = function (path)
      path = path:gsub(vim.loop.os_homedir(), "~", 1)
      return path:gsub("([a-zA-Z])[a-z]+", "%1") .. path:gsub(".*[^a-zA-Z].?", "")
    end
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<cr>", { desc = "Find File in NvimTree" })
vim.keymap.set("n", "<leader>nF", ":NvimTreeFindFile!<cr>", { desc = "Find File in NvimTree" })
