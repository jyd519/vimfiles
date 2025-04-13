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

      -- vim.keymap.set(
      --   "n",
      --   "<leader>ff",
      --   function() fzf.files({ cwd_prompt = false, prompt = "Files> " }) end,
      --   { desc = "[F]ile [F]ind" }
      -- )
      --
      -- vim.keymap.set(
      --   "n",
      --   "<leader>ff",
      --   function()
      --     require("fzf-lua").files({
      --       cwd_prompt = false,
      --       prompt = "Files> ",
      --       fzf_opts = { ["--layout"] = "reverse-list" },
      --     })
      --   end,
      --   { desc = "Fuzzy Find Files" }
      -- )
      --
      -- vim.keymap.set(
      --   "n",
      --   "<leader>ft",
      --   function()
      --     require("fzf-lua").files({
      --       cwd_prompt = false,
      --       prompt = "Templates> ",
      --       fzf_opts = { ["--layout"] = "reverse-list" },
      --       cwd = vim.g.mysnippets_dir,
      --     })
      --   end,
      --   { desc = "Fuzzy Find Templates" }
      -- )
      --
      -- vim.keymap.set("n", "<leader>fm", require("fzf-lua").marks, { desc = "Fuzzy Find Marks" })
      -- vim.keymap.set("n", "<leader>fo", require("fzf-lua").oldfiles, { desc = "Fuzzy Find Old Files" })
      -- vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Fuzzy Find Buffers" })
      -- vim.keymap.set("n", "<leader>fx", require("fzf-lua").quickfix, { desc = "Fuzzy Find Quickfix" })
      -- vim.keymap.set("n", "<leader>fl", require("fzf-lua").loclist, { desc = "Fuzzy Find Loclist" })
      -- vim.keymap.set("n", "<leader>fg", require("fzf-lua").git_files, { desc = "Fuzzy Find Git Files" })
      -- vim.keymap.set(
      --   "n",
      --   "<leader>fs",
      --   require("fzf-lua").lsp_document_symbols,
      --   { desc = "Fuzzy Find LSP Document Symbols" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>fn",
      --   function()
      --     fzf.files({
      --       cwd_prompt = false,
      --       cmd = 'rg --files --hidden --smart-case ---glob "*.md"',
      --       cwd = vim.g.notes_dir,
      --     })
      --   end,
      --   { desc = "Fuzzy Find Notes" }
      -- )
    end,
  },
}
