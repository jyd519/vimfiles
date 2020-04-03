" range 后缀表示该函数能够处理多行:  [firstline，lastline] 
" 如果没有range后缀，则 Ta会被调用多次，line('.') 返回对应对行号
function! Ta(mode) range
  if a:mode ==# "v"
    let c1 = col("'<'")-1
    let c2 = col("'>'") -1 
    let lines = getline(a:firstline, a:lastline)
    let lines[-1] = lines[-1][:c2]
    let lines[0] = lines[0][c1:]
    echo " v:" .  join(lines, ';') 
  elseif a:mode ==# "V"
    echo " V:" . join(getline(a:firstline, a:lastline), '=')
  elseif a:mode==# ""
    let c1 = col("'<'")-1
    let c2 = col("'>'") -1 
    let lines = [] 
    for line in getline(a:firstline, a:lastline)
      call add(lines, line[c1 : c2]) 
    endfor
    echo " ^V:" . join(lines , '#####')
  else
    echo "Unknow: " . a:mode
  endif

  " echom mode() . " - " a:mode . " " . a:firstline. " , " . a:lastline . "   : current " . line('.') . getline('<') . " " . column_start . ":" . column_end
endfunction

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

command! -nargs=0 -range=% AA :<line1>,<line2>call Ta(visualmode())
command! -nargs=0 -range AB :<line1>,<line2>call Ta(visualmode())

nnoremap ,aa :call Ta('n')<esc>
vnoremap ,aa :call Ta(visualmode())<esc>
