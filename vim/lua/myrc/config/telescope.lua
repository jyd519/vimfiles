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
  },
})

telescope.load_extension("refactoring")
telescope.load_extension("ui-select")
telescope.load_extension("bookmarks")
telescope.load_extension("import")
telescope.load_extension("fzf")
