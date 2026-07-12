local g, fn = vim.g, vim.fn

return {
  {
    -- https://github.com/ibhagwan/fzf-lua
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      local actions = fzf.actions
      fzf.setup({
        fzf_opts = { ["--layout"] = "reverse-list" },
        actions = {
          files = {
            -- instead of the default action 'actions.file_edit_or_qf'
            -- it's important to define all other actions here as this
            -- table does not get merged with the global defaults
            ["default"] = actions.file_edit,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["ctrl-q"] = actions.file_sel_to_qf,
          },
        },
      })
    end,
  },
}
