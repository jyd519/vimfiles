if exists('did_myts_vim') || &cp || version < 700
  finish
endif

autocmd FileType typescript nmap <buffer> <LocalLeader><C-]> :YcmCompleter GoToDefinition<CR>
autocmd FileType typescript nmap <buffer> <leader>jd :YcmCompleter GetDoc<CR>
autocmd FileType typescript nmap <buffer> <leader>jf :YcmCompleter GoToInclude<CR>

autocmd BufWritePre *.ts :%s/\s\+$//e

let did_myts_vim = 1
