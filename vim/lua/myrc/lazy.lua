-- Install lazy.nvim {{{2
local fn = vim.fn
local g = vim.g

local lazypath = g.VIMFILES .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)
-- 2}}}

-- Plugins
require("lazy").setup(
    {
        -- Utils {{{2
        {"nvim-lua/plenary.nvim", lazy = true}, -- some useful lua functions
        {
            "nvim-treesitter/nvim-treesitter",
            version = false,
            event = {"BufReadPost", "BufNewFile"},
            config = function()
                require("myrc.config.treesitter")
            end
        },
        {
            "dstein64/vim-startuptime",
            cmd = "StartupTime",
            init = function()
                vim.g.startuptime_tries = 10
            end
        },
        {"christoomey/vim-tmux-navigator", enabled = fn.has("win32") == 0 and fn.executable("tmux") == 1},
        -- }}}
        -- colorscheme {{{2
        {"Mofiqul/vscode.nvim", lazy = true},
        {"NLKNguyen/papercolor-theme", lazy = true},
        -- }}}
        -- Basic plugins {{{2
        "mhinz/vim-startify",
        "anuvyklack/keymap-amend.nvim",
        "justinmk/vim-sneak",
        {"mattn/emmet-vim", ft = {"html", "jsx", "vue"}},
        {
            "echasnovski/mini.nvim",
            version = "*",
            event = "VeryLazy",
            config = function(_, opts)
                -- https://github.com/echasnovski/mini.nvim
                require("mini.pairs").setup(opts)
            end
        },
        {"AndrewRadev/splitjoin.vim"},
        "tmhedberg/matchit",
        "junegunn/vim-easy-align",
        {"godlygeek/tabular", cmd = "Tabularize"},
        {"tpope/vim-repeat"},
        {"chiedojohn/vim-case-convert"},
        {
            "chentoast/marks.nvim",
            config = function()
                require("myrc.config.marks")
            end
        },
        {"numToStr/Comment.nvim", config = true},
        {"gpanders/editorconfig.nvim"},
        {"kyazdani42/nvim-web-devicons", lazy = true},
        {
            "rcarriga/nvim-notify",
            config = function()
                require("myrc.config.notify")
            end
        },
        {dir = g.VIMFILES .. "/locals/t.nvim", cmd = {"T", "TS"}},
        {dir = g.VIMFILES .. "/locals/vim-a", cmd = {"A", "AH"}},
        {
            dir = g.VIMFILES .. "/locals/nvim-projectconfig",
            opts = {silent = false},
            priority = 20
        },
        -- }}}
        -- Coding {{{2
        {"thinca/vim-quickrun", cmd = {"QuickRun"}},
        {"vim-test/vim-test", event = "VimEnter"}, -- Unit-Testing
        -- https://github.com/ThePrimeagen/refactoring.nvim#installation
        {
            "ThePrimeagen/refactoring.nvim",
            config = function()
                require("telescope").load_extension("refactoring")
                vim.api.nvim_set_keymap(
                    "v",
                    "<leader>rf",
                    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
                    {noremap = true}
                )
            end
        },
        {"sbdchd/neoformat", cmd = {"Neoformat"}},
        {
            "lukas-reineke/indent-blankline.nvim",
            event = {"BufReadPost", "BufNewFile"},
            config = true,
            opts = {
                char = "│",
                filetype_exclude = {"markdown", "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy"},
                -- depends on treesitter
                show_current_context = true,
                show_current_context_start = true
            }
        },
        {
            "lewis6991/gitsigns.nvim",
            event = {"BufReadPre", "BufNewFile"},
            config = function()
                require("myrc.config.gitsigns")
            end
        },
        -- }}}
        -- DAP Debugging {{{2
        {
            "mfussenegger/nvim-dap",
            lazy = true,
            event = "BufReadPre",
            config = function()
                require("myrc.config.dap")
            end
        },
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        {"leoluz/nvim-dap-go"},
        {"jbyuki/one-small-step-for-vimkind", module = "osv"},
        {"mxsdev/nvim-dap-vscode-js"},
        -- }}}
        -- Languages Go/dart/rust/cpp/typescript {{{2
        {"jose-elias-alvarez/typescript.nvim"},
        {"ray-x/guihua.lua", ft = "go"}, -- float term, codeaction and codelens gui support
        {"ray-x/go.nvim", ft = "go"},
        {
            "rust-lang/rust.vim",
            init = function()
                vim.g.rustfmt_autosave = 1
            end
        },
        {"simrat39/rust-tools.nvim"},
        {"saecki/crates.nvim", config = true},
        {
            "p00f/clangd_extensions.nvim",
            ft = {"c", "cpp", "objc", "objcpp", "cuda", "proto"},
            config = function()
                require("myrc.config.clangd")
            end
        },
        {"pearofducks/ansible-vim"},
        {"dense-analysis/ale", lazy = true, event = "VimEnter"}, -- linter
        -- Markdown, reStructuredText, textile
        {"jyd519/md-img-paste.vim", ft = "markdown"},
        -- }}}
        -- Snippets {{{2
        {
            "SirVer/ultisnips",
            enabled = g.enabled_plugins.python,
            event = {"BufReadPre", "BufNewFile"}
        },
        {
            "L3MON4D3/LuaSnip",
            event = {"BufReadPre", "BufNewFile"},
            dependencies = {
                {"rafamadriz/friendly-snippets"},
                {"honza/vim-snippets"}
            },
            config = function()
                require("myrc.config.luasnip")
            end
        },
        -- }}}
        -- Completion Engine {{{2
        {
            "hrsh7th/nvim-cmp",
            version = false,
            event = "VimEnter",
            dependencies = {
                {"hrsh7th/cmp-nvim-lsp"},
                {"hrsh7th/cmp-buffer"},
                {"hrsh7th/cmp-path"},
                {"jyd519/cmp-cmdline"},
                {"hrsh7th/cmp-nvim-lua"},
                {"hrsh7th/cmp-nvim-lsp-document-symbol"},
                {"quangnguyen30192/cmp-nvim-tags", ft = {"c", "cpp"}},
                {"saadparwaiz1/cmp_luasnip"},
                {
                    "tzachar/cmp-tabnine",
                    build = "./install.sh",
                    config = function()
                        require("myrc.config.tabnine")
                    end
                }
            },
            config = function()
                require("myrc.config.cmp")
            end
        },
        -- }}}
        -- LSP {{{2
        {"williamboman/mason.nvim"},
        {"williamboman/mason-lspconfig.nvim"},
        {
            "neovim/nvim-lspconfig",
            event = {"BufReadPre", "BufNewFile"},
            config = function()
                require("myrc.config.lsp")
            end
        },
        {
            "jose-elias-alvarez/null-ls.nvim",
            event = {"BufReadPre", "BufNewFile"}
        },
        {"folke/neodev.nvim", lazy = true},
        {
            "simrat39/symbols-outline.nvim",
            config = function()
                require("myrc.config.symbols-outline")
            end
        },
        {"b0o/schemastore.nvim"},
        -- }}}
        -- File explorer/Fuzzy Finder {{{2
        {
            "preservim/nerdtree",
            cmd = {
                "NERDTree",
                "NERDTreeToggle",
                "NERDTreeFind",
                "NERDTreeFromBookmark"
            }
        },
        {
            "junegunn/fzf.vim",
            event = "VimEnter",
            dependencies = {
                {
                    "junegunn/fzf",
                    build = "fzf#install()",
                    enabled = fn.get(g.enabled_plugins, "fzf") == 1
                }
            },
            enabled = fn.get(g.enabled_plugins, "fzf") == 1
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.1",
            dependencies = {
                {"nvim-telescope/telescope-ui-select.nvim"}
            },
            config = function()
                require("myrc.config.telescope")
            end
        },
        -- }}}
        -- Status line {{{2
        {
            "nvim-lualine/lualine.nvim",
            event = "VeryLazy",
            dependencies = {
                -- The icon font for Visual Studio Code
                {"ChristianChiarulli/neovim-codicons", lazy = true}
            },
            config = function()
                require("myrc.config.lualine")
            end
        },
        {"arkav/lualine-lsp-progress"}
        -- 2}}}
    },
    -- Lazy configurations {{{2
    {
        root = g.VIMFILES .. "/lazy",
        performance = {
            rtp = {
                reset = false -- reset the runtime path to $VIMRUNTIME and your config directory
            }
        },
        ui = {
            icons = {
                cmd = "⌘",
                config = "🛠",
                event = "📅",
                ft = "📂",
                init = "⚙",
                keys = "🗝",
                plugin = "🔌",
                runtime = "💻",
                source = "📄",
                start = "🚀",
                task = "📌",
                lazy = "💤 "
            }
        }
    }
    -- }}}
)

-- Initialize enabled_plugins{{{2
local plugins = g.enabled_plugins
local lazyPlugins = require("lazy").plugins()
for _, plugin in pairs(lazyPlugins) do
    if type(plugin) == "table" then
        plugins[plugin.name:lower()] = 1
    end
end
g.enabled_plugins = plugins
-- }}}

-- vim: set fdm=marker fdl=1: }}}
