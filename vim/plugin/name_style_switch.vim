" if exists('g:didNameStyleSwitchVim') || &cp || version < 700
"   finish
" endif
"
" let g:didNameStyleSwitchVim = 1

function! s:regexprs(target)
  if a:target ==# "camelCase"
    " Convert each nameLikeThis to nameLikeThis
    return ['_\([a-z]\)', '\u\1']
  elseif a:target ==# "CamelCase"
    " Convert each nameLikeThis to NameLikeThis
    return ['\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)', '\u\1\2']
  elseif a:target ==# "snake"
    " Convert each NameLikeThis to nameLikeThis
    return ['\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)', '\l\1_\l\2']
  else
    throw "unknown name style: " . a:target
  endif
endfunction

function! s:NameConvert(target) range
  let target = a:target
  if empty(target) 
    let target = getline('.') =~ '_' ? "CamelCase" : "snake"
  endif
  let re = s:regexprs(target)
  exec 'silent! %s#\%V' . re[0] . "#" . re[1] . '#g'
endfunction

function! s:nameStyles(A,L,P)
  return filter(['camelCase', 'CamelCase', 'snake'], 'v:val =~ "\\C^'. a:A . '"')
endfunction

command! -nargs=? -range -complete=customlist,s:nameStyles NameConvert :call <SID>NameConvert(<q-args>)
