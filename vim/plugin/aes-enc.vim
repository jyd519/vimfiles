if exists('g:did_aes_enc_vim') || &cp || version < 700
  finish
endif

let g:did_aes_enc_vim = 1

" Regular expressions for identifying the start and end of an AES-VIM block
let g:aes_input_passphrase = 1
let g:vim_aes_js = expand('<sfile>:p:h:h') . '/tools/aes-vim.js'
if !exists("g:vim_aes_key")
  let g:vim_aes_key = 'Jyd'
endif

let s:mark_begin_re = '\v^\s*(```AES-VIM)|( *-+BEGIN VIM ENCRYPTED-+)'
let s:mark_end_re = '\v^\s*(``` *)|( *-+END VIM ENCRYPTED-+)$'

function! s:getAllAesBlock()
  let blocks = []
  let start_line = 0
  for i in range(1, line('$'))
    if getline(i) =~ s:mark_begin_re
      let start_line = i
    elseif getline(i) =~ s:mark_end_re && start_line > 0
      let end_line = i
      let blocks += [[start_line, end_line]]
      let start_line = 0
    endif
    let i += 1
  endfor
  return blocks
endfunction


function! s:inCryptBlock(start, end)
  let blocks = s:getAllAesBlock()
  for block in blocks
    if a:start >= block[0] && a:end <= block[1]
      return 1
    endif
  endfor
  return 0
endfunction

function! AesDec(...) range
  if !s:inCryptBlock(a:firstline, a:lastline)
    echom "No cipher found"
    return
  endif

  let passphrase = a:0 > 0 ? a:1 : ""
  if empty(passphrase) && g:aes_input_passphrase
    let passphrase = trim(inputsecret("Passphrase: "))
  endif
  let extra = empty(passphrase) ? "-p jyd.vim " : "-p " . passphrase
  let cmd = '!node ' . g:vim_aes_js  . ' -d ' . extra

  if a:lastline != a:firstline
    silent! execute a:firstline . ',' . a:lastline . cmd
    return
  endif

  let [start_line, end_line] = [line('.'), line('.')]
  while start_line >= 1 && getline(start_line) !~# s:mark_begin_re
    let start_line -= 1
  endwhile

  if getline(start_line) !~# s:mark_begin_re
    return
  endif

  while end_line >= 1 && getline(end_line) !~# s:mark_end_re
    let end_line += 1
  endwhile

  if getline(end_line) !~# s:mark_end_re
    return
  endif

  silent! execute(start_line . ',' . end_line . cmd)
  if v:shell_error
    undo
    echom "Decryption failed: " . start_line . ',' . end_line
  endif
endfunction

function! AesDecAll()
  let passphrase = trim(inputsecret("Passphrase: "))
  if empty(passphrase)
    let passphrase = 'jyd.vim'
  endif
  let n = 0
  while 1
    let found = 0
    let i = 1
    let start_line = 1
    let end_line = 1
    for i in range(1, line('$'))
      if getline(i) =~ s:mark_begin_re
        let start_line = i
      elseif getline(i) =~ s:mark_end_re && start_line > 0
        let end_line = i
        let cmd = '!node ' . g:vim_aes_js  . ' -d -p ' . passphrase
        silent! execute(start_line . ',' . end_line . cmd)
        if v:shell_error
          undo
          echom "Decryption failed: " . start_line . ',' . end_line
          return
        endif
        let found = 1
        let n = n + 1
        let i += 1
        break
      endif
      let i += 1
    endfor
    if !found
      break
    endif
  endwhile
  if  n > 0
    echom "Decrypted " . n . " block(s)"
  endif
endfunction

function! AesEnc(r, ...) range
  if a:r == 0
    echom "No range specified"
    return
  endif

  if s:inCryptBlock(a:firstline, a:lastline)
    echom "Already encrypted"
    return
  endif

  let passphrase = a:0 > 0 ? a:1 : ""
  if empty(passphrase)
    let passphrase = trim(inputsecret("Passphrase: "))
  endif
  if empty(passphrase)
    let passphrase = 'jyd.vim'
  endif
  let cmd = '!node ' . g:vim_aes_js  . ' -p ' . passphrase
  silent! execute(a:firstline . ',' . a:lastline . cmd)
endfunction

command! -nargs=* -range AesEnc <line1>,<line2>call AesEnc(<range>, <f-args>)
command! -nargs=? -range AesDec <line1>,<line2>call AesDec(<f-args>)
command! -nargs=? -range AesDecAll call AesDecAll(<f-args>)
