local system_open = function(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  require("myrc.utils.system").system_open(path)
end

local keymap = vim.keymap.set
keymap("n", "<F3>", "<cmd>Neotree toggle<cr>", { desc = "Toggle neo-tree" })
keymap("n", "<leader>nt", "<cmd>Neotree filesystem reveal<cr>", { desc = "Reveal file in neotree" })
keymap("n", "<leader>nf", "<cmd>Neotree filesystem reveal_force_cwd<cr>", { desc = "Reveal and force cwd" })

local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    previewer = false,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then filename = selection[1] end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    enabled = true,
    cmd = { "Neotree", "Neotree float", "Neotree reveal" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- hide_root_node = true,
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = true,
        cwd_target = {
          sidebar = "tab", -- sidebar is when position = left or right
          current = "window", -- current is when position = current
        },
        -- follow_current_file = { enabled = true },
        -- use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["-"] = "navigate_up",
            ["O"] = "system_open",
            ["/"] = "noop",
            ["f"] = "noop",
            ["ff"] = "telescope_find",
          },
        },
      },
      commands = {
        system_open = system_open,
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path
          if node.type == "file" then
            path = node:get_parent_id()
          else
            path = node:get_id()
          end

          require("telescope.builtin").find_files(getTelescopeOpts(state, path))
        end,
      },
      window = {
        mappings = {
          ["o"] = "noop",
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
  {
    "nvim-tree/nvim-tree.lua",
    cond = false,
    event = "VeryLazy",
    version = "*",
    config = function()
      local function nvim_tree_on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end
      require("nvim-tree").setup({
        on_attach = nvim_tree_on_attach,
        view = { width = 40 },
        renderer = {
          root_folder_label = function(path)
            path = path:gsub(vim.loop.os_homedir(), "~", 1)
            return path:gsub("([a-zA-Z])[a-z]+", "%1") .. path:gsub(".*[^a-zA-Z].?", "")
          end,
        },
        filters = { dotfiles = true },
      })
      vim.keymap.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })
      vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<cr>", { desc = "Find File in NvimTree" })
      vim.keymap.set("n", "<leader>nF", ":NvimTreeFindFile!<cr>", { desc = "Find File in NvimTree" })
    end,
  },
}
