local opt, g = vim.opt, vim.g

g.enable_inlay_hint = true

if g.enabled_plugins == nil then
  g.enabled_plugins = {
    telescope = 1,
    fzf = 1,
    osc = 0,
    node = 0,
    go = 0,
    rust = 0,
    python = 0,
    tmux = 0,
    test = 0,
    ghost_text = 0,
    which_key = 0,
  }
end

opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.modeline = true
opt.wrap = false
opt.number = true
-- vim.opt.relativenumber = true
opt.ignorecase = true
opt.smartcase = true -- Only be case sensitive when search contains uppercase
opt.hidden = true -- allow we leave from the current modified buffer
opt.smartindent = true
opt.hlsearch = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.backupcopy = "yes"
opt.showmatch = true
opt.cmdheight = 2
opt.history = 100
opt.updatetime = 300 -- Smaller updatetime for CursorHold & CursorHoldI
opt.shortmess:append("c") -- don't give |ins-completion-menu| messages.
opt.signcolumn = "yes" -- always show signcolumns

if vim.o.foldmethod == "manual" then opt.foldmethod = "indent" end

opt.foldlevel = 99
opt.foldlevelstart = -1
opt.foldcolumn = "3"
opt.scrolloff = 2
opt.encoding = "utf-8"
opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030"
opt.wildmenu = true -- show a navigable menu for tab completion
opt.wildmode = "list:longest,full"
opt.wildignore:append("*/tmp/*,*.so,*.swp,*.zip") -- MacOSX/Linux
opt.wildignore:append("*\\tmp\\*,*.swp,*.zip,*.exe") -- Windows
opt.wildignore:append("*DS_Store,*.pyc")
opt.completeopt = "menu,menuone,noselect,preview"
-- vim.opt.t_ti= vim.opt.t_te= Keep screen after vim exited
opt.formatoptions:append("mM") -- Better CJK supports
opt.clipboard:append("unnamed")

if vim.fn.has("balloon_eval") == 1 then
  opt.ballooneval = true
  opt.balloondelay = 100
end

if vim.fn.has("termguicolors") == 1 then
  opt.termguicolors = true
  -- Correct RGB escape codes for vim inside tmux
  if not vim.fn.has("nvim") == 1 and vim.env.TERM == "screen-256color" then
    opt.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
    opt.t_8b = "<Esc>[48;2;%lu;%lu;%lum"
  end
end

opt.path = ",,.,./include,/usr/local/include,/usr/include,$VIMFILES"

-- Default sh is Bash
vim.g.bash_is_sh = 1

-- Persistent undo
opt.undofile = true
if vim.fn.has("nvim") == 1 then
  opt.undodir = vim.fn.expand("$HOME/undodir/nvim")
else
  opt.undodir = vim.fn.expand("$HOME/undodir/vim")
end

-- status line
opt.laststatus = 2

-- define leader char
-- --------------------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- enable syntax highlighting
vim.cmd("syntax sync minlines=256")
opt.synmaxcol = 300
opt.redrawtime = 10000

if vim.fn.has("win32") == 1 then
  if vim.fn.has("termencoding") == 1 then opt.termencoding = "gb2312" end
  if vim.fn.has("directx") == 1 then
    opt.renderoptions = "type:directx,level:0.75,gamma:1.25,contrast:0.5,geom:1,renmode:5,taamode:1"
  end
end

-- ctags
-- --------------------------------------------------------------------------------
-- look ctags in directory the current file in, and working directory,
-- and looking up and up until /
opt.tags = "./tags,tags,./.tags,.tags"

-- emmet-vim
g.user_emmet_leader_key = ","

-- vim-test
g.test_strategy = "neovim"
g.test_neovim_start_normal = 0
g.test_javascript_runner = "jest"
g.test_python_djangotest_options = "--keepdb"
g.test_rust_cargotest_options = "-- --nocapture"
g.test_go_test_options = "-v"

-- vim-tmux-navigator
g.tmux_navigator_disable_when_zoomed = 1
g.tmux_navigator_no_mappings = 1

g.floaterm_shell = "pwsh.exe"

-- ale
g.ale_enabled = 1
g.ale_disable_lsp = 1
g.ale_use_neovim_diagnostics_api = vim.g.is_nvim
g.ale_set_quickfix = 0
g.ale_set_loclist = 1
g.ale_open_list = 1
g.ale_lint_on_enter = 0
g.ale_lint_on_text_changed = "never"
g.ale_lint_on_insert_leave = 0
g.ale_lint_on_save = 0
g.ale_maximum_file_size = 256000
g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
g.ale_echo_msg_error_str = "E"
g.ale_echo_msg_warning_str = "W"
g.ale_objcpp_clang_options = "-std=c++17 -Wall"
g.ale_cpp_cc_options = "-std=c++17 -Wall"
g.ale_c_cc_options = "-std=c11 -Wall"
g.ale_python_mypy_options = "--follow-imports=silent"
g.ale_pattern_options_enabled = 1
g.ale_linters = {
  javascript = { "eslint" },
  typescript = { "eslint" },
  python = { "ruff", "pylint", "mypy", "black" },
  go = { "gofmt", "golint", "gopls", "govet", "golangci-lint" },
}

g.ale_pattern_options = {
  ["\\.min\\.js$"] = { ale_enabled = 0 },
  ["\\.min\\.css$"] = { ale_enabled = 0 },
}

g.ale_fixers = {
  ["*"] = { "remove_trailing_lines", "trim_whitespace" },
  javascript = { "eslint", "prettier" },
  typescript = { "eslint", "prettier" },
  python = { "ruff", "black", "yapf", "isort" },
}

-- markdown
g.tex_conceal = ""
g.vim_markdown_folding_disabled = 1
g.vim_markdown_folding_style_pythonic = 1
g.vim_markdown_conceal = 0
g.vim_markdown_math = 1
g.mdip_imgdir = "images"

--- Enable OSC 52 for copying to system clipboard in SSH
-- See: https://github.com/neovim/neovim/issues/28611#issuecomment-2147744670
if os.getenv("SSH_TTY") then
  vim.g.clipboard = {
    name = "OSC 52",
    -- Try to use OSC 52 escape sequences to copy to system clipboard
    -- It should not break anything if it’s not supported
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    -- Disable paste since it does not work in some terminals,
    -- i.e., xterm.js (many app based on Web tech use this)
    paste = {
      ["+"] = function(lines) return vim.split(vim.fn.getreg('"'), "\n") end,
      ["*"] = function(lines) return vim.split(vim.fn.getreg('"'), "\n") end,
    },
  }
end
