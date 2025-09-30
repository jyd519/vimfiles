local vim = vim
local telescope = require("telescope")
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

telescope.setup({
  defaults = {
    filesize_limit = 2, -- MB
    mappings = {
      n = {
        ["<M-p>"] = action_layout.toggle_preview,
      },
      i = {
        ["<M-p>"] = action_layout.toggle_preview,
        ["<C-u>"] = false
      },
    },
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },

    -- https://github.com/piersolenski/telescope-import.nvim
    import = {
      insert_at_top = true,
    },
  },
  mappings = {
    i = {
      ["<esc>"] = actions.close,
    },
  },
  pickers = {
    buffers = {
      theme = "dropdown",
      previewer = false,
      sort_mru = true,
    },
    find_files = {
      mappings = {
        n = {
          ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            require("telescope.actions").close(prompt_bufnr)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("silent lcd %s", dir))
          end,
        },
      },
    },
    git_branches = {
      mappings = {
        i = {
          ["<CR>"] = function(prompt_bufnr)
            -- get the selected file name
            local entry = require("telescope.actions.state").get_selected_entry()
            -- close telescope
            require("telescope.actions").close(prompt_bufnr)
            -- open diffview
            vim.cmd("DiffviewOpen " .. entry.name)
          end,
        },
      },
    },
    git_commits = {
      mappings = {
        i = {
          ["<CR>"] = function(prompt_bufnr)
            -- get the selected commit hash
            local entry = require("telescope.actions.state").get_selected_entry()
            -- close telescope
            require("telescope.actions").close(prompt_bufnr)
            -- open diffview
            vim.cmd("DiffviewOpen " .. entry.value)
          end,
        },
      },
    },
  },
})

telescope.load_extension("refactoring")
telescope.load_extension("ui-select")
telescope.load_extension("bookmarks")
-- telescope.load_extension("import")
telescope.load_extension("fzf")
telescope.load_extension("projects")
