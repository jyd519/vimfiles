augroup coc_config
  autocmd!
  autocmd BufRead,BufNewFile * call s:init_coc() 
augroup END 

function! s:init_coc()
  " if index(g:filetype_use_ycm, &filetype) >= 0
  "   :CocDisable
  "   return
  " endif
  "
  " :CocEnable
  " echomsg "Using COC"

  if index(['typescript', 'json'], &filetype) >= 0
    setlocal formatexpr=CocAction('formatSelected')
  endif

  " Use K to show documentation in preview window
  nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <buffer> <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <buffer> <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Or use `complete_info` if your vim support it, like:
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  nmap <buffer> <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <buffer> <silent> ]g <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <buffer> <silent> gd <Plug>(coc-definition)
  nmap <buffer> <silent> gy <Plug>(coc-type-definition)
  nmap <buffer> <silent> gi <Plug>(coc-implementation)
  nmap <buffer> <silent> gr <Plug>(coc-references)

  " Remap for rename current word
  nmap <buffer> <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <buffer> <leader>fs  <Plug>(coc-format-selected)
  nmap <buffer> <leader>fs  <Plug>(coc-format-selected)

  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder <buffer> call CocActionAsync('showSignatureHelp')
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold <buffer> silent call CocActionAsync('highlight')

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <buffer> <leader>a  <Plug>(coc-codeaction-selected)
  nmap <buffer> <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <buffer> <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <buffer> <leader>qf  <Plug>(coc-fix-current)

  " Create mappings for function text object, requires document symbols feature of languageserver.
  xmap <buffer> if <Plug>(coc-funcobj-i)
  xmap <buffer> af <Plug>(coc-funcobj-a)
  omap <buffer> if <Plug>(coc-funcobj-i)
  omap <buffer> af <Plug>(coc-funcobj-a)

  " Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  " conflict with +jumplist shortcut 
  " nmap <buffer> <silent> <TAB> <Plug>(coc-range-select)
  xmap <buffer> <silent> <TAB> <Plug>(coc-range-select)

  " Use `:Format` to format current buffer
  command! -buffer -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -buffer -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -buffer -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  " setlocal statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <buffer><silent><nowait> <leader>ca  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <buffer><silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <buffer><silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <buffer><silent><nowait> <leader>co  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  " nnoremap <buffer><silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <buffer><silent><nowait> <leader>cj  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <buffer><silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <buffer><silent><nowait> <leader>cp  :<C-u>CocListResume<CR>

    " coc-jest
  " Run jest for current project
  command! -buffer -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

  " Run jest for current file
  command! -buffer -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])

  " Run jest for current test
  nnoremap <buffer><leader>te :call CocAction('runCommand', 'jest.singleTest')<CR>

  " Init jest in current cwd, require global jest command exists
  command! -buffer JestInit :call CocAction('runCommand', 'jest.init')

  " Coc-Prettier
  command! -buffer -nargs=0 Prettier :CocCommand prettier.formatFile
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    silent! execute 'h '.expand('<cword>')
    return
  endif

  call CocAction('doHover')
endfunction
