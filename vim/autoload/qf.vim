function! qf#ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix')) && !empty(getqflist())
        copen
    else
        cclose
    endif
endfunction

function! qf#ToggleLocationList()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        silent! lopen
    else
        silent! lclose
    endif
endfunction
