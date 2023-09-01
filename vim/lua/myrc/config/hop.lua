-- you can configure Hop the way you like here; see :h hop-config
local hop = require("hop")

hop.setup({ keys = "etovxqpdygfblzhckisuran" })

local directions = require("hop.hint").HintDirection
vim.keymap.set(
  "",
  "f",
  function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end,
  { remap = true }
)
vim.keymap.set(
  "",
  "F",
  function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end,
  { remap = true }
)
vim.keymap.set(
  "",
  "t",
  function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end,
  { remap = true }
)
vim.keymap.set(
  "",
  "T",
  function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end,
  { remap = true }
)

vim.keymap.set({ "n", "v" }, "s", "<cmd>HopChar2AC<CR>", { noremap = false })

vim.keymap.set(
  { "n", "v" },
  "<leader>ll",
  function() return hop.hint_lines({}) end,
  { silent = true, noremap = true, desc = "Hop to down line" }
)
vim.keymap.set(
  { "n", "v" },
  "<leader>ww",
  function() return hop.hint_words({}) end,
  { silent = true, noremap = true, desc = "Hop to up line" }
)

vim.keymap.set("n", "<leader>hw", "<cmd>HopWord<cr>", { desc = "Hop to word" })
vim.keymap.set("n", "<leader>hl", "<cmd>HopLine<cr>", { desc = "Hop to line" })
