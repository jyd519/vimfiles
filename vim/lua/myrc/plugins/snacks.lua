return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      -- patch layout preview width
      require("snacks.picker.config.layouts")["telescope"]["layout"][2]["width"]=0.5
      require("snacks").setup(opts)
    end,
    keys = {
      { "<leader>ff", function() Snacks.picker.files({ layout = { hidden = { "preview" } } }) end, desc = "Find Files" },
    },
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
      layout = {
        width = 0.9
      },
      picker = {
        layout = {
          cycle = true,
          preset = function()
            return vim.o.columns >= 120 and "telescope" or "vertical"
          end,
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
  },
}
