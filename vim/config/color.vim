let g:PaperColor_Theme_Options = {
      \   'theme': {
        \     'default.light': {
          \       'transparent_background': 1,
          \       'allow_bold': 1,
          \       'allow_italic': 0
          \     }
          \   },
          \   'language': {
            \     'python': {
              \       'highlight_builtins' : 1
              \     },
              \     'cpp': {
                \       'highlight_standard_library': 1
                \     },
                \     'c': {
                  \       'highlight_builtins' : 1
                  \     }
                  \   }
                  \ }

set background=light

" color gruvbox
if g:is_nvim
  color vscode
else
  color PaperColor
endif

if &background ==# 'light'
  exec 'hi SignColumn guibg=#eeeeee'
endif
