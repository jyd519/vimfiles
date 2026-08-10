local opt, g = vim.opt, vim.g

-- 检测 Neovim 或 Vim
g.is_nvim = vim.fn.has("nvim") == 1
g.is_vim = not g.is_nvim

-- 初始化 enabled_plugins
if g.enabled_plugins == nil then
  ---@class myrc.PluginConfig
  ---@field fzf? integer
  ---@field osc? integer
  ---@field go? integer
  ---@field node? integer
  ---@field rust? integer
  ---@field python? integer
  ---@field tmux? integer
  ---@field test? integer
  ---@field ghost_text? integer
  ---@field which_key? integer
  ---@field netrw? integer
  ---@field telescope? integer
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

-- 禁用内置插件
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1

-- netrw 配置
if (g.enabled_plugins.netrw or 0) == 1 then
  g.netrw_banner = 0
  g.netrw_liststyle = 3
  g.netrw_browse_split = 0
  g.netrw_altv = 1
  g.netrw_winsize = 25
else
  g.loaded_netrw = 1
  g.loaded_netrwPlugin = 1
  g.loaded_netrwSettings = 1
  g.loaded_netrwFileHandlers = 1
end

-- 启用内嵌语法高亮
g.vimsyn_embed = "lP"

-- 设置 leader 键
g.mapleader = ","
g.maplocalleader = ","

-- surround 插件配置
g.surround_no_insert_mappings = 1

-- 设置 $HOME（如果为空）
if vim.env.HOME == "" then vim.env.HOME = vim.fn.expand("~") end

-- Neovim 特有功能
if g.is_nvim then
  -- prequire 函数
  function _G.prequire(m)
    local ok, err = pcall(require, m)
    if not ok then return nil, err end
    return err
  end

  -- put/dump 函数
  function _G.put(...)
    local objects = {}
    for i = 1, select("#", ...) do
      local val = select(i, ...)
      if val == nil then
        objects[i] = "nil"
      elseif type(val) == "string" then
        objects[i] = val
      else
        objects[i] = vim.inspect(val, { newline = " ", indent = "", depth = 4 })
      end
    end
    print(table.concat(objects, ","))
  end
  function _G.dump(...)
    print(vim.inspect({...}))
  end
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
opt.foldlevelstart = 99
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

-- markdown
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
