require("nvim-surround").setup({
  indent_lines = false,
  surrounds = {
    ["f"] = {
      add = function()
        return { { "💥" }, { "💥" } }
      end,
    },
  },
})
