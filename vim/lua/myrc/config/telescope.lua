local actions = require("telescope.actions")
local nvim_set_keymap = vim.api.nvim_set_keymap

require('telescope').setup{
  mappings = {
    i = {
      ["<esc>"] = actions.close
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      sort_mru = true,
    }
  },
}

nvim_set_keymap('n', '<leader>da', ':lua require"telescope.builtin".diagnostics{}<CR>', { noremap = true, silent = true, desc = "Show LSP diagnostics" })
nvim_set_keymap('n', '<leader>dd', ':lua require"telescope.builtin".diagnostics{bufnr=0}<CR>', { noremap = true, silent = true })
nvim_set_keymap('n', '<leader>qf', ':lua require"telescope.builtin".quickfix{bufnr=0}<CR>', { noremap = true, silent = true })


vim.keymap.set("n" , "<leader>fo", ":Telescope oldfiles<CR>", {desc = "Find in oldfiles"})

vim.keymap.set("n" , "<leader>fg", function()
  local opts = {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end, {desc = "Find in git files"})

vim.keymap.set("n" , "<leader>b", function()
  require"telescope.builtin".buffers{}
end, { desc = "List buffers" })


vim.cmd([[
com! Maps :Telescope keymaps
]])
