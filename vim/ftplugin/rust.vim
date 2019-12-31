if exists('did_rust_vim') || &cp || version < 700
  finish
endif
let did_rust_vim = 1

" Rust
let g:racer_cmd = '~/.cargo/bin/racer'
let g:racer_experimental_completer = 1
let g:rustfmt_autosave = 1

nmap <buffer> gd <Plug>(rust-def)
nmap <buffer> gs <Plug>(rust-def-split)
nmap <buffer> gx <Plug>(rust-def-vertical)
nmap <buffer> gD <Plug>(rust-doc)


