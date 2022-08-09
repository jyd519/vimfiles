-- globals {{{1
local vim = vim

-- notify {{{1
require("notify").setup({
  -- Animation style (see below for details)
  stages = "fade_in_slide_out",

  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,

  -- Function called when a window is closed
  on_close = nil,

  -- Render function for notifications. See notify-render()
  render = "default",

  -- Default timeout for notifications
  timeout = 5000,

  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
  background_colour = "#000000",
  -- Minimum width for notification windows
  minimum_width = 50,
})

vim.notify = require("notify")

-- numToStr/Comment.nvim {{{1
require('Comment').setup()

-- windwp/nvim-projectconfig -- {{{1
require('nvim-projectconfig').setup({silent = false})

-- filetype.nvim -- {{{1
-- https://github.com/nathom/filetype.nvim/blob/main/README.md
require("filetype").setup({
    overrides = {
        extensions = {
            mm = "objcpp",
        },
        complex = {
            -- Set the filetype of any full filename matching the regex to gitconfig
            [".*git/config"] = "gitconfig", -- Included in the plugin
        },
    },
})

-- indent_blankline -- {{{1
local treesitter_enabled = packer_plugins and packer_plugins["nvim-treesitter"] ~= nil
require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = treesitter_enabled,
    show_current_context_start = treesitter_enabled,
}

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

 -- my utils
vim.api.nvim_set_keymap(
	"n",
	"<leader>sl",
	"<cmd>lua require('myrc.split').splitJsString()<CR>",
	{ noremap = true }
)

-- vim: set fdm=marker fen fdl=0: }}}
