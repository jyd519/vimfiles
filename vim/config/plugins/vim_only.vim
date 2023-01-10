"
" Plugins for vim only
"
if g:is_nvim
  finish
endif

" Pascal configuration
"--------------------------------------------------------------------------------
autocmd vimrc BufReadPost *.pas,*.dpr set suffixesadd=.pas,.dpr,.txt,.dfm,.inc

" vim-json
"--------------------------------------------------------------------------------
let g:vim_json_syntax_conceal = 0

" tcomment
"--------------------------------------------------------------------------------
let g:tcomment#options_comments = {'whitespace': 'left'}
let g:tcomment#options_commentstring = {'whitespace': 'left'}

" vim-session settings
"--------------------------------------------------------------------------------
let g:session_autosave='prompt'
let g:session_autoload='no'
let g:session_autosave_periodic=0

" Graphviz
"--------------------------------------------------------------------------------
let g:WMGraphviz_output = "svg"
let g:previm_open_cmd = 'open -a "google chrome"'
