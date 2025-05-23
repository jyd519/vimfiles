local keymap = vim.keymap
local vscode = require("vscode")

vim.notify = vscode.notify

vim.g.clipboard = vim.g.vscode_clipboard
vim.opt.clipboard:append "unnamedplus"

-- keymap.set({"n", "x"}, "<C-h>", "<Cmd>lua require('vscode').action('workbench.action.navigateLeft')<CR>")
-- keymap.set({"n", "x"}, "<C-l>", "<Cmd>lua require('vscode').action('workbench.action.navigateRight')<CR>")
-- keymap.set({"n", "x"}, "<C-j>", "<Cmd>lua require('vscode').action('workbench.action.navigateDown')<CR>")
-- keymap.set({"n", "x"}, "<C-k>", "<Cmd>lua require('vscode').action('workbench.action.navigateUp')<CR>")

keymap.set({"n"}, "gx", "<Cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
keymap.set({"n"}, "<leader>ff", "<Cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")

keymap.set({"n"}, "<leader>nf", "<Cmd>lua require('vscode').action('workbench.files.action.showActiveFileInExplorer')<CR>")
keymap.set({"n"}, "gs", "<Cmd>lua require('vscode').action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })<CR>")
keymap.set({"n", "v"}, "<leader>F", "<Cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
keymap.set({"n"}, "<leader>B", "<Cmd>lua require('vscode').action('workbench.action.tasks.build')<CR>")

keymap.set({"n", "v"}, "<leader>t", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>")

keymap.set("n", "<leader>o", "<Cmd>silent !start chrome.exe file://%:p<CR>")

keymap.set("n", "<leader>ef", function ()
  local current_file = vscode.eval("return vscode.window.activeTextEditor.document.fileName")
  vim.fn.jobstart("n.bat " .. current_file)
  -- slow
  -- require('vscode').action("workbench.action.tasks.runTask", {args = {task = "Open in Vim"}})
end)

keymap.set("n", "<leader>ev", function ()
  vim.fn.jobstart("n.bat " .. vim.fn.expand("$VIMFILES/lua/myrc/vscode/setting.lua"))
end)

-- keymap.set({"n", "v", "x"}, "<leader>k", "<Cmd>lua require('vscode').action('aipopup.action.modal.generate')<CR>")
-- keymap.set({"n"}, "<leader>aa", "<Cmd>lua require('vscode').action('aichat.newchataction')<CR>")

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
