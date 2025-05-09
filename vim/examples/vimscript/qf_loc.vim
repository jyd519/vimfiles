" wrap :cnext/:cprevious and :lnext/:lprevious
function! WrapCommand(direction, prefix)
    if a:direction == "up"
        try
            execute a:prefix . "previous"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "last"
        catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
        endtry
    elseif a:direction == "down"
        try
            execute a:prefix . "next"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "first"
        catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
        endtry
    endif
endfunction

" <Home> and <End> go up and down the quickfix list and wrap around
nnoremap <silent> <Home> :call WrapCommand('up', 'c')<CR>
nnoremap <silent> <End>  :call WrapCommand('down', 'c')<CR>

" <C-Home> and <C-End> go up and down the location list and wrap around
nnoremap <silent> <C-Home> :call WrapCommand('up', 'l')<CR>
nnoremap <silent> <C-End>  :call WrapCommand('down', 'l')<CR>

" nnoremap <silent> <left> :call WrapCommand('up', 'c')<CR>
" nnoremap <silent> <right>  :call WrapCommand('down', 'c')<CR>
" nnoremap <silent> <S-left> :call WrapCommand('up', 'l')<CR>
" nnoremap <silent> <S-right>  :call WrapCommand('down', 'l')<CR>

