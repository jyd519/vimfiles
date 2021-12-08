map <buffer> ,r  :Cruntarget<cr>

command! -nargs=0 Run :Cruntarget
command! -nargs=0 Test :RustTest

" Config QuickRun
let g:quickrun_config = {}
let g:quickrun_config.rust = { 'runner': 'vimscript',  'command': ':Cruntarget', 'exec': '%C' }

