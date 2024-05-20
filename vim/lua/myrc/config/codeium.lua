vim.g.codeium_no_map_tab = 1
-- vim.g.codeium_manual = true
vim.g.codeium_enabled = false

-- vim.g.codeium_filetypes = { markdown = false, json = false, jsonc = false}
--
vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, desc = "Accept Codeium" })
vim.keymap.set("n", "<C-;>", function()
  if not vim.fn["codeium#Enabled"]() then
    vim.cmd("CodeiumEnable")
    vim.defer_fn(function() vim.notify("Codeium enabled", vim.log.levels.INFO, { title = "Codeium" }) end, 100)
  else
    vim.cmd("CodeiumDisable")
    vim.defer_fn(function() vim.notify("Codeium disabled", vim.log.levels.WARN, { title = "Codeium" }) end, 100)
  end
end, { desc = "Toggle Codeium" })
vim.keymap.set(
  "i",
  "<C-;>",
  function() return vim.fn["codeium#CycleOrComplete"]() end,
  { expr = true, desc = "Trigger autocompletion" }
)
local mapkey = require("keymap-amend")
mapkey("i", "<C-j>", function(fallback)
  if vim.b._codeium_completions ~= nil then
    return vim.fn["codeium#Clear"]()
  else
    fallback()
  end
end, { silent = true, desc = "Clear Codeium Completions" })
