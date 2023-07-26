require("nvim-surround").setup({
  indent_lines = false,
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
