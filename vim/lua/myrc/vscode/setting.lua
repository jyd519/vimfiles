local keymap = vim.keymap
local vscode = require("vscode")

vim.notify = vscode.notify

vim.g.clipboard = vim.g.vscode_clipboard

keymap.set({"n", "x"}, "<C-h>", "<Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
keymap.set({"n", "x"}, "<C-l>", "<Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")
keymap.set({"n", "x"}, "<C-j>", "<Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>")
keymap.set({"n", "x"}, "<C-k>", "<Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>")

keymap.set({"n"}, "gx", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
keymap.set({"n"}, "<leader>ff", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>")

keymap.set("n", "<leader>o", "<Cmd>silent !start chrome.exe file://%:p<CR>")
keymap.set("n", "<leader>e", function ()
  vim.fn.jobstart("n.bat " .. vim.fn.expand("%:p"))
end)

