if exists('g:did_name_style_switch_vim') || &cp || version < 700
  finish
endif

let g:did_name_style_switch_vim = 1

" Convert each name_like_this to nameLikeThis
function! s:convert_to_camelCase(  )
  let new = substitute(expand('<cword>'), '_\([a-z]\)', '\u\1', 'g')
  exec "norm ciw" . new . "\<esc>"
endfunction

" Convert each name_like_this to NameLikeThis
function! s:convert_to_CamelCase(  )
  let new = substitute(expand('<cword>'), '\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2', 'g')
  exec "norm ciw" . new . "\<esc>"
endfunction

" Convert each NameLikeThis to name_like_this
function! s:convert_to_snake(  )
  let new = substitute(expand('<cword>'), '\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)', '\l\1_\l\2', 'g')
  exec "norm ciw" . new . "\<esc>"
endfunction


function! s:NameConvert(name)
  if empty(a:name)
    let w = expand('<cword>')
    if w =~ '_'
      call s:convert_to_CamelCase()
    else
      call s:convert_to_snake()
    endif
  endif

  if a:name ==# "camelCase"
    call s:convert_to_camelCase()
  elseif a:name ==# "CamelCase"
    call s:convert_to_CamelCase()
  elseif a:name ==# "snake"
    call s:convert_to_snake()
  endif
endfunction

function! s:name_styles(A,L,P)
    return filter(['camelCase', 'CameCase', 'snake'], 'v:val =~ "\\C^'. a:A . '"')
endfunction

command! -nargs=? -complete=customlist,s:name_styles NameConvert :call s:NameConvert(<q-args>)
