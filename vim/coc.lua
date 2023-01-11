local g, env, fn = vim.g, vim.env, vim.fn
local VIMFILES = fn.fnamemodify(fn.resolve(fn.expand("<sfile>:p")), ":h")

vim.cmd("set rtp^=" .. VIMFILES)
vim.cmd("set rtp+=" .. VIMFILES .. "/after")

g.VIMFILES, env.VIMFILES = VIMFILES, VIMFILES
g.MYINITRC = VIMFILES .. "/init.lua"
env.MYSNIPPETS = VIMFILES .. "/mysnippets"

if g.enabled_plugins == nil then
    g.enabled_plugins = {coc = 1, fzf = 1}
end

-- load global variables
vim.cmd("runtime config/globals.vim")

-- load plugins {{{1
local Plug = require("myrc.utils.vimplug")
Plug.begin("~/vimgit/vim/plugged")

Plug {"lewis6991/impatient.nvim"}
Plug "mhinz/vim-startify"

Plug {
    "Mofiqul/vscode.nvim",
    config = function()
        vim.cmd("colorscheme vscode")
    end
}

Plug "nvim-lua/plenary.nvim" -- some useful lua functions

Plug {"mattn/emmet-vim", ft = {"html", "jsx", "vue"}}
Plug "jiangmiao/auto-pairs"
Plug "tmhedberg/matchit"
Plug "AndrewRadev/splitjoin.vim"
Plug "junegunn/vim-easy-align"
-- Plug 'tpope/vim-repeat'
-- Plug 'tpope/vim-surround'
Plug "chiedojohn/vim-case-convert"
Plug "tomtom/tcomment_vim"
Plug(VIMFILES .. "/locals/vim-a")
Plug {
    VIMFILES .. "/locals/nvim-projectconfig",
    config = function()
        require("nvim-projectconfig").setup({silent = false})
    end
}

Plug "tweekmonster/startuptime.vim"

Plug("anuvyklack/keymap-amend.nvim")

-- file management
Plug {"preservim/nerdtree", on = {"NERDTreeToggle", "NERDTreeFind"}}

if fn.get(g.enabled_plugins, "fzf") == 1 then
    Plug {
        "junegunn/fzf",
        run = function()
            vim.fn("fzf#install")()
        end
    }
    Plug "junegunn/fzf.vim"
end

Plug {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    config = function()
        require("myrc.config.telescope")
    end
}
Plug("nvim-telescope/telescope-ui-select.nvim")

Plug "dense-analysis/ale"
Plug "nathanaelkane/vim-indent-guides"
-- Plug 'xolox/vim-misc'

-- tmux
if fn.has("win32") == 0 and fn.executable("tmux") == 1 then
    Plug "christoomey/vim-tmux-navigator"
end

-- Auto Completion
Plug {"neoclide/coc.nvim", branch = "release"}

-- Statusline
Plug "vim-airline/vim-airline"

-- Code formatter
Plug "sbdchd/neoformat"

-- " Git
Plug "tpope/vim-fugitive"
Plug "airblade/vim-gitgutter"
Plug.ends()

local plugins = g.enabled_plugins
for name in pairs(g.plugs) do
    plugins[name:lower()] = 1
end
g.enabled_plugins = plugins

-- load options, mappings and configurations
local scripts = {
    "config/options.vim",
    "config/mappings.vim",
    "config/plugins/shared.vim",
    "config/plugins/coc.vim",
    "lua/myrc/config/common.lua"
}
for _, s in pairs(scripts) do
    vim.cmd("source " .. VIMFILES .. "/" .. s)
end


-- vim: set fdm=marker fdl=0:
