" Plugins shared between neovim and vim8

" emmet-vim {{{
"--------------------------------------------------------------------------------
let g:user_emmet_leader_key=','
" }}}

" UltiSnips {{{
"--------------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<C-k>"
let g:UltiSnipsListSnippets="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-k>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
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
" }}}

" t.vim {{{
"--------------------------------------------------------------------------------
let g:mysnippets_dir = expand("$VIMFILES/mysnippets")
let $mysnippets_dir = expand("$VIMFILES/mysnippets")

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
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
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
endif
nmap <silent> t<C-n> :TestNearest<CR>
function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction
nmap <silent> t<C-d> :call DebugNearest()<CR>
" }}}

" quickrun {{{
"--------------------------------------------------------------------------------
let g:quickrun_no_default_key_mappings = 1 " Disable the default keymap to ,r
autocmd vimrc Filetype lua noremap <buffer> <leader>r :QuickRun<cr>
" }}}

" vimspector {{{
"--------------------------------------------------------------------------------
" let g:vimspector_enable_mappings = 'HUMAN'
let s:mapped = {}
function! s:OnJumpToFrame() abort
  if has_key( s:mapped, string( bufnr() ) )
    return
  endif

  nmap <silent> <buffer> <LocalLeader>dn <Plug>VimspectorStepOver
  nmap <silent> <buffer> <LocalLeader>ds <Plug>VimspectorStepInto
  nmap <silent> <buffer> <LocalLeader>df <Plug>VimspectorStepOut
  nmap <silent> <buffer> <LocalLeader>dc <Plug>VimspectorContinue
  nmap <silent> <buffer> <LocalLeader>dv <Plug>VimspectorBalloonEval
  xmap <silent> <buffer> <LocalLeader>dv <Plug>VimspectorBalloonEval
  nmap <silent> <buffer> <F5> <Plug>VimspectorContinue
  nmap <silent> <buffer> <F3>	<Plug>VimspectorStop
  nmap <silent> <buffer> <F4>	<Plug>VimspectorRestart
  nmap <silent> <buffer> <F6>	<Plug>VimspectorPause
  nmap <silent> <buffer> <F9>	<Plug>VimspectorToggleBreakpoint
  nmap <silent> <buffer> <leader><F9>	<Plug>VimspectorToggleConditionalBreakpoint
  nmap <silent> <buffer> <F8>	<Plug>VimspectorAddFunctionBreakpoint
  nmap <silent> <buffer> <leader><F8>	<Plug>VimspectorRunToCursor
  nmap <silent> <buffer> <F10>	<Plug>VimspectorStepOver
  nmap <silent> <buffer> <F11>	<Plug>VimspectorStepInto
  nmap <silent> <buffer> <F12>	<Plug>VimspectorStepOut
  let s:mapped[ string( bufnr() ) ] = { 'modifiable': &modifiable }

  setlocal nomodifiable

endfunction

function! s:OnDebugEnd() abort
  let original_buf = bufnr()
  let hidden = &hidden
  augroup VimspectorSwapExists
    au!
    autocmd SwapExists * let v:swapchoice='o'
  augroup END

  try
    set hidden
    for bufnr in keys( s:mapped )
      try
        execute 'buffer' bufnr
        silent! nunmap <buffer> <LocalLeader>dn
        silent! nunmap <buffer> <LocalLeader>ds
        silent! nunmap <buffer> <LocalLeader>df
        silent! nunmap <buffer> <LocalLeader>dc
        silent! nunmap <buffer> <LocalLeader>dv
        silent! xunmap <buffer> <LocalLeader>dv
        silent! nunmap <buffer> <F5>
        silent! nunmap <buffer> <F6>
        silent! nunmap <buffer> <F7>
        silent! nunmap <buffer> <F8>
        silent! nunmap <buffer> <Leader><F8>
        silent! nunmap <buffer> <F9>
        silent! nunmap <buffer> <Leader><F9>
        silent! nunmap <buffer> <F10>
        silent! nunmap <buffer> <F11>
        silent! nunmap <buffer> <F12>

        let &l:modifiable = s:mapped[ bufnr ][ 'modifiable' ]
      endtry
    endfor
  finally
    execute 'noautocmd buffer' original_buf
    let &hidden = hidden
  endtry

  au! VimspectorSwapExists

  let s:mapped = {}
endfunction

augroup VimspectorCustomMappings
  au!
  autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
  autocmd User VimspectorDebugEnded ++nested call s:OnDebugEnd()
augroup END
" }}}

" others {{{
" YCM & Coc.nvim
"--------------------------------------------------------------------------------
if executable('node') == 0
  echomsg "coc.nvim required nodejs"
else
  source $VIMFILES/config/plugins/coc.vim
endif

" victionary
"--------------------------------------------------------------------------------
let g:victionary#map_defaults = 0

" Draw ascii box
"--------------------------------------------------------------------------------
map <leader>tsk :call ToggleSketch()<CR>

" tmux_navigator: Disable tmux navigator when zooming the Vim pane
"--------------------------------------------------------------------------------
let g:tmux_navigator_disable_when_zoomed = 1

" Sneak
"--------------------------------------------------------------------------------
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

" rust
"--------------------------------------------------------------------------------
let g:rustfmt_autosave = 1
"
"--------------------------------------------------------------------------------
" vim: set fdm=marker fen: }}}
