let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" let g:loaded_node_provider = 0
let g:node_host_prog = '/usr/local/bin/neovim-node-host'

" let g:loaded_python3_provider = 0
let g:python3_host_prog = expand('~/.pyenv/versions/3.10.2/bin/python3.10')
let g:node_path = '/usr/local/bin/node'

" let g:cfg_install_missing_plugins=0

let g:copilot_node_command=g:node_path
let g:copilot_proxy = '127.0.0.1:1083'
let g:copilot_proxy_strict_ssl = v:false

" let g:codeium_manual = 1
let g:codeium_filetypes = {
      \ 'markdown': v:false,
      \ }

let g:notes_dir = '/Volumes/dev/notes'

" HACK: work around bad detection of background in Tmux (no OSC11 support)
" https://github.com/neovim/neovim/issues/17070
if $TERM_PROGRAM == "tmux"
  lua vim.loop.fs_write(2, "\27Ptmux;\27\27]11;?\7\27\\", -1, nil)
endif

if exists('+termguicolors')
  set termguicolors
endif

" enable plugins
let g:enabled_plugins = {"telescope": 1, "fzf.vim": 1, "node": 0, "go": 0, "rust": 0, "python": 0, "nvim-treesitter": 0, "test": 0}

if $NVIM_APP == ""
  let $NVIM_APP = "lazy" " lazy, minimal, basic
endif

let b:init = globpath("~/vimgit/vim/",  $NVIM_APP . ".*")
if b:init != ""
  execute "source ". b:init
else
  echo "profile " . $NVIM_APP . " not found!"
endif

if !exists("g:colors_name") || g:colors_name == ""
" colorscheme material
  silent! colorscheme catppuccin
  " silent! colorscheme onedark
" colorscheme kanagawa
endif
