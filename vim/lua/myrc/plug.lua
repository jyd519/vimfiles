local g, fn = vim.g, vim.fn
local Plug = require("myrc.utils.vimplug")

Plug.begin("~/vimgit/vim/plugged")

Plug {"lewis6991/impatient.nvim"}

Plug {"mhinz/vim-startify"}
Plug {
    "Mofiqul/vscode.nvim",
    config = function()
        vim.cmd("colorscheme vscode")
    end
}

Plug{"nvim-lua/plenary.nvim"} -- some useful lua functions
Plug{"anuvyklack/keymap-amend.nvim"}
Plug{"tweekmonster/startuptime.vim"}

Plug{"mattn/emmet-vim", ft = {"html", "jsx", "vue"}}
Plug{"jiangmiao/auto-pairs"}
Plug{"tmhedberg/matchit"}
Plug{"AndrewRadev/splitjoin.vim"}
Plug{"junegunn/vim-easy-align"}
Plug{"tpope/vim-repeat"}
Plug("chiedojohn/vim-case-convert")
Plug {"chentoast/marks.nvim", config = [[require "myrc.config.marks"]]}
Plug {"numToStr/Comment.nvim", config = [[require("Comment").setup()]]}
Plug(g.VIMFILES .. "/locals/vim-a")
Plug {
    g.VIMFILES .. "/locals/nvim-projectconfig",
    config = function()
        require("nvim-projectconfig").setup({silent = false})
    end
}

Plug {"nathanaelkane/vim-indent-guides"}
Plug {"thinca/vim-quickrun", on = "VimEnter"}
Plug {"vim-test/vim-test", opt = true, on = "VimEnter"} -- Unit-Testing
Plug {"dense-analysis/ale", opt = true, on = "VimEnter"}

-- file management
Plug {"preservim/nerdtree", on = {"NERDTree", "NERDTreeToggle", "NERDTreeFind", "NERDTreeFromBookmark"}}
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

-- snippets
if fn.executable("python3") == 1 then
  Plug {"SirVer/ultisnips"}
end
Plug {"honza/vim-snippets"}
Plug {"mhartington/vim-angular2-snippets", ft = "typescript"}
Plug {"L3MON4D3/LuaSnip"}
Plug {"rafamadriz/friendly-snippets"}

-- Completion Engine
Plug {"hrsh7th/nvim-cmp", config = [[require "myrc.config.cmp"]]}
Plug {"tzachar/cmp-tabnine", run = "./install.sh", config = [[require "myrc.config.tabnine"]]}
Plug {"hrsh7th/cmp-nvim-lsp", config = [[ require "myrc.config.lsp" ]]}
Plug {"hrsh7th/cmp-buffer", after = "nvim-cmp"}
Plug {"hrsh7th/cmp-path", after = "nvim-cmp"}
Plug {"jyd519/cmp-cmdline", after = "nvim-cmp"}
Plug {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = {"lua"}}
Plug {"hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp"}
Plug {"quangnguyen30192/cmp-nvim-tags", ft = {"c", "cpp"}}
Plug {"saadparwaiz1/cmp_luasnip", ft = {"lua"}}
Plug {"b0o/schemastore.nvim"}

-- LSP
Plug {"williamboman/mason.nvim"}
Plug {"williamboman/mason-lspconfig.nvim"}
Plug {"neovim/nvim-lspconfig"}
Plug {"jose-elias-alvarez/null-ls.nvim"}
Plug {"jose-elias-alvarez/nvim-lsp-ts-utils"}
Plug {"arkav/lualine-lsp-progress"}
Plug {"folke/neodev.nvim", opt = true, ft={"lua"}}
Plug {
    "simrat39/symbols-outline.nvim",
    config = function()
        require("myrc.config.symbols-outline")
    end
}

-- Debugging
Plug {"mfussenegger/nvim-dap-python"}
Plug {"nvim-telescope/telescope-dap.nvim"}
Plug {"leoluz/nvim-dap-go", module = "dap-go"}
Plug {"jbyuki/one-small-step-for-vimkind", module = "osv"}
Plug {"mxsdev/nvim-dap-vscode-js"}
Plug {
    "mfussenegger/nvim-dap",
    -- event = "BufReadPre",
    config = function()
        require("myrc.config.dap")
    end
}
Plug {"rcarriga/nvim-dap-ui"}
Plug {"theHamsta/nvim-dap-virtual-text"}

-- tmux
if fn.has("win32") == 0 and fn.executable("tmux") == 1 then
    Plug "christoomey/vim-tmux-navigator"
end

-- Statusline
Plug {"nvim-lualine/lualine.nvim", config = [[require "myrc.config.lualine"]]}

-- " Git
Plug {"lewis6991/gitsigns.nvim", config = [[require "myrc.config.gitsigns"]]}
-- Plug 'tpope/vim-fugitive'
-- Plug 'airblade/vim-gitgutter'

-- Treesitter
Plug {"nvim-treesitter/nvim-treesitter", config = [[require('myrc.config.treesitter')]], run = ":TSUpdate"}
Plug {"ThePrimeagen/refactoring.nvim"}

-- Code formatter
Plug "sbdchd/neoformat"

-- Go/dart/rust/cpp
if fn.executable("go") == 1 then
    Plug {"fatih/vim-go", ft = "go", run = ":GoUpdateBinaries"}
end
Plug {"dart-lang/dart-vim-plugin", ft = "dart"}
Plug {
    "rust-lang/rust.vim",
    config = function()
        vim.g.rustfmt_autosave = 1
    end
}
Plug {"simrat39/rust-tools.nvim"}
Plug {
    "saecki/crates.nvim",
    ft = "go",
    tag = "v0.2.1",
    config = function()
        require("crates").setup()
    end
}
Plug {"p00f/clangd_extensions.nvim", config = [[require("myrc.config.clangd")]]}

Plug.ends()

local plugins = g.enabled_plugins
for name in pairs(g.plugs) do
    plugins[name:lower()] = 1
end
g.enabled_plugins = plugins
