" Jyd
if exists('b:did_markdown_vim')
  finish
endif

let b:did_markdown_vim = 1

"Markdown preview
function! PreviewMarkdown()
  execute ":silent !open -a \"Typora.app\" \"%:p\""
  execute ":redraw!"
endfunction

" Customizing surround 
let g:surround_{char2nr("*")} = "**\r**"
let g:surround_{char2nr("I")} = "_\r_"
let g:surround_{char2nr('c')}="```\r```"
let g:surround_{char2nr('C')}="```\1lang:\1\r```"

nmap <buffer> <LocalLeader>r :update<cr>:call PreviewMarkdown()<cr>

"Key Mapings
if has("mac")
  nmap <buffer> <LocalLeader>r :update<cr>:call PreviewMarkdown()<cr>
endif

nmap <buffer> <space> ysiw`

nmap <buffer> <LocalLeader>p :call mdip#MarkdownClipboardImage()<CR>
nmap <buffer> <LocalLeader>tf :TableFormat<cr>

nmap <buffer> <LocalLeader>1 :call setline('.', substitute(getline('.'), '^#* *', '# ', ''))<cr>
nmap <buffer> <LocalLeader>2 :call setline('.', substitute(getline('.'), '^#* *', '## ', ''))<cr>
nmap <buffer> <LocalLeader>3 :call setline('.', substitute(getline('.'), '^#* *', '### ', ''))<cr>
nmap <buffer> <LocalLeader>4 :call setline('.', substitute(getline('.'), '^#* *', '#### ', ''))<cr>
nmap <buffer> <LocalLeader>5 :call setline('.', substitute(getline('.'), '^#* *', '##### ', ''))<cr>
nmap <buffer> <LocalLeader>6 :call setline('.', substitute(getline('.'), '^#* *', '###### ', ''))<cr>

