" Plugins shared between neovim and vim8

" emmet-vim {{{
"--------------------------------------------------------------------------------
let g:user_emmet_leader_key=','
" }}}

" UltiSnips {{{
"--------------------------------------------------------------------------------
if !g:is_nvim 
  let g:UltiSnipsExpandTrigger="<C-k>"
  let g:UltiSnipsJumpForwardTrigger="<C-k>"
  let g:UltiSnipsJumpBackwardTrigger="<C-p>"
endif
let g:UltiSnipsListSnippets="<C-l>"
let g:UltiSnipsEditSplit='horizontal'
let g:UltiSnipsSnippetsDir=expand('$VIMFILES/mysnippets/ultisnips')
let g:UltiSnipsSnippetDirectories = [g:UltiSnipsSnippetsDir, "UltiSnips"]
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = g:UltiSnipsSnippetsDir
" }}}

" cmake {{{
"--------------------------------------------------------------------------------
autocmd vimrc BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in setf cmake
autocmd vimrc BufRead,BufNewFile *.ctest,*.ctest.in setf cmake
let g:cmake_default_config='Debug'
let g:cmake_build_type='Debug'
let g:cmake_export_compile_commands=1
let g:cmake_compile_commands=1
let g:cmake_ycm_symlinks=1
" }}}

" vim-surroud {{{
"--------------------------------------------------------------------------------
let g:surround_indent = 0 " Disable indenting for surrounded text
let g:surround_{char2nr("r")} = "💥 \r 💥"
" }}}

" markdown {{{
"--------------------------------------------------------------------------------
" " let g:markdown_folding=1
let g:vim_markdown_folding_disabled=0
let g:vim_markdown_folding_style_pythonic=1
let g:vim_markdown_toc_autofit =1
let g:instant_markdown_autostart = 0
let g:instant_markdown_slow=1
let g:mdip_imgdir='images'

let g:markdown_fenced_languages = ['bash=sh', 'js=javascript', 'ts=typescript']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100
" }}}

" ALE {{{
"--------------------------------------------------------------------------------
let g:ale_enabled = 1
let g:ale_maximum_file_size=512000 " 500KB
let g:ale_disable_lsp = 1 " use lsp with coc-nvim instead
let g:ale_linters = {
      \ 'javascript': ['eslint', 'prettier'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'python': ['flake8', 'mypy', 'pyright'],
      \ 'cpp': [],
      \ 'c': [],
      \}

let g:ale_echo_msg_format = "[%linter%] %s [%severity%]"
let g:ale_echo_msg_error_str="E"
let g:ale_echo_msg_warning_str = "W"
let g:ale_c_parse_compile_commands = 0
let g:ale_objcpp_clang_options = '-std=c++17 -Wall'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
let g:ale_c_cc_options = '-std=c11 -Wall'
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
" }}}

" vim-session settings {{{
"--------------------------------------------------------------------------------
let g:session_autosave='prompt'
let g:session_autoload='no'
let g:session_autosave_periodic=0
" }}}

" fzf: File searching {{{
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

if exists('g:notes_dir')
  command! -nargs=? Notes call fzf#run({'source': 'rg --files --hidden --smart-case --glob "!.git/*" --glob "*.md" ' . g:notes_dir , 'sink': 'e'})
  nnoremap <leader>fn :Notes<CR>
endif

if has("nvim")
  " Allow to press esc key to close fzf window
  autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
endif
" }}}

" t.vim {{{
"--------------------------------------------------------------------------------
let g:mysnippets_dir = expand("$VIMFILES/mysnippets/codesnippets")
let $mysnippets_dir = expand("$VIMFILES/mysnippets/codesnippets")

" integrate with fzf 
function! s:search_template(arg, bang)
  let all = len(&ft) == 0 || a:arg =~ 'a'
  call fzf#vim#files((all? g:mysnippets_dir : g:mysnippets_dir . '/' . &ft),
        \ fzf#vim#with_preview({'sink': 'r', 'options': [ '--info=inline']}),
        \ a:bang)
endfunction

command! -bang -nargs=? Ft call s:search_template(<q-args>, <bang>0)
nmap <leader>ft :Ft<CR>

" }}}

" The Silver Searcher {{{
"--------------------------------------------------------------------------------
if executable('ag')
  " Use ag over grep
  " set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c%m

  " Ag command
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

  " Jump to definition under cursore
  nnoremap gs :Ag <cword><CR>
endif
" }}}

"Man {{{
"--------------------------------------------------------------------------------
runtime ftplugin/man.vim
"}}}

"vim-easy-align {{{
"--------------------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <leader>a <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <leader>a <Plug>(EasyAlign)
"}}}

" NERDTree {{{
"--------------------------------------------------------------------------------
let g:NERDTreeWinSize=40
noremap <F3> :NERDTreeToggle<cr>
noremap <leader>nf :NERDTreeFind<cr>
" }}}

" Graphviz {{{
"--------------------------------------------------------------------------------
let g:WMGraphviz_output = "svg"
let g:previm_open_cmd = 'open -a "google chrome"'
" }}}

" vim-go / golang {{{
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

" abbrev
autocmd vimrc Filetype go ca <buffer> ips GoImports
autocmd vimrc Filetype go command! -buffer -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd vimrc Filetype go command! -buffer -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd vimrc Filetype go command! -buffer -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd vimrc Filetype go command! -buffer -bang AT call go#alternate#Switch(<bang>0, 'tabe')
" }}}

" Neoformat {{{
"--------------------------------------------------------------------------------
" prequirements: npm i -g prettier js-beautify ... 
let g:neoformat_try_node_exe = 1
" Enable alignment globally
let g:neoformat_basic_format_align = 1
" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_yaml= ['prettier']
" }}}

" vim-test {{{
"--------------------------------------------------------------------------------
if g:is_nvim
  let g:test#strategy = "neovim"
  let g:test#neovim#start_normal = 0 " 1: enter normal mode
  tnoremap <C-o> <C-\><C-n>
endif

let test#rust#cargotest#options = '-- --nocapture'
let test#go#test#options = '-v'
autocmd vimrc Filetype javascript,typescript,go,rust noremap <buffer> <leader>rt :TestNearest<cr>
autocmd vimrc Filetype javascript,typescript,go,rust noremap <buffer> <leader>tt :TestNearest<cr>
autocmd vimrc Filetype javascript,typescript,go noremap <buffer> <leader>tf :TestFile<cr>
" }}}

" quickrun {{{
"--------------------------------------------------------------------------------
let g:quickrun_no_default_key_mappings = 1 " Disable the default keymap to ,r
autocmd vimrc Filetype lua noremap <buffer> <leader>r :QuickRun<cr>
" }}}

" victionary
"--------------------------------------------------------------------------------
let g:victionary#map_defaults = 0

" Draw ascii box
"--------------------------------------------------------------------------------
map <leader>tsk :call ToggleSketch()<CR>

" tmux_navigator: Disable tmux navigator when zooming the Vim pane
"--------------------------------------------------------------------------------
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
1
" Sneak
"--------------------------------------------------------------------------------
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

" rust
"--------------------------------------------------------------------------------
let g:rustfmt_autosave = 1

" miscs
"--------------------------------------------------------------------------------
let g:ansible_unindent_after_newline = 1  " ansible
let g:BufKillCreateMappings = 0  " bufkill.vim

"--------------------------------------------------------------------------------
" vim: set fdm=marker fen: }}}
