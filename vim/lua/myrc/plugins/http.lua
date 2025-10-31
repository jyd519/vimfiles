return {
  {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
  {
    -- https://neovim.getkulala.net/docs/getting-started/configuration-options/
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      default_env = "dev",
      global_keymaps_prefix = "<leader>k",
      kulala_keymaps_prefix = "",
      global_keymaps = {
        ["Send all requests"] = {
          "<leader>ka",
          function()
            vim.ui.input({ prompt = "Send all requests? (y/n)" }, function(input)
              if input == "y" then require("kulala").run_all() end
            end)
          end,
          mode = { "n", "v" },
        },
        ["Find request"] = {
          "<leader>fr",
          function() require("kulala").search() end,
          mode = { "n", "v" },
        },
      },
      ui = {
        default_winbar_panes = { "body", "headers", "headers_body", "verbose", "script_output", "status", "report" },
      },
      ---@type { [string]: fun():string }
      custom_dynamic_variables = {
        ["$randomEmail"] = function()
          local random = math.random(1000, 9999)
          return "user" .. random .. "@example.com"
        end,
      },
    },
  },
}
