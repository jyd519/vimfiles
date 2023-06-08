local vim, g, api, fn = vim, vim.g, vim.api, vim.fn
local actions = require("telescope.actions")
local nvim_set_keymap = vim.api.nvim_set_keymap

local telescope = require("telescope")
telescope.setup({
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
  },
  mappings = {
    i = {
      ["<esc>"] = actions.close,
    },
  },
  pickers = {
    find_files = {},
    buffers = {
      theme = "dropdown",
      previewer = false,
      sort_mru = true,
    },
  },
})

telescope.load_extension("ui-select")
telescope.load_extension("bookmarks")

-- nvim_set_keymap(
--     "n",
--     "<leader>xa",
--     ':lua require"telescope.builtin".diagnostics{}<CR>',
--     {noremap = true, silent = true, desc = "Show all diagnostics"}
-- )
-- nvim_set_keymap(
--     "n",
--     "<leader>xb",
--     ':lua require"telescope.builtin".diagnostics{bufnr=0}<CR>',
--     {noremap = true, silent = true, desc = "Show buffer diagnostics"}
-- )
nvim_set_keymap(
  "n",
  "<leader>qf",
  ':lua require"telescope.builtin".quickfix{bufnr=0}<CR>',
  { noremap = true, silent = true, desc = "Quickfix" }
)

nvim_set_keymap(
  "n",
  "<leader>sb",
  ':lua require("telescope").extensions.bookmarks.list{bufnr=0}<CR>',
  { noremap = true, silent = true, desc = "List bookmarks" }
)

vim.keymap.set("n", "<leader>fg", function()
  local opts = {}
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end, { desc = "Find in git files" })

vim.keymap.set("n", "<leader>b", function()
  require("telescope.builtin").buffers({})
end, { desc = "List buffers" })

vim.cmd([[com! Maps :Telescope keymaps]])

-- integrate with t.vim
vim.api.nvim_create_user_command("Ft", function(opts)
  local find_opts = {
    prompt_title = "Find a template",
    layout_config = {
      prompt_position = "top",
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
vim.cmd([[nnoremap <leader>st :Ft<CR>]])

-- browse my notes
if g.notes_dir then
  api.nvim_create_user_command("Notes", function(opts)
    local find_opts = {}
    if vim.fn.executable("rg") then
      find_opts["find_command"] = { "rg", "--files", "--smart-case", "--glob", "!.git/*", "--glob", "*.md" }
    elseif vim.fn.executable("fd") then
      find_opts["find_command"] = { "fd", "--type f", "--strip-cwd-prefix", ".md$" }
    end
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
    complete = function()
      return fn.map(fn.globpath(g.notes_dir, "*", 0, 1), "v:val[len(g:notes_dir)+1:]")
    end,
    desc = "Find and view notes",
  })
end
vim.cmd([[
   nnoremap <leader>fn :Notes<CR>
]])
