if exists('g:did_aes_enc_vim') || &cp || version < 700
  finish
endif
let g:did_aes_enc_vim = 1

" Regular expressions for identifying the start and end of an AES-VIM block
let g:aes_input_passphrase = 0
let g:vim_aes_js = expand('<sfile>:p:h:h') . '/tools/aes-vim.js'

let s:mark_begin_re = '^\s*```AES-VIM'
let s:mark_end_re = '^\s*``` *$'

function! AesDec(...) range
  let passphrase = a:0 > 0 ? a:1 : ""
  if empty(passphrase) && g:aes_input_passphrase
    let passphrase = inputsecret("Passphrase: ")
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
endfunction

function! AesDecAll(extra)
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
        let cmd = '!node ' . g:vim_aes_js  . ' -d ' . a:extra
        silent! execute(start_line . ',' . end_line . cmd)
        let found = 1
        let n = n + 1
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

function! AesEnc(...) range
  let passphrase = a:0 > 0 ? a:1 : 'jyd.vim'
  let cmd = '!node ' . g:vim_aes_js  . ' -p ' . passphrase
  silent! execute(a:firstline . ',' . a:lastline . cmd)
endfunction

command! -nargs=* -range AesEnc <line1>,<line2>call AesEnc(<f-args>)
command! -nargs=? -range AesDec <line1>,<line2>call AesDec(<f-args>)
command! -nargs=? -range AesDecAll 0,$call AesDec(<f-args>)
