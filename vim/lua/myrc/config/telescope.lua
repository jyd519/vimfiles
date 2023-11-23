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
-- telescope.load_extension("fzf")

vim.keymap.set(
  "n",
  "<leader>xa",
  ':lua require"telescope.builtin".diagnostics{}<CR>',
  { silent = true, desc = "Show all diagnostics" }
)

vim.keymap.set(
  "n",
  "<leader>xb",
  ':lua require"telescope.builtin".diagnostics{bufnr=0}<CR>',
  { silent = true, desc = "Show buffer diagnostics" }
)

vim.keymap.set(
  "v",
  "<leader>rf",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true, desc = "refactoring" }
)

vim.keymap.set(
  "n",
  "<leader>fx",
  ':lua require"telescope.builtin".quickfix{bufnr=0}<CR>',
  { silent = true, desc = "Find in Quickfix" }
)

vim.keymap.set(
  "n",
  "<leader>fm",
  function() require("telescope").extensions.bookmarks.list({ bufnr = 0 }) end,
  { silent = true, desc = "Find in bookmarks" }
)

vim.keymap.set(
  "n",
  "<leader>ff",
  function() builtin.find_files({ previewer = false }) end,
  { silent = true, desc = "find files" }
)

vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find in oldfiles" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find in git files" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find lsp symbols" })
vim.keymap.set("n", "<leader>fi", builtin.lsp_implementations, { desc = "Find lsp implementations" })

vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Select colorscheme" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "List buffers" })

vim.keymap.set(
  "n",
  "<leader>fv",
  function()
    builtin.find_files({
      cwd = vim.g.VIMFILES,
    })
  end,
  { desc = "Find vimfiles" }
)

vim.cmd([[com! Maps :Telescope keymaps]])

-- integrate with t.vim
if vim.g.mysnippets_dir then
  vim.api.nvim_create_user_command("Ft", function(opts)
    local find_opts = {
      prompt_title = "Find a template",
      layout_config = {
        -- prompt_position = "top",
        width = 0.80,
        height = 0.60,
        preview_cutoff = 120,
        horizontal = { mirror = false },
        vertical = { mirror = false },
      },
      attach_mappings = function()
        local action_state = require("telescope.actions.state")
        actions.select_default:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local file = selection.cwd .. "/" .. selection[1]
          vim.cmd("read " .. file)
        end)
        return true
      end,
    }
    local dir = vim.g.mysnippets_dir
    local ft = vim.o.filetype
    if ft == "" or opts.args == "a" or opts.args == "all" then
      find_opts["cwd"] = dir
    else
      if vim.fn.isdirectory(dir .. "/" .. ft) == 1 then
        find_opts["cwd"] = dir .. "/" .. ft
      else
        find_opts["cwd"] = dir
      end
    end
    require("telescope.builtin").find_files(find_opts)
  end, {
    nargs = "*",
    desc = "Select a template to use",
  })
  vim.keymap.set("n", "<leader>ft", "<cmd>Ft<cr>", { desc = "Find in templates" })
end

-- browse my notes
if g.notes_dir then
  api.nvim_create_user_command("Notes", function(opts)
    local find_opts = {}
    local cwd = vim.g.notes_dir
    if vim.fn.isdirectory(cwd .. "/" .. opts.args) == 1 then
      find_opts["cwd"] = cwd .. "/" .. opts.args
    else
      find_opts["cwd"] = cwd
      find_opts["search_file"] = opts.args
    end
    require("telescope.builtin").find_files(find_opts)
  end, {
    nargs = "*",
    complete = function() return fn.map(fn.globpath(g.notes_dir, "*", 0), "v:val[len(g:notes_dir)+1:]") end,
    desc = "Find and view notes",
  })

  vim.keymap.set("n", "<leader>fn", "<cmd>Notes<cr>", { desc = "Find in notes" })
end
