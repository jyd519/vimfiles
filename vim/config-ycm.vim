" YCM configurations
"--------------------------------------------------------------------------------
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_confirm_extra_conf = 0
let g:ycm_use_ultisnips_completer = 1
let g:ycm_filepath_completion_use_working_dir = 0
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_always_populate_location_list = 0
let g:ycm_key_invoke_completion = ''
let g:ycm_python_binary_path = 'python'
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif

let g:ycm_global_ycm_extra_conf = expand('$VIMFILES/ycm_extra_conf.py')

ca yc YcmCompleter

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
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> gd :YcmCompleter GoTo<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> <leader>jt :YcmCompleter GoToDefinition<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> <leader>jD :YcmCompleter GetDoc<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> gD :YcmCompleter GetDoc<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> <leader>jf :YcmCompleter GoToInclude<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> gf :YcmCompleter GoToInclude<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> <leader>jI :YcmCompleter GoToImplementation<CR>
  autocmd FileType c,cpp,objc,objcpp,python,go nmap <buffer> <leader>jr :YcmCompleter GoToReferences<CR>
augroup END

let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}

if g:use_coc 
  let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'vim' : 1,
        \ 'notes' : 1,
        \ 'markdown' : 1,
        \ 'unite' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \ 'mail' : 1
        \}
endif

" multiple_cursors and YCM
function! Multiple_cursors_before()
    let g:ycm_auto_trigger = 0
endfunction

function! Multiple_cursors_after()
    let g:ycm_auto_trigger = 1
endfunction
