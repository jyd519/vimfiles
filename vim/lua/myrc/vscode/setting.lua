local keymap = vim.keymap
local vscode = require("vscode")

vim.notify = vscode.notify

vim.g.clipboard = vim.g.vscode_clipboard
vim.opt.clipboard:append "unnamedplus"

keymap.set({"n", "x"}, "<C-h>", "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
keymap.set({"n", "x"}, "<C-l>", "<Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")
keymap.set({"n", "x"}, "<C-j>", "<Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>")
keymap.set({"n", "x"}, "<C-k>", "<Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>")

keymap.set({"n"}, "gx", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
keymap.set({"n"}, "<leader>ff", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")

keymap.set({"n"}, "gs", "<Cmd>lua require('vscode').action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })<CR>")
keymap.set({"n"}, "<leader>F", "<Cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
keymap.set({"n"}, "<leader>B", "<Cmd>lua require('vscode').action('workbench.action.tasks.build')<CR>")

keymap.set("n", "<leader>o", "<Cmd>silent !start chrome.exe file://%:p<CR>")
keymap.set("n", "<leader>e", function ()
  vim.fn.jobstart("n.bat " .. vim.fn.expand("%:p"))
end)

keymap.set({ "n", "x" }, "<leader>r", function()
  vscode.with_insert(function()
    vscode.action("editor.action.refactor")
  end)
end)


vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
