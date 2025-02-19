local vim, g, api, fn = vim, vim.g, vim.api, vim.fn
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local telescope = require("telescope")
local previewers = require("telescope.previewers")

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}
  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

telescope.setup({
  defaults = {
    buffer_previewer_maker = new_maker,
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
          -- ["h"] =  function(prompt_bufnr)
          --   -- https://github.com/nvim-telescope/telescope.nvim/issues/2016
          --   -- local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
          --   -- put(current_picker)
          --   -- local opts = {
          --   --   hidden = true,
          --   --   default_text = current_picker:_get_prompt(),
          --   --   -- TODO: copy other relevant state :/
          --   -- }
          --   --
          --   -- require("telescope.actions").close(prompt_bufnr)
          --   -- require("telescope.builtin").find_files(opts)
          -- end
        },
      }
    },
  },
})

telescope.load_extension("refactoring")
telescope.load_extension("ui-select")
telescope.load_extension("bookmarks")
telescope.load_extension("import")
telescope.load_extension("fzf")
telescope.load_extension("projects")
