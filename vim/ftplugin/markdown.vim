" Jyd
" https://dev.to/iggredible/learning-vim-regex-26ep
if exists('b:did_markdown_vim')
  finish
endif

let b:did_markdown_vim = 1

" adjust syntax highlighting
function! s:adjustSyntax()
  " hi link mkdLineBreak  CursorLineNr
  " https://github.com/preservim/vim-markdown/blob/master/syntax/markdown.vim
  syn clear markdownUrl
  syn match markdownUrl /https\?:\/\/[^ \t]*/ nextgroup=markdownUrlTitle skipwhite contained
  syn match  mkdLineBreak    /  \+$/
  syn match  mkdListItem     /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ nextgroup=markdownUrl
  syn region mkdListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" contains=markdownCode,markdownLinkText,markdownListMarker,markdownUrl
  syn region mkdBlockquote   start=/^\s*>/                   end=/$/ contains=mkdLineBreak

  hi link mkdLineBreak Underlined
  hi link mkdBlockquote Comment
  " hi! mkdListItem gui=bold guifg=#0451a5
  " hi! markdownH0 guifg=#0451a5 gui=bold
  " hi! markdownH2 guifg=#0451a5 gui=bold
  " hi! markdownH3 guifg=#0451a5 gui=bold
  " hi! markdownH1Delimiter guifg=#0451a5 gui=bold
  " hi! markdownH2Delimiter guifg=#0451a5 gui=bold
  " hi! markdownH3Delimiter guifg=#0451a5 gui=bold
  hi! link markdownUrl htmlLink
endfunction

augroup mdSyntaxAdjust
    autocmd!
    autocmd BufWinEnter <buffer> call s:adjustSyntax()
augroup end

" folding
" setlocal foldlevel=1
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

set textwidth=120

"Markdown preview
function! PreviewMarkdown()
  execute ":silent !open -a \"Typora.app\" \"%:p\""
  execute ":redraw!"
endfunction

" Preview markdown as mindmap
function! PreviewMindmap()
  let b:job = jobstart("markmap -w " . expand("%:p"), { "detach": 1})
endfunction


function! TableFormat()
    let l:pos = getpos('.')
    normal! {
    " Search instead of `normal! j` because of the table at beginning of file edge case.
    call search('|')
    normal! j
    " Remove everything that is not a pipe, colon or hyphen next to a colon othewise
    " well formated tables would grow because of addition of 2 spaces on the separator
    " line by Tabularize /|.
    let l:flags = (&gdefault ? '' : 'g')
    execute 's/\(:\@<!-:\@!\|[^|:-]\)//e' . l:flags
    execute 's/--/-/e' . l:flags
    Tabularize /\(\\\)\@<!|
    " Move colons for alignment to left or right side of the cell.
    execute 's/:\( \+\)|/\1:|/e' . l:flags
    execute 's/|\( \+\):/|:\1/e' . l:flags
    execute 's/|:\?\zs[ -]\+\ze:\?|/\=repeat("-", len(submatch(0)))/' . l:flags
    call setpos('.', l:pos)
endfunction

" Customizing surround
let g:surround_{char2nr("*")} = "**\r**"
let g:surround_{char2nr("I")} = "_\r_"
let g:surround_{char2nr('c')}="```\r```"
let g:surround_{char2nr('L')}="```\r```"
let g:surround_{char2nr('l')}="```\1lang:\1\r```"
if g:is_nvim
  lua  <<END
require("nvim-surround").buffer_setup(
    {
        surrounds = {
            ["*"] = {
                add = function()
                    return {{'**'}, {'**'}}
                end
            },
            ["I"] = {
                add = function()
                    return {{'_'}, {'_'}}
                end
            },
            ["c"] = {
                add = function()
                    return {{'`'}, {'`'}}
                end
            },
            ["l"] = {
                add = function()
                  local config = require("nvim-surround.config")
                  local result = config.get_input("Enter the language name: ")
                  if result then
                      return { { "```" .. result }, { "```" } }
                  end
                end
            }
        }
    }
)
END
endif

nmap <buffer> <LocalLeader>m :update<cr>:call PreviewMindmap()<cr>

"Key Mapings
if has("mac")
  nmap <buffer> <LocalLeader>r :update<cr>:call PreviewMarkdown()<cr>
endif

nmap <buffer> <space><space> ysiw`

nmap <buffer> <LocalLeader>p :call mdip#MarkdownClipboardImage()<CR>
nmap <buffer> <LocalLeader>tf :call TableFormat()<cr>

nmap <buffer> <LocalLeader>1 :call setline('.', substitute(getline('.'), '^#* *', '# ', ''))<cr>
nmap <buffer> <LocalLeader>2 :call setline('.', substitute(getline('.'), '^#* *', '## ', ''))<cr>
nmap <buffer> <LocalLeader>3 :call setline('.', substitute(getline('.'), '^#* *', '### ', ''))<cr>
nmap <buffer> <LocalLeader>4 :call setline('.', substitute(getline('.'), '^#* *', '#### ', ''))<cr>
nmap <buffer> <LocalLeader>5 :call setline('.', substitute(getline('.'), '^#* *', '##### ', ''))<cr>
nmap <buffer> <LocalLeader>6 :call setline('.', substitute(getline('.'), '^#* *', '###### ', ''))<cr>


function! AddLineBreak() range
    let m = visualmode()
    if m ==# 'v'
        echo 'character-wise visual'
    elseif m == 'V'
        for line in range(a:firstline, a:lastline)
          call setline(line, substitute(getline(line), ' *$', '  ', ''))
        endfor
    elseif m == "\<C-V>"
        echo 'block-wise visual'
    endif
endfunction

command! -nargs=0 -range=% Mbr :<line1>,<line2>call AddLineBreak()

function! ToUnorderList() range
  let m = visualmode()
  if m ==# 'V'
    for line in range(a:firstline, a:lastline)
      if getline(line) !~ '^ *$'
        call setline(line, '+ ' . getline(line))
      endif
    endfor
  endif
endfunction

command! -nargs=0 -range=% Ml :<line1>,<line2>call ToUnorderList()

function! ToOrderList() range
  let m = visualmode()
  if m ==# 'V'
    let i = 1
    for line in range(a:firstline, a:lastline)
      call setline(line, i . '. ' . getline(line))
      let i+=1
    endfor
  endif
endfunction
command! -nargs=0 -range=% Mol :<line1>,<line2>call ToOrderList()

function! s:clearLineBreak() range
  let m = visualmode()
  if m ==# 'V'
    for line in range(a:firstline, a:lastline)
      call setline(line, substitute(getline(line), ' *$', '', ''))
    endfor
  endif
endfunction

command! -nargs=0 -range=% Mnobr :<line1>,<line2>call s:clearLineBreak()

" replace image to <img> tag
function! s:toImg() range
  for line in range(a:firstline, a:lastline)
    let text = getline(line)
    if text =~ '([^)]*)'
      call setline(line, substitute(text, '\[\([^\]]*\)\](\([^)]*\))', '<img src="\2" style="zoom: 0.5" />', ''))
    endif
  endfor
endfunction
command! -nargs=0 -range Img :<line1>,<line2>call s:toImg()
nmap <buffer> <LocalLeader>i :Img<cr>

" to link
function! s:toLink() range
  for line in range(a:firstline, a:lastline)
    let text = getline(line)
    if text =~ 'http*'
      " .{-}  <== non greedy match
      " call setline(line, substitute(text, '\v(\+|\-)?\s*(.{-})\s*(http.*)', '\1 [\2](\3)', ''))
      " or
      call setline(line, substitute(text, '\v(\+|\-)?\s*(.*)(http.*)', '\=submatch(1) . " [" . trim(submatch(2)) . "](" . submatch(3) .")"', ''))
    endif
  endfor
endfunction
command! -nargs=0 -range Link :<line1>,<line2>call s:toLink()
nmap <buffer> <LocalLeader>l :Link<cr>
vmap <buffer> <LocalLeader>l :'<,'>Link<cr>

" publish markdown
function! PubDoc(...)
  let args = join(a:000, " ")
  echo system('pubdoc ' . args . " ". expand('%') )
endfunction
command! -buffer -nargs=* PubDoc call PubDoc(<q-args>)
