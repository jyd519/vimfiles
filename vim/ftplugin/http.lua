vim.keymap.set(
  "n",
  "]]",
  function() require("kulala").jump_next() end,
  { desc = "Jump to next request", buffer = true }
)

vim.keymap.set(
  "n",
  "[[",
  function() require("kulala").jump_prev() end,
  { desc = "Jump to previous request", buffer = true }
)
