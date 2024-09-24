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
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
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
})

local has_parser = require("nvim-treesitter.parsers").has_parser
local tfgroup = vim.api.nvim_create_augroup("treesitter_fold", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "typescript", "lua", "rust", "markdown" },
  group = tfgroup,
  desc = "enable treesitter folding",
  callback = function()
    if has_parser(vim.bo.filetype) then
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    end
  end,
})
