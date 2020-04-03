if exists('did_gpg_enc_vim') || &cp || version < 700
  finish
endif

let did_gpg_enc_vim = 1

function! GpgDec() range
  if a:lastline != a:firstline
    call GpgDecAll()
    return
  endif

  let cur = line('.')
  let b = cur
  let e = cur
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
  execute(b . ',' . e . '!gpg -da')
endfunction
 
function! GpgDecAll() 
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
         silent! execute(b . ',' . e . '!gpg -da')
      endif
    endif
    let i += 1
  endwhile
endfunction

function! GpgEnc() range
  silent! execute(a:firstline . ',' . a:lastline . '!gpg -ca')
endfunction

command! -nargs=0 -range GpgEnc <line1>,<line2>call GpgEnc() 
command! -nargs=0 -range GpgDec <line1>,<line2>call GpgDec() 
