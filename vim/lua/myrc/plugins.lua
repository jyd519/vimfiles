local fn = vim.fn
local g = vim.g

 -- Conditional load heavy plugins
local use_lsp = g.use_heavy_plugin or g.use_lsp_plugin
local no_lsp = not use_lsp
local use_all = g.use_heavy_plugin
local use_basic_only = not use_all

-- Packer.nvim {{{

-- install packer.nvim {{{ 2 --
local install_path = g.VIMFILES .. "/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    print("installing packer.nvim ...")
    PACKER_BOOTSTRAP = fn.system("git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
    fn.execute "packadd packer.nvim"
end

-- Auto compile when there are changes in plugins.lua
vim.cmd [[
augroup au_packer
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]]

local util = require("packer.util")
local packer = require("packer")
packer.init(
    {
        package_root = util.join_paths(g.VIMFILES, "pack"),
        compile_path = util.join_paths(g.VIMFILES, "lua/myrc/packer_compiled.lua"),
        display = {auto_clean = false}
    }
)
-- end install packer }}}
packer.reset()
return packer.startup(
    function(use)
        -- Packer can manage itself as an optional plugin
        use {"wbthomason/packer.nvim"}

        use "nvim-lua/plenary.nvim" -- some useful lua functions
        use {"lewis6991/impatient.nvim"}


        -- Basic plugins
        use "mhinz/vim-startify"
        use "kyazdani42/nvim-web-devicons"
        use "Mofiqul/vscode.nvim"
        use "NLKNguyen/papercolor-theme"

        use "rcarriga/nvim-notify"
        use "nathom/filetype.nvim"
        use "qpkorr/vim-bufkill"
        use "justinmk/vim-sneak"
        use {"mattn/emmet-vim", ft = {"html", "jsx", "vue"}}
        use "jiangmiao/auto-pairs"
        use "tmhedberg/matchit"
        use "AndrewRadev/splitjoin.vim"
        use "junegunn/vim-easy-align"
        use "tpope/vim-surround"
        use "tpope/vim-repeat"
        use "chiedojohn/vim-case-convert"
        use {"chentoast/marks.nvim", config = [[require "myrc.config.marks"]]}
        use {"numToStr/Comment.nvim"}
        use "sbdchd/neoformat"
        use "lukas-reineke/indent-blankline.nvim"

        use { 'thinca/vim-quickrun' }
        use { 'vim-test/vim-test' } -- Unit-Testing
        use { 'ThePrimeagen/refactoring.nvim' }

        use {"pearofducks/ansible-vim"}

        use {g.VIMFILES .. "/locals/t.nvim"}
        use {g.VIMFILES .. "/locals/vim-a", opt = true, cmd = {"A", "AH"}}
        use {g.VIMFILES .. "/locals/nvim-projectconfig"}

        -- Debugging
        use {
          "mfussenegger/nvim-dap",
          opt = true,
          event = "BufReadPre",
          module = { "dap" },
          requires = {
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
            { "leoluz/nvim-dap-go", module = "dap-go" },
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
          },
          config = function()
            require("myrc.config.dap")
          end,
        }
        use { 'mxsdev/nvim-dap-vscode-js' }

        -- AI Coding
        -- use {"github/copilot.vim"}
        -- use {
        --   "zbirenbaum/copilot.lua",
        --   event = "InsertEnter",
        --   config = function ()
        --     vim.schedule(function() require("copilot").setup({
        --       cmp = {
        --         enabled = true,
        --         method = "getCompletionsCycling",
        --       },
        --       ft_disable = { "markdown", "terraform" },
        --         }) end)
        --   end,
        -- }
        -- use {
        --   "zbirenbaum/copilot-cmp",
        --   module = "copilot_cmp",
        -- }

        -- Go/dart/rust/cpp
        use {"fatih/vim-go", ft = "go", run = ":GoUpdateBinaries", disable = use_basic_only or fn.executable("go") == 0}
        use {"dart-lang/dart-vim-plugin", ft="dart", disable = use_basic_only or fn.executable("dart") == 0}
        use {"simrat39/rust-tools.nvim", config = [[ require('myrc.config.rust') ]]}
        use {"p00f/clangd_extensions.nvim", config = [[require("myrc.config.clangd")]]}

        -- Markdown, reStructuredText, textile
        use {"godlygeek/tabular", ft = "markdown"}
        use {"plasticboy/vim-markdown", ft = "markdown"}
        use {"jyd519/md-img-paste.vim", ft = "markdown", branch = "master"}

        use {"tweekmonster/startuptime.vim", cmd="StartupTime"}

        use { "nvim-lualine/lualine.nvim", config = [[require "myrc.config.lualine"]] }
        use "dense-analysis/ale"

        -- snippets
        use {"SirVer/ultisnips", disable = use_basic_only }
        use "honza/vim-snippets"
        use {"mhartington/vim-angular2-snippets", ft = "typescript"}

        use {'L3MON4D3/LuaSnip'} -- Snippets plugin
        use { 'rafamadriz/friendly-snippets' }

        -- tmux
        use "christoomey/vim-tmux-navigator"

        -- Completion Engine
        use {
          'hrsh7th/nvim-cmp',
          requires = {
            { 'hrsh7th/cmp-nvim-lsp', config = [[ require "myrc.config.lsp" ]] },
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'jyd519/cmp-cmdline', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
            { 'quangnguyen30192/cmp-nvim-tags', ft = { 'c', 'cpp' } },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'b0o/schemastore.nvim' }
          },
          config = [[require "myrc.config.cmp"]],
        }
        if use_all then
          use {'tzachar/cmp-tabnine', run= './install.sh', config = [[require "myrc.config.tabnine"]]}
        end

        -- LSP
        if not no_lsp then
          use { 'williamboman/mason.nvim' }
          use { 'williamboman/mason-lspconfig.nvim' }
          use { 'neovim/nvim-lspconfig' }
          use { 'jose-elias-alvarez/null-ls.nvim' }
          use { 'jose-elias-alvarez/nvim-lsp-ts-utils' }
          use { 'arkav/lualine-lsp-progress' }
          use { 'folke/lua-dev.nvim', opt = true }
        end

        -- git
        use { "lewis6991/gitsigns.nvim", config = [[require "myrc.config.gitsigns"]]}

        -- Gist
        use {
          -- create ~/.gist-vim with this content: token xxxxx
          "mattn/vim-gist",
          requires = "mattn/webapi-vim",
          config = function()
            vim.g.gist_per_page_limit = 100
          end,
          cmd = { "Gist" },
        }

        -- File explorer/Fuzzy Finder
        use {"preservim/nerdtree", cmd = {"NERDTree", "NERDTreeToggle", "NERDTreeFind", "NERDTreeFromBookmark"}}
        use {"junegunn/fzf", run = "fzf#install()"}
        use {"junegunn/fzf.vim"}
        use {"nvim-telescope/telescope.nvim", tag = "0.1.0", config = [[ require"myrc.config.telescope" ]]}
        use { "folke/which-key.nvim",
          config = function()
            require("which-key").setup {}
          end
        }
        -- Treesitter
        use {"nvim-treesitter/nvim-treesitter", config= [[require('myrc.config.treesitter')]], run = ":TSUpdate", disable = use_basic_only }

        if PACKER_BOOTSTRAP then
          print("installing plugins ...")
          require("packer").sync();
        end
    end
)

-- vim: set fdm=marker fen fdl=1: }}}
