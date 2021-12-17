" YCM (YouCompleteMe) 
"--------------------------------------------------------------------------------
let g:ycm_confirm_extra_conf = 0
let g:ycm_use_ultisnips_completer = 1
let g:ycm_filepath_completion_use_working_dir = 0
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_key_invoke_completion = ''
let g:ycm_global_ycm_extra_conf = expand('$VIMFILES/scripts/ycm_extra_conf.py')
" let g:ycm_min_num_of_chars_for_completion = 2

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

nmap gd :YcmCompleter GoTo<CR>
nmap <leader>jt :YcmCompleter GoToDefinition<CR>
nmap gD :YcmCompleter GetDoc<CR>
nmap <leader>jf :YcmCompleter GoToInclude<CR>
nmap <leader>jI :YcmCompleter GoToImplementation<CR>
nmap <leader>jr :YcmCompleter GoToReferences<CR>
nmap <leader>rn :YcmCompleter RefactorRename
nnoremap <silent> K :call <SID>show_documentation()<CR>
ca yc YcmCompleter
ca Yc YcmCompleter

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
