local treesitter = require("nvim-treesitter.configs")

---@diagnostic disable-next-line: missing-fields
treesitter.setup({
  -- ensure_installed = {"c", "cpp", "css", "rust", "python", "json", "go", "cmake", "html", "javascript", "typescript"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = false,

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = function(lang, buf)
      if vim.list_contains({ "vimdoc", "help" }, lang) then return true end

      -- if lang == "markdown" and vim.g.markdown_treesitter ~= 1 then return true end

      ---@diagnostic disable-next-line: undefined-field
      if vim.b.large_buf then return true end
    end,
    -- additional_vim_regex_highlighting = false,
  },
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

  -- textobjects
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
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

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
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

local has_parser = require("nvim-treesitter.parsers").has_parser
local tfgroup = vim.api.nvim_create_augroup("treesitter_fold", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "typescript", "lua", "rust", "markdown" },
  group = tfgroup,
  desc = "enable treesitter folding",
  callback = function()
    if has_parser(vim.bo.filetype) then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
})
