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

"
" {map} {options} {lhs}  {rhs}
"
" map! 在insert模式和command line 模式下有效
map! <F2> <C-R>=strftime('%c')<CR>

" Commands                        Mode
" --------                        ----
" nmap, nnoremap, nunmap          Normal mode
" imap, inoremap, iunmap          Insert and Replace mode
" vmap, vnoremap, vunmap          Visual and Select mode
" xmap, xnoremap, xunmap          Visual mode
" smap, snoremap, sunmap          Select mode
" cmap, cnoremap, cunmap          Command-line mode
" omap, onoremap, ounmap          Operator pending mode


" range 后缀表示该函数能够处理多行:  [a:firstline，a:lastline]
function! s:clearLineBreak() range
  let m = visualmode()  " 不同的可视模式
  if m ==# 'V'
    for line in range(a:firstline, a:lastline)
      call setline(line, substitute(getline(line), ' *$', '', ''))
    endfor
  endif
endfunction
"
" command定义一个新命令
"    -range=% <line1>,<line2> 把选中的行范围传递给函数
"    结尾不需要<cr>
command! -nargs=0 -range=% Mnobr :<line1>,<line2>call s:clearLineBreak()



vnoremap <silent> <F5> :<C-U>call MyFunc()<CR>
function! MyFunc()
   " normal! gv  " 从command模式恢复到visual模式
    let m = visualmode()
    if m ==# 'v'  "大小写敏感比较
        echo 'character-wise visual'
    elseif m == 'V'
        echo 'line-wise visual'
    elseif m == "\<C-V>"
        echo 'block-wise visual'
    endif
endfunction


cnoremap <F8> <C-R>=MyFunc2()<CR>
function! MyFunc2()
    let cmdtype = getcmdtype()
    echo '>>>' . cmdtype
    if cmdtype == ':'
        " Perform Ex command map action
    elseif cmdtype == '/' || cmdtype == '?'
        " Perform search prompt map action
    elseif cmdtype == '@'
        " Perform input() prompt map action
    else
        " Perform other command-line prompt action
    endif
endfunction

" slient 表示不显示命令，但显示命令本身输出的消息
nnoremap <silent> <F2> :lchdir %:p:h<CR>:pwd<CR>

function! Something(key, value, ...)
   echo a:key . ": " . a:value . " > " . a:0
   echo "[ " . join(a:000, ",") . " ]"
   echo "count: ". get(a:, 0)
   for arg in a:000
     echo " arg: " . arg
   endfor
endfunction
call Something("a", "b", "c", "d")

" <bang>0: transform the bang to boolean
" q-args: 扩展为用户输入的参数（以字符串形式）， 没有参数时扩展为''
command! -range -bang -nargs=* MY echo [<bang>0, <line1>, <line2>, <count>, <q-args>]
