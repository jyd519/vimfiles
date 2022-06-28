-- lualine {{{1
require('lualine').setup {
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', {
      'diagnostics', sources = {'coc', 'ale'}}
    },
    lualine_c = {{'filename', path=1}},
    lualine_x = {'g:coc_status', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

