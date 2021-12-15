local vim = vim
local execute = vim.api.nvim_exec

function _G.put(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
_G.dump = _G.put

-- Highlight on yank
execute([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

if vim.fn.exists("g:plugs") == 1 then
  return -- Using vim-plug
end

-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "godot_resource" },  -- list of language that will be disabled
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
  },
}

-- notify
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

require('lualine').setup {
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', {'diagnostics', sources = {'coc', 'ale'}}},
    lualine_c = {'filename'},
    lualine_x = {'g:coc_status', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- numToStr/Comment.nvim
require('Comment').setup()

-- chentau/marks.nvim
require('marks').setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  mappings = {}
}
