" ============================================================================
" File:        nextCS.vim
" Description: vim color theme selector
" Maintainer:  Javier Lopez <m@javier.io>
" License:     WTFPL -- look it up.
" ============================================================================

" Init {{{1
if exists("loaded_nextCS")
    finish
endif
let loaded_nextCS = 1

let s:save_cpo = &cpo
set cpo&vim

" Default configuration {{{1
if !exists('g:nextcs_dir') | let g:nextcs_dir= 'colors/' | endif

" Commands & Mappings {{{1
command! NextCS     call nextCS#Next()
command! PreviousCS call nextCS#Previous()

" nnoremap <unique> <script> <Plug>NextCS     :NextCS<CR>
" nnoremap <unique> <script> <Plug>PreviousCS :PreviousCS<CR>

let &cpo = s:save_cpo
