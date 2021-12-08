" YCM configurations
"--------------------------------------------------------------------------------

" let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_confirm_extra_conf = 0
let g:ycm_use_ultisnips_completer = 1
let g:ycm_filepath_completion_use_working_dir = 0
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_key_invoke_completion = ''
let g:ycm_global_ycm_extra_conf = expand('$VIMFILES/ycm_extra_conf.py')

if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif

let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'],
      \   'objc' : ['->', '.'],
      \   'rust' : ['.', '::'],
      \   'ocaml' : ['.', '#'],
      \   'cpp,objcpp' : ['->', '.', '::'],
      \   'perl' : ['->'],
      \   'php' : ['->', '::', '"', "'", 'use ', 'namespace ', '\'],
      \   'python,cs,java,javascript,typescript,d,perl6,scala,vb,go' : ['.'],
      \   'html': ['<', '"', '</', ' '],
      \   'vim' : ['re![_a-za-z]+[_\w]*\.'],
      \   'ruby' : ['.', '::'],
      \   'lua' : ['.', ':'],
      \   'erlang' : [':'],
      \   'haskell' : ['.', 're!.']
      \ }

augroup ycm_confg 
  autocmd!
  autocmd BufRead,BufNewFile * call s:init_ycm() 
augroup END

function! s:init_ycm()
  nmap <buffer> gd :YcmCompleter GoTo<CR>
  nmap <buffer> <leader>jt :YcmCompleter GoToDefinition<CR>
  nmap <buffer> gD :YcmCompleter GetDoc<CR>
  nmap <buffer> <leader>jf :YcmCompleter GoToInclude<CR>
  nmap <buffer> <leader>jI :YcmCompleter GoToImplementation<CR>
  nmap <buffer> <leader>jr :YcmCompleter GoToReferences<CR>
  nmap <buffer> <leader>rn :YcmCompleter RefactorRename
  nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
  ca <buffer> yc YcmCompleter
  ca <buffer> Yc YcmCompleter
endfunction

" Use K to show documentation in preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    exec 'Man '.expand('<cword>')
  endif
endfunction

let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}

let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'html': 1,
      \ 'xhtml': 1,
      \ 'jsx': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1
      \}

" Multiple_cursors and YCM
function! Multiple_cursors_before()
    let g:ycm_auto_trigger = 0
endfunction

function! Multiple_cursors_after()
    let g:ycm_auto_trigger = 1
endfunction

" Config lsp
let s:lsp = expand('$VIMFILES/../lsp-examples')
if isdirectory(s:lsp)
  let g:ycm_language_server = [
        \   {
        \     'name': 'bash',
        \     'cmdline': [ 'node', expand( s:lsp . '/bash/node_modules/.bin/bash-language-server' ), 'start' ],
        \     'filetypes': [ 'sh', 'bash' ],
        \   },
        \   {
        \     'name': 'yaml',
        \     'cmdline': [ 'node', expand( s:lsp . '/yaml/node_modules/.bin/yaml-language-server' ), '--stdio' ],
        \     'filetypes': [ 'yaml' ],
        \   },
        \   {
        \     'name': 'json',
        \     'cmdline': [ 'node', expand( s:lsp . '/json/node_modules/.bin/vscode-json-languageserver' ), '--stdio' ],
        \     'filetypes': [ 'json' ],
        \   },
        \   { 'name': 'docker',
        \     'filetypes': [ 'dockerfile' ], 
        \     'cmdline': [ expand( s:lsp . '/docker/node_modules/.bin/docker-langserver' ), '--stdio' ]
        \   },
        \   { 'name': 'vim',
        \     'filetypes': [ 'vim' ],
        \     'cmdline': [ expand( s:lsp . '/viml/node_modules/.bin/vim-language-server' ), '--stdio' ]
        \   },
        \   { 'name': 'rust',
        \     'filetypes': [ 'rust' ],
        \     'cmdline': [ expand( s:lsp .  '/rust/rust-analyzer/target/release/rust-analyzer' ) ],
        \     'project_root_files': [ 'Cargo.toml' ],
        \   },
        \ ]
endif
