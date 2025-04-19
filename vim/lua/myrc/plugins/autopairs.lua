return {
  {
    "windwp/nvim-autopairs",
    enabled = true,
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        map_cr = false,
        disable_in_visualblock = true,
        fast_wrap = {},
      })
      for _, i in ipairs(npairs.config.rules) do
        i.key_map = nil
      end
    end,
  },
}
