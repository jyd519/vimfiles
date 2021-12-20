if has('nvim-0.6')
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
endif
