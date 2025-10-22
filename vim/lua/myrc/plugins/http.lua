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
    keys = {
      -- { "<leader>rs", desc = "Send request" },
      { "<leader>ka", desc = "Send all requests" },
      { "<leader>kb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      default_env = "dev",
      global_keymaps = true,
      global_keymaps_prefix = "<leader>k",
      kulala_keymaps_prefix = "",
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
