return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      -- patch layout preview width
      require("snacks.picker.config.layouts")["telescope"]["layout"][2]["width"] = 0.5
      require("snacks").setup(opts)
    end,
    keys = {
      { "<leader>fm", function() Snacks.picker.marks() end, desc = "Find Marks" },
      {
        "<leader>ff",
        function() Snacks.picker.files({ layout = { hidden = { "preview" } } }) end,
        desc = "Find Files",
      },
    },
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
      layout = {
        width = 0.9,
      },
      notifier = {
        enabled = true,
        timeout = 3000, -- timeout in ms
        style = "fancy", -- options: "compact", "minimal", or "fancy" (resembles nvim-notify)
      },
      picker = {
        layout = {
          cycle = true,
          preset = function() return vim.o.columns >= 120 and "telescope" or "vertical" end,
        },
        win = {
          input = {
            keys = {
              ["<M-p>"] = { "toggle_preview", mode = { "n", "i" } },
            },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end

          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
