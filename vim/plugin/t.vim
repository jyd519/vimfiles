" mysnippets template
" Author: jyd119@qq.com
"
" Load and save template codes
"   T  <name>  load snippet <name>
"   TS <name>  save selection as <name> 
if has('nvim') || exists('g:loaded_t_vim')
  finish
endif

let g:loaded_t_vim = 1

if (!exists('g:mysnippets_dir'))
  echom "Error: T.vim requires g:mysnippets_dir"
  finish
endif

fun! s:snippet_files(A,L,P)
  let pattern = a:A
  let snippets_dir= g:mysnippets_dir
  let base_dir = snippets_dir
  if &ft != "" && isdirectory(snippets_dir . "/" . &ft)
    let base_dir = snippets_dir . "/" . &ft
  endif

  if empty(pattern)
    let pattern = "**/*"
  elseif stridx(pattern, "*") == -1
    let pattern .= "*"
  endif

  let files = split(globpath(expand(base_dir), pattern), "\n")
  let n = len(base_dir) + 1
  let files = map(files, 'v:val[n:]')
  return files
endfun

function! InsertTemplate(A)
  let snippets_dir= g:mysnippets_dir
  let fp = a:A
  let ext = fnamemodify(fp, ":e")
  if empty(ext)
    let ext = expand("%:e")
    let fp .= "." . ext
  endif

  let src = snippets_dir . '/' . fp
  if !filereadable(src)
    let src = snippets_dir . '/' . &ft . '/' . fp
  endif
  if filereadable(src)
    call execute("r " . src)
  endif
endfunc

function! SelText() abort
  try
    let a_save = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

fun! SaveTemplate(name)
  let name = a:name
  let base_dir = g:mysnippets_dir . '/' . &ft
  if !isdirectory(base_dir)
    call mkdir(base_dir, "p") 
  endif

  if stridx(name, '.') == -1
    let ext = expand("%:e")
    if !empty(ext)
      let name .= '.' . ext
    endif
  endif

  let text = SelText()
  let dst = base_dir . '/' . name
  call writefile(split(text, '\n'), dst, 'b')
endfun

command! -nargs=1 -range -complete=customlist,s:snippet_files TS call SaveTemplate(<q-args>)
command! -nargs=1 -bang -complete=customlist,s:snippet_files T call InsertTemplate(<q-args>)
