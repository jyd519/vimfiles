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
else
  let g:UltiSnipsExpandTrigger = "<NUL>"
endif
let g:UltiSnipsListSnippets="<C-l>"
let g:UltiSnipsEditSplit='horizontal'
let g:UltiSnipsSnippetsDir=expand('$VIMFILES/mysnippets/ultisnips')
let g:UltiSnipsSnippetDirectories = [g:UltiSnipsSnippetsDir, "UltiSnips"]
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = g:UltiSnipsSnippetsDir
" }}}

" cmake {{{
"--------------------------------------------------------------------------------
" autocmd vimrc BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in setf cmake
" autocmd vimrc BufRead,BufNewFile *.ctest,*.ctest.in setf cmake
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
let g:markdown_fenced_languages=["cpp", "c", "css", "rust", "lua", "vim", "bash", "sh=bash", "go", "html", "swift",
      \ "yaml", "yml=yaml", "dockerfile", "objc", "objcpp", "conf", "toml", "cmake",
      \  "javascript", "js=javascript", "typescript", "ts=typescript", "json=javascript", "python"]
" }}}

" ALE {{{
"--------------------------------------------------------------------------------
let g:ale_enabled = 1
let g:ale_disable_lsp = 1 
let g:ale_use_neovim_diagnostics_api = g:is_nvim
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 1
let g:ale_open_list=1
let g:ale_lint_on_enter = 0 " We prefer run ALELint manually
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save=0
let g:ale_maximum_file_size=256000 " 256KB
let g:ale_echo_msg_format = "[%linter%] %s [%severity%]"
let g:ale_echo_msg_error_str="E"
let g:ale_echo_msg_warning_str = "W"
let g:ale_objcpp_clang_options = '-std=c++17 -Wall'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
let g:ale_c_cc_options = '-std=c11 -Wall'
let g:ale_python_mypy_options='--follow-imports=silent'
let g:ale_pattern_options_enabled = 1
let g:ale_linters = {
      \ 'javascript': ["eslint"],
      \ 'typescript': ["eslint"],
      \ 'python': ['ruff', 'pylint', 'mypy', 'black'],
      \ 'go': ['gofmt', 'golint', 'gopls', 'govet', 'golangci-lint'],
      \}

let g:ale_pattern_options = {
      \ '\.min\.js$': {'ale_enabled': 0},
      \ '\.min\.css$': {'ale_enabled': 0},
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'python': ['ruff', 'black', 'yapf', 'isort'],
      \}

nnoremap <leader>L <Plug>(ale_lint)
nnoremap <leader>xF <Plug>(ale_fix)
" }}}

" vim-session settings {{{
"--------------------------------------------------------------------------------
let g:session_autosave='prompt'
let g:session_autoload='no'
let g:session_autosave_periodic=0
" }}}

" fzf/telescope {{{1
if get(g:enabled_plugins, "fzf-lua", 0)
  " https://github.com/ibhagwan/fzf-lua
  nnoremap <C-P> <cmd>lua require('fzf-lua').files({cwd_prompt = false, prompt="Files> "})<CR>
  nnoremap <leader>ff <cmd>lua require('fzf-lua').files({ cwd_prompt = false, prompt="Files> ", fzf_opts = {['--layout'] = 'reverse-list'} })<CR>
  nnoremap <leader>ft <cmd>lua require('fzf-lua').files({ cwd_prompt = false, prompt="Notes> ", fzf_opts = {['--layout'] = 'reverse-list'}, cwd=vim.g.mysnippets_dir })<CR>
  nnoremap <leader>fm <cmd>lua require('fzf-lua').marks()<CR>
  nnoremap <leader>fo <cmd>lua require('fzf-lua').oldfiles()<CR>
  nnoremap <leader>fb <cmd>lua require('fzf-lua').buffers()<CR>
  nnoremap <leader>fx <cmd>lua require('fzf-lua').quickfix()<CR>
  nnoremap <leader>fl <cmd>lua require('fzf-lua').loclist()<CR>
  nnoremap <leader>fg <cmd>lua require('fzf-lua').git_files()<CR>
  nnoremap <leader>fs <cmd>lua require('fzf-lua').lsp_document_symbols()<CR>
  if exists('g:notes_dir') && executable("rg")
    "RIPGREP_CONFIG_PATH=~/.ripgreprc
    nnoremap <leader>fn <cmd>lua require('fzf-lua').files({ cwd_prompt=false, cmd='rg --files --hidden --smart-case ---glob "*.md"', cwd = vim.g.notes_dir })<CR>
    lua << EOF
    vim.api.nvim_buf_create_user_command(0, 'Notes',
      function(opts)
        require('fzf-lua').files({ cwd_prompt=false, cmd='rg --files --hidden --smart-case --glob "*.md" ' .. opts.fargs[1], cwd = vim.g.notes_dir })
      end,
      { nargs = 1,
        complete = function(ArgLead, CmdLine, CursorPos)
          return vim.fn.readdir(vim.g.notes_dir, function (filename) 
            return  vim.fn.isdirectory(vim.g.notes_dir .. '/' .. filename) == 1 and string.sub(filename, 1, 1) ~= "." 
          end)
      end,
      })
EOF
  endif
endif

if get(g:enabled_plugins, "fzf.vim", 0)
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

  if get(g:enabled_plugins, 'telescope', 0) == 0
    nnoremap <leader>ff :Files<CR>
    nnoremap <leader>fm :Marks<CR>
    nnoremap <leader>fo :History<CR>

    command! -nargs=0 Colors :Telescope colorscheme

    function! s:find_notes(sub)
      let opts = {'source': 'rg --files --hidden --smart-case --glob "*.md" ' . a:sub,
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

if get(g:enabled_plugins, "fzf.vim", 0)
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

" Fast grep {{{
"--------------------------------------------------------------------------------
if executable('rg')
  " Use rg over grep
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden
  set grepformat=%f:%l:%c%m

  " Ag command
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

  " Jump to definition under cursore
  nnoremap gs :Ag <cword><CR>
elseif executable('ag')
  " Use ag over grep
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
  vmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  xmap ga <Plug>(EasyAlign)
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
let g:neoformat_try_node_exe = 1 " prefer command in local node_modules
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
let g:neoformat_enabled_python = ['ruff', 'black', 'isort']
" bugfix: https://github.com/sbdchd/neoformat/issues/486
let g:neoformat_c_clangformat = {
            \ 'exe': 'clang-format',
            \ 'args': ['-assume-filename=', '"%:p"'],
            \ 'stdin': 1,
            \ }
let g:neoformat_cpp_clangformat = g:neoformat_c_clangformat
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
  let g:quickrun_config = {}
  let g:quickrun_config.cmake = { 'command': 'cmake', 'runner': 'system', 'exec': ['%c -P %s %a'] }
  autocmd vimrc Filetype lua,cmake noremap <buffer> <leader>r :QuickRun<cr>
endif
" }}}

" victionary
"--------------------------------------------------------------------------------
let g:victionary#map_defaults = 0

" tmux_navigator: Disable tmux navigator when zooming the Vim pane
"--------------------------------------------------------------------------------
if get(g:enabled_plugins, "tmux", 0)
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

" floaterm
if has("win32")
  let g:floaterm_shell="pwsh.exe"
endif
nnoremap   <silent>   <F1>    :FloatermNew<CR>
tnoremap   <silent>   <F1>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>

" Use PowerShell
if has("win32") && get(g:enabled_plugins, "powershell") == 1
  " Use powershell
  let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
  let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
  let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
  set shellquote= shellxquote=
endif


" put the quickfix window on bottom always
autocmd vimrc FileType qf wincmd J

if get(g:enabled_plugins, "coc", 0)
  runtime config/plugins/coc.vim
endif

" log file
if !g:is_nvim
  autocmd vimrc BufReadPost *.log set ft=log
endif

"--------------------------------------------------------------------------------
" vim: set fdm=marker fen: }}}
