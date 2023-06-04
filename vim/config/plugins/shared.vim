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
let g:surround_{char2nr("f")} = "💥 \r 💥"
" }}}

" markdown {{{
"--------------------------------------------------------------------------------
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_folding_style_pythonic=1
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:mdip_imgdir='images'

" vim supports fenced code syntax
"  -> https://vimtricks.com/p/highlight-syntax-inside-markdown/
let g:markdown_fenced_languages=["cpp", "c", "css", "rust", "lua", "vim", "bash", "sh=bash", "go", "html",
      \ "yaml", "yml=yaml", "dockerfile", "objc", "objcpp", "conf", "toml",
      \  "javascript", "js=javascript", "typescript", "ts=typescript", "json=javascript", "python"]
" }}}

" ALE {{{
"--------------------------------------------------------------------------------
let g:ale_enabled = 1
let g:ale_disable_lsp = 1 " use lsp with coc-nvim instead
let g:ale_use_neovim_diagnostics_api = g:is_nvim
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 1
let g:ale_lint_on_enter = 0 " We prefer run ALELint manually
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save=0
let g:ale_open_list=1
let g:ale_maximum_file_size=256000 " 256KB
let g:ale_echo_msg_format = "[%linter%] %s [%severity%]"
let g:ale_echo_msg_error_str="E"
let g:ale_echo_msg_warning_str = "W"
let g:ale_c_parse_compile_commands = 0
let g:ale_objcpp_clang_options = '-std=c++17 -Wall'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
let g:ale_c_cc_options = '-std=c11 -Wall'
let g:ale_python_mypy_options='--follow-imports=silent'
let g:ale_pattern_options_enabled = 1
let g:ale_linters = {
      \ 'javascript': [],
      \ 'typescript': [],
      \ 'python': ['pylint', 'mypy', 'black'],
      \ 'go': ['gofmt', 'golint', 'gopls', 'govet', 'golangci-lint'],
      \ 'cpp': [],
      \ 'c': [],
      \}

let g:ale_pattern_options = {
      \ '\.min\.js$': {'ale_enabled': 0},
      \ '\.min\.css$': {'ale_enabled': 0},
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'python': ['black', 'yapf', 'isort'],
      \}

nnoremap <leader>L <Plug>(ale_lint)
nnoremap <leader>fx <Plug>(ale_fix)
" }}}

" vim-session settings {{{
"--------------------------------------------------------------------------------
let g:session_autosave='prompt'
let g:session_autoload='no'
let g:session_autosave_periodic=0
" }}}

" fzf/telescopoe {{{1
if get(g:enabled_plugins, "telescope.nvim", 0)
  "--------------------------------------------------------------------------------
  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fh <cmd>Telescope oldfiles<cr>
  nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
  nnoremap <C-P> <cmd>Telescope find_files<cr>
elseif get(g:enabled_plugins, "fzf.vim", 0)
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

  function! s:find_notes(sub)
    let opts = {'source': 'rg --files --hidden --smart-case --glob "!.git/*" --glob "*.md" ' . a:sub,
          \ 'sink': 'e',
          \ 'down': '50%',
          \ 'dir': g:notes_dir,
          \ 'options': ['--info=inline', '--reverse']}
    call fzf#run(opts)
  endfunction

  if exists('g:notes_dir') && executable("rg")
    command! -nargs=? Notes call s:find_notes(<q-args>)
    nnoremap <leader>fn :Notes<CR>
  endif

  if has("nvim")
    " Allow to press esc key to close fzf window
    autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
  endif
endif
" }}}

" t.vim {{{
"--------------------------------------------------------------------------------
let g:mysnippets_dir = expand("$VIMFILES/mysnippets/codesnippets")
let $mysnippets = g:mysnippets_dir

if get(g:enabled_plugins, "telescope.nvim", 0)
  " integrate with telescope
elseif get(g:enabled_plugins, "fzf.vim", 0)
  " integrate with fzf
  function! s:search_template(arg, bang)
    let all = len(&ft) == 0 || a:arg =~ 'a'
    call fzf#vim#files((all? g:mysnippets_dir : g:mysnippets_dir . '/' . &ft),
          \ fzf#vim#with_preview({'sink': 'r', 'options': [ '--info=inline']}),
          \ a:bang)
  endfunction

  command! -bang -nargs=? Ft call s:search_template(<q-args>, <bang>0)
  nmap <leader>ft :Ft<CR>
endif

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
if get(g:enabled_plugins, "vim-easy-align", 0)
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap <leader>a <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap <leader>a <Plug>(EasyAlign)
endif
"}}}

" NERDTree {{{
"--------------------------------------------------------------------------------
if get(g:enabled_plugins, "nerdtree", 0)
  let g:NERDTreeWinSize=40
  noremap <F3> :NERDTreeToggle<cr>
  noremap <leader>nf :NERDTreeFind<cr>
endif
" }}}

" Graphviz {{{
"--------------------------------------------------------------------------------
let g:WMGraphviz_output = "svg"
let g:previm_open_cmd = 'open -a "google chrome"'
" }}}

" vim-go / golang {{{
"--------------------------------------------------------------------------------
if get(g:enabled_plugins, "vim-go", 0)
  let g:go_fmt_fail_silently = 1
  let g:go_snippet_engine='ultisnips'
  let g:go_doc_popup_window = 1

  let g:go_term_mode = "split"
  let g:go_term_enabled = 1
  let g:go_term_reuse = 1
  let g:go_term_width = 80
  let g:go_term_height = 10
  let g:go_term_close_on_exit = 0

  function! s:setupGoMapping()
    noremap <buffer> <leader>rt :GoTestFunc<cr>
    noremap <buffer> <leader>r :QuickRun<cr>

    " abbrev
    ca <buffer> ips GoImports
    command! -buffer -bang A call go#alternate#Switch(<bang>0, 'edit')
    command! -buffer -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    command! -buffer -bang AS call go#alternate#Switch(<bang>0, 'split')
    command! -buffer -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  endfunction

  autocmd vimrc FileType go call s:setupGoMapping()
endif
" }}}

" Neoformat {{{
"--------------------------------------------------------------------------------
let g:neoformat_try_node_exe = 1
" Enable alignment globally
let g:neoformat_basic_format_align = 1
" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_javascript = ['prettierd', 'prettier', 'jsbeautify']
let g:neoformat_enabled_typescript = ['prettierd', 'prettier', 'tsfmt']
let g:neoformat_enabled_css = ['prettierd', 'prettier', 'tsfmt']
let g:neoformat_enabled_html = ['prettierd', 'prettier','htmlbeautify']
let g:neoformat_enabled_python = ['black', 'isort', 'docformatter', 'pyment', 'pydevf']
nmap <leader>F :Neoformat<CR>
" }}}

" vim-test {{{
"--------------------------------------------------------------------------------
if get(g:enabled_plugins, "test", 0)
  if g:is_nvim
    let g:test#strategy = "neovim"
    let g:test#neovim#start_normal = 0 " 1: enter normal mode
    tnoremap <C-o> <C-\><C-n>
  endif

  let test#javascript#runner = 'jest'
  let test#python#djangotest#options = '--keepdb'
  let test#rust#cargotest#options = '-- --nocapture'
  let test#go#test#options = '-v'
  autocmd vimrc Filetype javascript,typescript,go,rust,python noremap <buffer> <leader>rt :TestNearest<cr>
  autocmd vimrc Filetype javascript,typescript,go,rust,python noremap <buffer> <leader>tt :TestNearest<cr>
  autocmd vimrc Filetype javascript,typescript,go,python noremap <buffer> <leader>tf :TestFile<cr>
endif
" }}}

" quickrun {{{
"--------------------------------------------------------------------------------
if get(g:enabled_plugins, "vim-quickrun", 0)
  let g:quickrun_no_default_key_mappings = 1 " Disable the default keymap to ,r
  autocmd vimrc Filetype lua noremap <buffer> <leader>r :QuickRun<cr>
endif
" }}}

" victionary
"--------------------------------------------------------------------------------
let g:victionary#map_defaults = 0

" tmux_navigator: Disable tmux navigator when zooming the Vim pane
"--------------------------------------------------------------------------------
if get(g:enabled_plugins, "vim-tmux-navigator", 0)
  let g:tmux_navigator_disable_when_zoomed = 1
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
endif

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

" vim plugins
"--------------------------------------------------------------------------------
if !g:is_nvim
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
endif

" put the quickfix window on bottom always
autocmd vimrc FileType qf wincmd J

"--------------------------------------------------------------------------------
" vim: set fdm=marker fen: }}}
