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
    lualine_c = {{'filename', path=1}, 'lsp_progress'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

