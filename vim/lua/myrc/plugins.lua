local fn = vim.fn
local g = vim.g

-- Packer.nvim {{{

-- install packer.nvim {{{ 2 --
local install_path = g.VIMFILES .. "/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    print("installing packer.nvim ...")
    PACKER_BOOTSTRAP = fn.system("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
    fn.execute "packadd packer.nvim"
end

-- Auto compile when there are changes in plugins.lua
-- vim.cmd "autocmd BufWritePost $VIMFILES/lua/myrc/plugins.lua source <afile> | PackerCompile"
local util = require("packer.util")
require("packer").init(
    {
        package_root = util.join_paths(g.VIMFILES, "pack"),
        compile_path = util.join_paths(g.VIMFILES, "lua/myrc/packer_compiled.lua"),
        display = {auto_clean = false}
    }
)
-- end install packer }}}

return require("packer").startup(
    function(use)
        -- Packer can manage itself as an optional plugin
        use "wbthomason/packer.nvim"
        use "nvim-lua/plenary.nvim" -- some useful lua functions

        use "mhinz/vim-startify"
        use "kyazdani42/nvim-web-devicons"
        use "Mofiqul/vscode.nvim"
        use "NLKNguyen/papercolor-theme"

        use "rcarriga/nvim-notify"
        use "nathom/filetype.nvim"

        use "jyd519/ListToggle" -- toggle quickfix/location window
        use "vim-scripts/bufkill.vim"
        use "justinmk/vim-sneak"
        use {"mattn/emmet-vim", ft = {"html", "jsx", "vue"}}
        use "jiangmiao/auto-pairs"
        use "tmhedberg/matchit"
        use "AndrewRadev/splitjoin.vim"
        use "junegunn/vim-easy-align"
        use "tpope/vim-surround"
        use "tpope/vim-repeat"
        use "chiedojohn/vim-case-convert"
        use "chentoast/marks.nvim"
        use {"numToStr/Comment.nvim"}

        use "sbdchd/neoformat"
        use {"puremourning/vimspector", cond = fn.executable("pip3") ~= 0}

        use "pearofducks/ansible-vim"
        use "lukas-reineke/indent-blankline.nvim"

        -- AI Coding
        use {"github/copilot.vim"}

        -- Go
        use {"fatih/vim-go", ft = "go", run = ":GoUpdateBinaries"}

        use { 'dart-lang/dart-vim-plugin' }

        -- Markdown, reStructuredText, textile
        use {"godlygeek/tabular", ft = "markdown"}
        use {"plasticboy/vim-markdown", ft = "markdown"}
        -- use "tpope/vim-markdown"
        use {"jyd519/md-img-paste.vim", ft = "markdown", branch = "master"}

        use {"tweekmonster/startuptime.vim", cmd="StartupTime"}

        use "nvim-lualine/lualine.nvim"
        use "dense-analysis/ale"
        use "liuchengxu/vista.vim"

        -- Local plugins
        use {g.VIMFILES .. "/locals/t.nvim"}
        use {g.VIMFILES .. "/locals/vim-a", opt = true, cmd = {"A", "AH"}}
        use {g.VIMFILES .. "/locals/nvim-projectconfig"}

        -- snippets
        {use "SirVer/ultisnips", cond = fn.executable("pip3") ~= 0}
        use "honza/vim-snippets"
        use {"mhartington/vim-angular2-snippets", ft = "typescript"}
        --
        -- tmux
        use "christoomey/vim-tmux-navigator"

        -- Completion Engine
        use {"neoclide/coc.nvim", commit= "f4cd929466071d60e6126932f71731c4fca7c4e3", cond = fn.executable("node") ~= 0}

        -- git
        use { "lewis6991/gitsigns.nvim"}

        -- Gist
        use "mattn/webapi-vim"
        use {"mattn/gist-vim", cmd = {"Gist"}}

        -- File explorer
        use {"preservim/nerdtree", cmd = {"NERDTree", "NERDTreeToggle", "NERDTreeFind", "NERDTreeFromBookmark"}}
        use {"junegunn/fzf", run = "fzf#install()"}
        use "junegunn/fzf.vim"

        -- Treesitter
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

        if PACKER_BOOTSTRAP then
          print("installing plugins ...")
          require("packer").sync();
        end
    end
)

-- vim: set fdm=marker fen: }}}
