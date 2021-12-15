local execute = vim.api.nvim_command
local fn = vim.fn
local g = vim.g
local util = require("packer.util")

local install_path = g.VIMFILES .. "/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

-- Auto compile when there are changes in plugins.lua
vim.cmd "autocmd BufWritePost $VIMFILES/lua/myrc/plugins.lua source <afile> | PackerCompile"

require("packer").init(
    {
        package_root = util.join_paths(g.VIMFILES, "pack"),
        compile_path = util.join_paths(g.VIMFILES, "lua/myrc/packer_compiled.lua"),
        display = {auto_clean = false}
    }
)

return require("packer").startup(
    function(use)
        -- Packer can manage itself as an optional plugin
        use "wbthomason/packer.nvim"

        use "mhinz/vim-startify"
        use "kyazdani42/nvim-web-devicons"
        use "Mofiqul/vscode.nvim"

        use "rcarriga/nvim-notify"
        use "nathom/filetype.nvim"

        use "jyd519/ListToggle" -- toggle quickfix/location window
        use "vim-scripts/bufkill.vim"
        use "justinmk/vim-sneak"
        use "mattn/emmet-vim"
        use "jiangmiao/auto-pairs"
        use "tmhedberg/matchit"
        use "AndrewRadev/splitjoin.vim"
        use "junegunn/vim-easy-align"
        use "tpope/vim-surround"
        use "tpope/vim-repeat"
        use "chiedojohn/vim-case-convert"
        use "chentau/marks.nvim"
        use {"numToStr/Comment.nvim"}

        use "sbdchd/neoformat"

        -- Go
        use {"fatih/vim-go", ft = "go", run = ":GoUpdateBinaries"}

        use "tweekmonster/startuptime.vim"

        use "nvim-lualine/lualine.nvim"
        use "dense-analysis/ale"
        use "liuchengxu/vista.vim"

        -- Local plugins
        use {g.VIMFILES .. "/locals/t.nvim"}
        use {g.VIMFILES .. "/locals/vim-a", opt = true, cmd = {"A", "AH"}}

        -- snippets
        use 'SirVer/ultisnips'
        use 'honza/vim-snippets'
        use {'mhartington/vim-angular2-snippets', ft='typescript'}
        --
        -- tmux
        use "christoomey/vim-tmux-navigator"

        use {"neoclide/coc.nvim", branch = "release"}

        -- Gist
        use "mattn/webapi-vim"
        use {"mattn/gist-vim", cmd = {"Gist"}}

        -- File explorer
        use {"preservim/nerdtree", cmd = {"NERDTreeToggle", "NERDTreeFind"}}
        use {"junegunn/fzf", run = "fzf#install()"}
        use "junegunn/fzf.vim"

        -- Treesitter
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    end
)
