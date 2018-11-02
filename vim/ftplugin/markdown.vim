" Jyd

if exists('did_markdown_vim') || &cp || version < 700
  finish
endif

"Markdown preview
function! PreviewMarkdown()
  execute ":silent !open -a \"Typora.app\" \"%:p\""
  execute ":redraw!"
endfunction

"Key Mapings
if has("mac")
  autocmd FileType markdown nmap <buffer> <LocalLeader>r :update<cr>:call PreviewMarkdown()<cr>
endif

autocmd FileType markdown nmap <buffer> <space> ysiw`

" Customizing surround 
let g:surround_{char2nr("*")} = "**\r**"
let g:surround_{char2nr("I")} = "_\r_"

autocmd FileType markdown nmap <buffer> <LocalLeader>tf :TableFormat<cr>

autocmd FileType markdown nmap <buffer> <LocalLeader>1 :call setline('.', substitute(getline('.'), '^#* *', '# ', ''))<cr>
autocmd FileType markdown nmap <buffer> <LocalLeader>2 :call setline('.', substitute(getline('.'), '^#* *', '## ', ''))<cr>
autocmd FileType markdown nmap <buffer> <LocalLeader>3 :call setline('.', substitute(getline('.'), '^#* *', '### ', ''))<cr>
autocmd FileType markdown nmap <buffer> <LocalLeader>4 :call setline('.', substitute(getline('.'), '^#* *', '#### ', ''))<cr>
autocmd FileType markdown nmap <buffer> <LocalLeader>5 :call setline('.', substitute(getline('.'), '^#* *', '##### ', ''))<cr>
autocmd FileType markdown nmap <buffer> <LocalLeader>6 :call setline('.', substitute(getline('.'), '^#* *', '###### ', ''))<cr>

let did_markdown_vim = 1
