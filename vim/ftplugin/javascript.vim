function! ConvertToFunction(line)
  if getline(a:line) =~ '\v^\s*(\w+):\s*function\s*\(.*$'
    let new = substitute(getline(a:line), '\v^\s*(\w+):\s*function(.+)$', 'export function \1\2', '')
    call setline(a:line, new)
    return
  endif
  if getline(a:line) =~ '\v^\s*\w+\(.*$'
    let new = substitute(getline(a:line), '\v^\s*(\w+)(.+)$', 'export function \1\2', '')
    call setline(a:line, new)
    return
  endif
endfunction

function! ToFreeFunction() range
  let m = visualmode()
  if m ==# 'V'
    for line in range(a:firstline, a:lastline)
      call ConvertToFunction(line)
    endfor
  endif
endfunction

command! -nargs=0 -buffer -range=% Mf :<line1>,<line2>call ToFreeFunction()

" dap
command! -buffer DebugTest lua require("myrc.config.dap-jest").debug()
