" if exists('did_aes_enc_vim') || &cp || version < 700
"   finish
" endif
let did_aes_enc_vim = 1

let g:aes_input_passphrase = 0
let g:vim_aes_js = expand('<sfile>:p:h:h') . '/tools/aes-vim.js'

let s:mark_begin_re = '^ *```AES-VIM'
let s:mark_end_re = '^ *``` *$'

function! AesDec(...) range
  let passphrase = a:0 > 0 ? a:1 : ""
  if empty(passphrase) && g:aes_input_passphrase
    let passphrase = inputsecret("Passphrase: ")
  endif
  let extra = ""
  if empty(passphrase)
    let extra .= '-p jyd.vim '
  else
    let extra .= "-p " . passphrase
  endif

  if a:lastline != a:firstline
    call AesDecAll(extra)
    return
  endif

  let cur = line('.')
  let [b, e] = [cur, cur]
  while b >= 1
    if getline(b) =~ s:mark_begin_re
      break
    endif
    let b -= 1
  endwhile

  if getline(b) !~ s:mark_begin_re
    return
  endif

  while e >= 1
    if getline(e) =~ s:mark_end_re
      break
    endif
    let e += 1
  endwhile

  if getline(e) !~ s:mark_end_re
    return
  endif

  let cmd = '!node ' . g:vim_aes_js  . ' -d ' . extra
  silent! execute(b . ',' . e . cmd)
endfunction

function! AesDecAll(extra)
  let found = 1
  let n = 0
  while found > 0
    let found = 0
    let i = 1
    let b = 1
    let e = 1
    while i <= line('$')
      if getline(i) =~ s:mark_begin_re
        let b = i
      elseif getline(i) =~ s:mark_end_re
        let e = i
        if e > b
          let cmd = '!node ' . g:vim_aes_js  . ' -d ' . a:extra
          silent! execute(b . ',' . e . cmd)
          let found = 1
          let n = n + 1
          break
        endif
      endif
      let i += 1
    endwhile
  endwhile
  if  n > 0
    echom "Decrypted " . n
  endif
endfunction

function! AesEnc(...) range
  let passphrase = a:0>0? a:1 : ""
  if empty(passphrase )
    let passphrase = 'jyd.vim'
  endif
  let cmd = '!node ' . g:vim_aes_js  . ' -p ' . passphrase
  silent! execute(a:firstline . ',' . a:lastline . cmd)
endfunction

command! -nargs=* -range AesEnc <line1>,<line2>call AesEnc(<f-args>)
command! -nargs=? -range AesDec <line1>,<line2>call AesDec(<f-args>)
command! -nargs=? -range AesDecAll 0,$call AesDec(<f-args>)
