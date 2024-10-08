function! Infect(...)
  echo a:0
  " => 2
  echo a:1
  " => jake
  echo a:2
  " => bella

  for s in a:000  " a list
    echon ' ' . s
  endfor
endfunction

function! GetVis()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    echom join(lines, "\n")
    " return join(lines, "\n")
endfunction

call Infect('jake', 'bella')
