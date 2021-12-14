"--------------------------------------------------------------------------------
" Configurations for Vim/Neovim ( +lua, +python )
" Jyd  Last-Modified: 2021-12-13
"--------------------------------------------------------------------------------
set nocompatible " Disable compatibility with vi 
let $VIMFILES=fnamemodify(resolve(expand('<sfile>:p')), ':h')
set rtp^=$VIMFILES 
set rtp+=$VIMFILES/after
set packpath^=$VIMFILES

if $VIM_MODE =~ 'man'
  source $VIMFILES/config/man.vim
  finish
endif

" load local customized script
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let s:configs = [ 
      \ 'config/globals.vim',
      \ 'config/options.vim',
      \ 'config/mappings.vim',
      \ 'config/ctags.vim',
      \ ]

for s in s:configs 
  execute printf('source %s/%s', $VIMFILES, s)
endfor


" Source required plugins
if $VIM_MODE =~ 'ycm'
  let g:did_coc_loaded = 1        " Disable COC
else
  let $VIM_MODE = 'coc'
  let g:loaded_youcompleteme = 1  " Disable YCM
endif
if exists('g:vscode')
  source $VIMFILES/config/vscode.vim
  finish
else
  source $VIMFILES/config/bundles.vim
endif

source $VIMFILES/config/color.vim

" Pascal configuration
"--------------------------------------------------------------------------------
autocmd vimrc BufReadPost *.pas,*.dpr set suffixesadd=.pas,.dpr,.txt,.dfm,.inc

" vim-json
let g:vim_json_syntax_conceal = 0

" emmet-vim
let g:user_emmet_leader_key=','

" UltiSnips
"--------------------------------------------------------------------------------
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsListSnippets="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
let g:UltiSnipsEditSplit='horizontal'
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
let g:UltiSnipsSnippetsDir=expand('$VIMFILES/mysnippets/ultisnips')
set rtp+=$VIMFILES/mysnippets

" t.vim
let g:mysnippets_dir = expand("$VIMFILES/mysnippets")

" cmake
"--------------------------------------------------------------------------------
autocmd vimrc BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in setf cmake
autocmd vimrc BufRead,BufNewFile *.ctest,*.ctest.in setf cmake
let g:cmake_default_config='Debug'
let g:cmake_build_type='Debug'
let g:cmake_export_compile_commands=1
let g:cmake_compile_commands=1
let g:cmake_ycm_symlinks=1

" vim-surroud
"--------------------------------------------------------------------------------
let g:surround_indent = 0 " Disable indenting for surrounded text
let g:surround_{char2nr("r")} = "💥 \r 💥"

" markdown
"--------------------------------------------------------------------------------
let g:vim_markdown_folding_disabled=0
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_folding = 3
let g:instant_markdown_autostart = 0
let g:instant_markdown_slow = 1

let g:mdip_imgdir = 'images'
let s:mdctags_path = expand('$VIMFILES').'/tools/markdown2ctags.py'

" gulp
"--------------------------------------------------------------------------------
autocmd vimrc BufRead,BufNewFile gulpfile.js setlocal errorformat=%-G[%.%#,%f:%m,%-G%p,%-G%n%perror

" livedown
"--------------------------------------------------------------------------------
let g:livedown_autorun = 0

" should the browser window pop-up upon previewing
let g:livedown_open = 1

" ALE
"--------------------------------------------------------------------------------
let g:ale_enabled = 1
let g:ale_maximum_file_size=512000 " 500KB
let g:ale_disable_lsp = 1 " use lsp with coc-nvim instead
let g:ale_linters = {
      \ 'javascript': ['eslint', 'prettier'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'python': ['flake8', 'pylint'],
      \ 'cpp': [],
      \ 'c': [],
      \}

let g:ale_echo_msg_format = "[%linter%] %s [%severity%]"
let g:ale_echo_msg_error_str="E"
let g:ale_echo_msg_warning_str = "W"
let g:ale_c_parse_compile_commands = 0
let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {
      \ '\.min\.js$': {'ale_enabled': 0},
      \ '\.min\.css$': {'ale_enabled': 0},
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'python': ['autopep8', 'yapf'],
      \}

" tcomment
"--------------------------------------------------------------------------------
let g:tcomment#options_comments = {'whitespace': 'left'}
let g:tcomment#options_commentstring = {'whitespace': 'left'}

"--------------------------------------------------------------------------------
" tagbar/vista settings
"--------------------------------------------------------------------------------
" map <leader>t :TagbarToggle<cr>
" let g:tagbar_compact = 1
" if filereadable($VIMFILES . '/tagbar.conf')
"     source $VIMFILES/tagbar.conf
" endif
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_executive_for = {
      \ 'vim': 'coc',
      \ 'typescript': 'coc',
      \ 'javascript': 'coc',
      \ 'cpp': 'coc',
      \ 'c': 'coc',
      \ 'markdown': 'toc',
      \ }
let g:vista#renderer#icons = {
      \   "function": "\uf794",
      \   "variable": "\uf71b",
      \   "prototype": "\uf013",
      \   "macro": "\uf00b",
      \  }
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = "coc"

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}
map <leader>t :Vista!!<CR>
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

"--------------------------------------------------------------------------------
" vim-session settings
"--------------------------------------------------------------------------------
let g:session_autosave='prompt'
let g:session_autoload='no'
let g:session_autosave_periodic=0

"--------------------------------------------------------------------------------
" airline settings
"--------------------------------------------------------------------------------
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_section_b = '' "'%-20{getcwd()}'

"--------------------------------------------------------------------------------
" Search the selected text
"--------------------------------------------------------------------------------
function! s:getSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction
vnoremap <silent> * :call setreg("/",
      \ substitute(<SID>getSelectedText(),
      \ '\_s\+',
      \ '\\_s\\+', 'g')
      \ )<Cr>n

vnoremap <silent> # :call setreg("?",
      \ substitute(<SID>getSelectedText(),
      \ '\_s\+',
      \ '\\_s\\+', 'g')
      \ )<Cr>n

"--------------------------------------------------------------------------------
" fzf: File searching
"--------------------------------------------------------------------------------
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \}

" Popup window
let g:fzf_layout = { 'down': '50%' }

" key binding
nnoremap <C-P> :Files<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>b :Buffers<CR>

"--------------------------------------------------------------------------------
" settings for t.vim
"--------------------------------------------------------------------------------
function! s:search_template(arg, bang)
  let all = len(&ft) == 0 || a:arg =~ 'a'
  call fzf#vim#files((all? g:mysnippets_dir : g:mysnippets_dir . '/' . &ft),
        \ fzf#vim#with_preview({'sink': 'r', 'options': [ '--info=inline']}),
        \ a:bang)
endfunction

command! -bang -nargs=? Ft call s:search_template(<q-args>, <bang>0)
nmap <leader>ft :Ft<CR>

"--------------------------------------------------------------------------------
" The Silver Searcher
"--------------------------------------------------------------------------------
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m

  " Ag command
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

  " Jump to definition under cursore
  nnoremap gs :Ag <cword><CR>
endif

"Man
"--------------------------------------------------------------------------------
runtime ftplugin/man.vim

"vim-easy-align
"--------------------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"Convert selected text to javascript string
"--------------------------------------------------------------------------------
function! s:ToJS(sep, first_line, last_line)
  let i = a:first_line
  while i<=a:last_line
    let l = getline(i)
    let l = substitute(l, a:sep, "\\\\".a:sep, "g")
    if i==a:last_line
      call setline(i, a:sep . l . a:sep . ";" )
    else
      call setline(i, a:sep . l . a:sep . " + " )
    endif
    let i=i+1
  endwhile
endfunction
command!  -nargs=1 -range ToJs call s:ToJS(<q-args>, <line1>, <line2>)

" Apply macro on selected lines
"--------------------------------------------------------------------------------
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" NERDTree
"--------------------------------------------------------------------------------
let g:NERDTreeWinSize=40
noremap <F3> :NERDTreeToggle<cr>
noremap <leader>nf :NERDTreeFind<cr>

" Quick unescape xml entities
"--------------------------------------------------------------------------------
function! XmlUnescape()
  silent! execute ':%s/&lt;/</g'
  silent! execute ':%s/&gt;/>/g'
  silent! execute ':%s/&amp;/\&/g'
endfunction
command! -nargs=0 XmlUnescape :call XmlUnescape()
nnoremap <leader>xf :call XmlUnescape()

" Unescape \uXXXX sequences in selected lines
"--------------------------------------------------------------------------------
function! UnescapeUnicode() range
  let cmd = a:firstline . "," . a:lastline . 's/\\u\(\x\{4\}\)/\=nr2char("0x".submatch(1),1)/g'
  silent! execute cmd
endfunction
command! -nargs=0 -range=% UnescapeUnicode :<line1>,<line2>call UnescapeUnicode()

" Convert rows of numbers or text (as if pasted from excel column) to a tuple
"--------------------------------------------------------------------------------
function! ToTupleFunction() range
  silent execute a:firstline . "," . a:lastline . "s/^/'/"
  silent execute a:firstline . "," . a:lastline . "s/$/',/"
  silent execute a:firstline . "," . a:lastline . "join"
  silent execute "normal I("
  silent execute "normal $xa)"
  silent execute "normal ggVGYY"
endfunction
command! -range ToTuple <line1>,<line2> call ToTupleFunction()

" Dot
"--------------------------------------------------------------------------------
function! Dot(bang, format)
  let fmt = a:format
  if empty(fmt)
    let fmt = 'png'
  endif
  let cmd = '!dot'
  let opt = ' -T' . fmt . ' -o '
  let currfile = expand('%:p')
  let outfile = expand('%:p:r') . '.' . fmt
  echom opt
  silent execute cmd . ' "' . currfile . '" '. opt . ' "' . outfile . '" '
  if a:bang
    call system('open ' . outfile)
  endif
endfunction
command! -nargs=* -bang Dot :call Dot(<bang>0, <q-args>)|redraw!
let g:WMGraphviz_output = "svg"

let g:previm_open_cmd = 'open -a "google chrome"'

" vim-go / golang
"--------------------------------------------------------------------------------
let g:go_fmt_fail_silently = 1
let g:go_snippet_engine='ultisnips'
let g:go_doc_popup_window = 1

let g:go_term_mode = "split"
let g:go_term_enabled = 1
let g:go_term_reuse = 1
let g:go_term_width = 80
let g:go_term_height = 10
let g:go_term_close_on_exit = 0

autocmd vimrc Filetype go noremap <buffer> <leader>rt :GoTestFunc<cr>
autocmd vimrc Filetype go noremap <buffer> <leader>r :QuickRun<cr>
autocmd vimrc Filetype go noremap <buffer> <f9> :QuickRun<cr>

" abbrev
autocmd vimrc Filetype go ca <buffer> ips GoImports
autocmd vimrc Filetype go noremap <buffer> <F5> :GoBuild<cr>
autocmd vimrc Filetype go command! -buffer -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd vimrc Filetype go command! -buffer -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd vimrc Filetype go command! -buffer -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd vimrc Filetype go command! -buffer -bang AT call go#alternate#Switch(<bang>0, 'tabe')


" clang_format
"--------------------------------------------------------------------------------
let g:clang_format#style_options = {
      \ "ColumnLimit": 0,
      \ "AllowShortIfStatementsOnASingleLine" : "true",
      \ "AlwaysBreakTemplateDeclarations" : "true",
      \ "Standard" : "C++17"}

" let g:clang_format#command='/usr/local/bin/clang-format'
autocmd vimrc FileType c,cpp,objc,objcpp nnoremap <buffer> <Leader>cf :<C-u>ClangFormat<CR>
autocmd vimrc FileType c,cpp,objc,objcpp vnoremap <buffer> <Leader>cf :ClangFormat<CR>
autocmd vimrc FileType c,cpp,objc,objcpp nmap <buffer> <Leader>C :ClangFormatAutoToggle<CR>

" Neoformat
"--------------------------------------------------------------------------------
" prequirements: npm i -g prettier js-beautify ... 
let g:neoformat_try_node_exe = 1

" YCM & Coc.nvim
"--------------------------------------------------------------------------------
if $VIM_MODE =~ 'ycm'
  source $VIMFILES/config/plugins/ycm.vim
elseif $VIM_MODE =~ 'coc'
  source $VIMFILES/config/plugins/coc.vim
endif

" victionary
"--------------------------------------------------------------------------------
let g:victionary#map_defaults = 0

" Draw ascii box
"--------------------------------------------------------------------------------
map <leader>tsk :call ToggleSketch()<CR>

" Disable tmux navigator when zooming the Vim pane
"--------------------------------------------------------------------------------
let g:tmux_navigator_disable_when_zoomed = 1

" EasyMotion
"--------------------------------------------------------------------------------
" let g:EasyMotion_do_mapping = 0 " Disable default mappings
" let g:EasyMotion_smartcase = 1 " Turn on case-insensitive feature
"
" " Jump to anywhere you want with minimal keystrokes.
" " `s{char}{char}{label}`
" nmap s <Plug>(easymotion-overwin-f2)
"
" " JK motions: Line motions
" nmap <Leader><Leader>j <Plug>(easymotion-j)
" nmap <Leader><Leader>k <Plug>(easymotion-k)
" " Move to a word
" nmap <Leader><Leader>w <Plug>(easymotion-w)
" " Move to line
" map <Leader>L <Plug>(easymotion-bd-jk)
" nmap <Leader>L <Plug>(easymotion-overwin-line)

" Sneak
"--------------------------------------------------------------------------------
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1


" vimspector
"--------------------------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'

" rust
let g:rustfmt_autosave = 1

" vim-test
if g:is_nvim
  let g:test#strategy = "neovim"
endif
nmap <silent> t<C-n> :TestNearest<CR>
function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction
nmap <silent> t<C-d> :call DebugNearest()<CR>

" quickrun
let g:quickrun_no_default_key_mappings = 1 " Disable the default keymap to ,r
autocmd vimrc Filetype lua noremap <buffer> <leader>r :QuickRun<cr>
autocmd vimrc Filetype lua noremap <buffer> <f9> :QuickRun<cr>

if g:is_nvim
  " source lua config
  luafile $VIMFILES/lua/config.lua
endif

" Load user specific configurations
if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
