require("nvim-surround").setup({
  keymaps = {
    insert = false,
    insert_line = false,
  },
  surrounds = {
    ["f"] = {
      add = function()
        return { { "💥" }, { "💥" } }
      end,
    },
  },
})
