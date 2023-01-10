-- globals {{{1
local vim, g = vim, vim.g
local keymap = vim.keymap
keymap.amend = require('keymap-amend')

-- indent_blankline -- {{{1
local treesitter_enabled = g.enabled_plugins["nvim-treesitter"] == 1
if g.enabled_plugins["indent_blankline"] == 1 then
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
  require('refactoring').setup({})
  require("telescope").load_extension("refactoring")

  -- remap to open the Telescope refactoring menu in visual mode
  vim.api.nvim_set_keymap(
    "v",
    "<leader>rr",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true }
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
    vim.cmd("call NextCS()")
  end
)
keymap.set(
	"n",
	"<leader>cp",
  function()
    vim.cmd("call PreviousCS()")
  end
)

-- lookup ansible-doc
vim.api.nvim_create_user_command("Adoc", function(args)
  vim.cmd("new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |"
          .. "r !ansible-doc " ..  args.args .. "")
  vim.defer_fn(function() vim.cmd('exec "norm ggM"') end, 100)
end, {
    nargs = "+",
    desc = "Lookup ansible document",
})

-- vim: set fdm=marker fdl=0: }}}
