function! SearchTodayDate()
    let today = strftime("%Y-%m-%d")
    let @/ = "^.\\?" . today
    try
        silent execute "normal! n"
    catch /E486:/
        echo "(" . today . ") not found in the file."
    endtry
endfunction


nnoremap <buffer> <leader>d :call SearchTodayDate()<CR>
