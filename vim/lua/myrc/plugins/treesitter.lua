return {
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter",
    branch = "main",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "bash", "sh", "python", "javascript", "typescript", "c", "cpp", "markdown", "go", "lua", "rust" },
        callback = function()
          local ft = vim.bo.filetype
          if ft == "" then return end

          -- 检查是否能启动 treesitter
          local ok, parser = pcall(vim.treesitter.language.add, ft)
          if not ok then return end

          pcall(vim.treesitter.start)

          -- 分别检查 folds 和 indents 查询是否存在
          local has_folds = pcall(vim.treesitter.query.get, ft, "folds")
          local has_indents = pcall(vim.treesitter.query.get, ft, "indents")

          if has_folds then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          else
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldexpr = ""
          end

          if has_indents then vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup()
      vim.keymap.set(
        "n",
        "[c",
        function() require("treesitter-context").go_to_context(vim.v.count1) end,
        { silent = true }
      )
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup({
        ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = true,
      })
    end,
  },
}
-- vim: set fdl=2 fdm=expr:
