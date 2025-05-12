local system_open = function(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  require("myrc.utils.system").system_open(path)
end

local keymap = vim.keymap.set
keymap("n", "<F3>", "<cmd>Neotree toggle<cr>", { desc = "Toggle neo-tree" })
keymap("n", "<leader>nt", "<cmd>Neotree filesystem reveal<cr>", { desc = "Reveal file in neotree" })
keymap("n", "<leader>nf", "<cmd>Neotree filesystem reveal_force_cwd<cr>", { desc = "Reveal and force cwd" })

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree", "Neotree float", "Neotree reveal" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- hide_root_node = true,
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        -- bind_to_cwd = false,
        -- follow_current_file = { enabled = true },
        -- use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["-"] = "navigate_up",
            ["O"] = "system_open",
          },
        }
      },
      commands = {
        system_open = system_open,
      },
      window = {
        mappings = {
          ["oo"] = "open",
          ["O"] = "system_open",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["<leader>e"] = function() vim.cmd("Neotree focus filesystem left", true) end,
          ["<leader>b"] = function() vim.cmd("Neotree focus buffers left", true) end,
          ["<leader>g"] = function() vim.cmd("Neotree focus git_status left", true) end,
        },
      },
    },
    config = function(_, opts) require("neo-tree").setup(opts) end,
  },
}
