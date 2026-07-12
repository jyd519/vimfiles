return {
  { "thinca/vim-quickrun", cmd = { "QuickRun" } },
  {
    "jyd519/vim-test", -- Unit-Testing
    enabled = vim.g.enabled_plugins.test == 1,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local autocmd = vim.api.nvim_create_autocmd
      local testg = vim.api.nvim_create_augroup("test", { clear = true })

      -- vim-test
      autocmd("FileType", {
        pattern = { "javascript", "typescript", "go", "rust", "python" },
        group = testg,
        callback = function()
          vim.keymap.set("n", "<leader>rt", ":TestNearest<cr>", { buffer = true, silent = true })
          vim.keymap.set("n", "<leader>tt", ":TestNearest<cr>", { buffer = true, silent = true })
        end,
      })

      autocmd("FileType", {
        pattern = { "javascript", "typescript", "go", "python" },
        group = testg,
        callback = function() vim.keymap.set("n", "<leader>tf", ":TestFile<cr>", { buffer = true, silent = true }) end,
      })
    end,
  },
}
