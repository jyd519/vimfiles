local mod = prequire("nvim-treesitter.configs")
if mod then
  mod.setup({
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    -- ensure_installed = {"c", "cpp", "css", "rust", "python", "json", "go", "cmake", "html", "javascript", "typescript"},
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = function(lang, buf)
        if lang == "markdown" then
          -- inline fence not get syntax highlight with treesitter highlight
          return true
        end

        ---@diagnostic disable-next-line: undefined-field
        if vim.b.large_buf then
          return true
        end

        local LINE_NR_THRESH = 1000
        if vim.api.nvim_buf_line_count(buf) > LINE_NR_THRESH then
          return true
        end
      end,
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
  local treesitter_fold = vim.api.nvim_create_augroup("treesitter_fold", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp", "c", "vim", "typescript", "lua", "rust" },
    group = treesitter_fold,
    desc = "enable treesitter folding",
    callback = function()
      if has_parser(vim.bo.filetype) then
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      end
    end,
  })
end
