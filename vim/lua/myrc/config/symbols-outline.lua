local outline = require("symbols-outline")
outline.setup({
  autofold_depth = 2,
  keymaps = {
    -- These keymaps can be a string or a table for multiple keys
    close = { "q" },
    goto_location = "<Cr>",
    focus_location = { "e", "o" },
    hover_symbol = "<C-space>",
    toggle_preview = "K",
    rename_symbol = "r",
    code_actions = "a",
    fold = { "c", "zc" },
    unfold = "zo",
    fold_all = { "W", "zm" },
    unfold_all = { "E", "zO" },
    fold_reset = "R",
  },
})

vim.keymap.set("n", "<leader>to", function()
  outline.toggle_outline()
end)
