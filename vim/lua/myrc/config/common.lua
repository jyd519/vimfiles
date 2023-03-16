-- globals {{{1
local vim, g = vim, vim.g
local keymap = vim.keymap
keymap.amend = require('keymap-amend')

-- indent_blankline -- {{{1
--
local treesitter_enabled = g.enabled_plugins["nvim-treesitter"] == 1
if treesitter_enabled then
  g.indent_blankline_filetype_exclude = { "markdown" }
  require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = treesitter_enabled,
    show_current_context_start = treesitter_enabled,
  }
end

if treesitter_enabled then
  -- refactoring -- {{{1
  -- load refactoring Telescope extension
  -- https://github.com/ThePrimeagen/refactoring.nvim#installation
  require('refactoring').setup({
    printf_statements = {},
    print_var_statements = {},
  })
  -- vim.api.nvim_set_keymap(
  --   "v",
  --   "<leader>rf",
  --   ":lua require('refactoring').select_refactor()<CR>",
  --   { noremap = true, silent = true, expr = false }
  -- )
  -- remap to open the Telescope refactoring menu in visual mode
  require("telescope").load_extension("refactoring")
  vim.api.nvim_set_keymap(
    "v",
    "<leader>rf",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true}
  )
end

-- custom mappings  {{{1
keymap.amend('n', '<Esc>', function(original)
  if vim.v.hlsearch and vim.v.hlsearch == 1 then
    vim.cmd('nohlsearch')
  end
  original()
end, { desc = 'disable search highlight' })

vim.api.nvim_set_keymap(
  "n",
  "<leader>sl",
  "<cmd>lua require('myrc.split').splitJsString()<CR>",
  { noremap = true }
)

-- Toogle diagnostics
local diagnostics_active = true
local toggle_diagnostics = function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.api.nvim_echo({ { "Show diagnostics" } }, false, {})
    vim.diagnostic.enable(0)
  else
    vim.api.nvim_echo({ { "Disable diagnostics" } }, false, {})
    vim.diagnostic.disable(0)
  end
end

keymap.set(
  "n",
  "<leader>dt",
  function()
    toggle_diagnostics()
  end
)

keymap.set(
  "n",
  "<leader>dk",
  function()
    vim.diagnostic.open_float()
  end
)

keymap.set(
  "n",
  "<leader>cn",
  function()
    vim.cmd("NextCS")
  end
)
keymap.set(
  "n",
  "<leader>cp",
  function()
    vim.cmd("PreviousCS")
  end
)

-- lookup ansible-doc
vim.api.nvim_create_user_command("Adoc", function(args)
  vim.cmd("new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |"
    .. "r !ansible-doc " .. args.args .. "")
  vim.defer_fn(function() vim.cmd('exec "norm ggM"') end, 100)
end, {
  nargs = "+",
  desc = "Lookup ansible document",
})

-- Handling large file
-- https://www.reddit.com/r/neovim/comments/z85s1l/disable_lsp_for_very_large_files/
local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    if ok and stats and (stats.size > 1000000) then
      vim.b.large_buf = true
      vim.cmd("syntax off")
      vim.cmd("IndentBlanklineDisable") -- disable indent-blankline.nvim
      vim.opt.foldmethod = "manual"
      vim.opt.spell = false
    else
      vim.b.large_buf = false
    end
  end,
  group = aug,
  pattern = "*",
})

-- vim: set fdm=marker fdl=0: }}}
