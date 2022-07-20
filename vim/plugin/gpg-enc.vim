if exists('did_gpg_enc_vim') || &cp || version < 700
  finish
endif
let did_gpg_enc_vim = 1

let g:gpg_input_passphrase = 0

if !exists("g:gpg_recipient") 
  let g:gpg_recipient = 'jyd119@163.com'
endif

function! GpgDec(...) range
  let passphrase = a:0 > 0 ? a:1 : ""
  if empty(passphrase) && g:gpg_input_passphrase
    let passphrase = inputsecret("Passphrase: ")
  endif
  let extra = ""
  if empty(passphrase)
    let extra .= '-r "' . g:gpg_recipient . '"'
  else
    let extra .= "--batch --passphrase " . passphrase
  endif
  if a:lastline != a:firstline
    call GpgDecAll(extra)
    return
  endif

  let cur = line('.')
  let [b, e] = [cur, cur]
  while b >= 1 
    if getline(b) =~ '^ *-----BEGIN PGP MESSAGE'
      break
    endif
    let b -= 1
  endwhile

  if getline(b) !~ '^ *-----BEGIN PGP MESSAGE'
    return 
  endif

  while e >= 1 
    if getline(e) =~ '^ *-----END PGP MESSAGE'
      break
    endif
    let e += 1
  endwhile

  if getline(e) !~ '^ *-----END PGP MESSAGE'
    return 
  endif

  silent!  execute(b . ',' . e . '!gpg -da ' . extra . ' 2>/dev/null')
endfunction
 
function! GpgDecAll(extra) 
  let i = 1 
  let b = i 
  let e = i 
  let n = 1
  while i <= line('$') 
    if getline(i) =~ '^ *-----BEGIN PGP MESSAGE'
      let b = i
    elseif getline(i) =~ '^ *-----END PGP MESSAGE'
      let e = i
      if e > b 
         silent! execute(b . ',' . e . '!gpg -da ' . a:extra . ' 2>/dev/null')
      endif
    endif
    let i += 1
  endwhile
endfunction

function! GpgEnc(...) range
  let extra = '--batch -r "' . g:gpg_recipient . '"'
  echom '!gpg -ea ' . extra
  silent! execute(a:firstline . ',' . a:lastline . '!gpg -ea ' . extra)
endfunction

command! -nargs=* -range GpgEnc <line1>,<line2>call GpgEnc(<f-args>) 
command! -nargs=? -range GpgDec <line1>,<line2>call GpgDec(<f-args>) 
