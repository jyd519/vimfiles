vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.modeline = true
vim.opt.wrap = false
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Only be case sensitive when search contains uppercase
vim.opt.hidden = true -- allow we leave from the current modified buffer
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.backupcopy = "yes"
vim.opt.showmatch = true
vim.opt.cmdheight = 2
vim.opt.history = 100
vim.opt.updatetime = 300 -- Smaller updatetime for CursorHold & CursorHoldI
vim.opt.shortmess:append "c" -- don't give |ins-completion-menu| messages.
vim.opt.signcolumn = "yes" -- always show signcolumns

if vim.o.foldmethod == "manual" then
  vim.opt.foldmethod = "indent"
end

vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "3"
vim.opt.scrolloff = 2
vim.opt.guioptions:remove "T"
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030"
vim.opt.wildmenu = true -- show a navigable menu for tab completion
vim.opt.wildmode = "list:longest,full"
vim.opt.wildignore:append "*/tmp/*,*.so,*.swp,*.zip" -- MacOSX/Linux
vim.opt.wildignore:append "*\\tmp\\*,*.swp,*.zip,*.exe" -- Windows
vim.opt.wildignore:append "*DS_Store,*.pyc"
vim.opt.completeopt = "menu,menuone,noselect,preview"
-- vim.opt.t_ti= vim.opt.t_te= Keep screen after vim exited
vim.opt.formatoptions:append "mM" -- Better CJK supports
vim.opt.clipboard:append "unnamed"

if vim.fn.has("balloon_eval") == 1 then
  vim.opt.ballooneval = true
  vim.opt.balloondelay = 100
end

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
  -- Correct RGB escape codes for vim inside tmux
  if not vim.fn.has("nvim") == 1 and vim.env.TERM == "screen-256color" then
    vim.opt.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
    vim.opt.t_8b = "<Esc>[48;2;%lu;%lu;%lum"
  end
end

vim.opt.path = ",,.,./include,/usr/local/include,/usr/include,$VIMFILES"

-- Default sh is Bash
vim.g.bash_is_sh = 1

-- Persistent undo
-- --------------------------------------------------------------------------------
vim.opt.undofile = true
if vim.fn.has("nvim") == 1 then
  vim.opt.undodir = vim.fn.expand("$HOME/undodir/nvim")
else
  vim.opt.undodir = vim.fn.expand("$HOME/undodir/vim")
end

-- define leader char
-- --------------------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- status line
-- --------------------------------------------------------------------------------
vim.opt.laststatus = 2

-- enable syntax highlighting
vim.cmd "syntax on"
vim.cmd "syntax sync minlines=256"
vim.opt.synmaxcol = 300
vim.opt.redrawtime = 10000

if vim.fn.has("win32") == 1 then
  if vim.fn.has("termencoding") == 1 then
    vim.opt.termencoding = "gb2312"
  end
  if vim.fn.has("directx") == 1 then
    vim.opt.renderoptions = "type:directx,level:0.75,gamma:1.25,contrast:0.5,geom:1,renmode:5,taamode:1"
  end
end

-- ctags
-- --------------------------------------------------------------------------------
-- look ctags in directory the current file in, and working directory,
-- and looking up and up until /
vim.opt.tags = "./tags,tags,./.tags,.tags"

-- emmet-vim
vim.g.user_emmet_leader_key=','

-- vim-test
vim.g.test_strategy = "neovim"
vim.g.test_neovim_start_normal = 0
vim.g.test_javascript_runner = 'jest'
vim.g.test_python_djangotest_options = '--keepdb'
vim.g.test_rust_cargotest_options = '-- --nocapture'
vim.g.test_go_test_options = '-v'

vim.g.tmux_navigator_disable_when_zoomed = 1
vim.g.tmux_navigator_no_mappings = 1

vim.g.floaterm_shell="pwsh.exe"
vim.g.ale_enabled = 1
vim.g.ale_disable_lsp = 1
vim.g.ale_use_neovim_diagnostics_api = vim.g.is_nvim
vim.g.ale_set_quickfix = 0
vim.g.ale_set_loclist = 1
vim.g.ale_open_list=1
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_text_changed = 'never'
vim.g.ale_lint_on_insert_leave = 0
vim.g.ale_lint_on_save=0
vim.g.ale_maximum_file_size=256000
vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
vim.g.ale_echo_msg_error_str="E"
vim.g.ale_echo_msg_warning_str = "W"
vim.g.ale_objcpp_clang_options = '-std=c++17 -Wall'
vim.g.ale_cpp_cc_options = '-std=c++17 -Wall'
vim.g.ale_c_cc_options = '-std=c11 -Wall'
vim.g.ale_python_mypy_options='--follow-imports=silent'
vim.g.ale_pattern_options_enabled = 1
vim.g.ale_linters = {
  javascript = {"eslint"},
  typescript = {"eslint"},
  python = {'ruff', 'pylint', 'mypy', 'black'},
  go = {'gofmt', 'golint', 'gopls', 'govet', 'golangci-lint'},
}

vim.g.ale_pattern_options = {
  ['\\.min\\.js$'] = {ale_enabled = 0},
  ['\\.min\\.css$'] = {ale_enabled = 0},
}

vim.g.ale_fixers = {
  ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
  javascript = {'eslint', 'prettier'},
  typescript = {'eslint', 'prettier'},
  python = {'ruff', 'black', 'yapf', 'isort'},
}

-- markdown
vim.g.tex_conceal = ""
vim.g.vim_markdown_folding_disabled=1
vim.g.vim_markdown_folding_style_pythonic=1
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_math = 1
vim.g.mdip_imgdir='images'
