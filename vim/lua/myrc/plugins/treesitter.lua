return {
-- Treesitter {{{1
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter",
    branch = "main",
    config = function()
      local treesitter = require("nvim-treesitter")

      ---@diagnostic disable-next-line: missing-fields
      treesitter.setup({
        sync_install = false,
        auto_install = false,
        incremental_selection = {
          enable = false,
          keymaps = {
            init_selection = "<leader>gnn",
            node_incremental = "<leader>grn",
            scope_incremental = "<leader>grc",
            node_decremental = "<leader>grm",
          },
        },
        refactor = {
          highlight_definitions = { enable = true },
          highlight_current_scope = { enable = true },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "grr",
            },
          },
        },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]]"] = "@jsx.element",
              ["]f"] = "@function.outer",
              ["]m"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]M"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@jsx.element",
              ["[f"] = "@function.outer",
              ["[m"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[M"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sn"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sN"] = "@parameter.inner",
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
-- }}}
-- Treesitter Textobjects {{{1
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    enabled = false,
  },
-- }}}
}
-- vim: set fdm=marker fdl=1:
