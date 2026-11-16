return {
  { "thinca/vim-quickrun", cmd = { "QuickRun" } },
  {
    "jyd519/vim-test", -- Unit-Testing
    enabled = vim.g.enabled_plugins.test == 1,
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      local g = vim.g
      g.test_strategy = "neovim"
      g.test_neovim_start_normal = 0
      g.test_javascript_runner = "jest"
      g.test_python_djangotest_options = "--keepdb"
      g.test_rust_cargotest_options = "-- --nocapture"
      g.test_go_test_options = "-v"

      vim.g["test#custom_strategies"] = {
        capture = function(cmd)
          vim.g.last_test_cmd = cmd
          vim.fn.setreg("+", cmd)
          print("Test command: " .. cmd)
        end,
      }
    end,
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
