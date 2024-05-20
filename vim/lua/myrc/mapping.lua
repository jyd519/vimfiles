-- Globals {{{2
local vim = vim
local keymap = vim.keymap
keymap.amend = prequire("keymap-amend")
local function augroup(name) return vim.api.nvim_create_augroup("myrc_" .. name, { clear = true }) end
-- }}}

-- Cancel search highlighting {{{2
if keymap.amend then
  keymap.amend("n", "<Esc>", function(original)
    if vim.v.hlsearch and vim.v.hlsearch == 1 then vim.cmd("nohlsearch") end
    original()
  end, { desc = "disable search highlight" })
end
-- }}}

-- Lookup ansible-doc {{{2
vim.api.nvim_create_user_command("Adoc", function(args)
  vim.cmd(
    "new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |" .. "r !ansible-doc " .. args.args .. ""
  )
  vim.defer_fn(function() vim.cmd('exec "norm ggM"') end, 100)
end, {
  nargs = "+",
  desc = "Lookup ansible document",
})
-- }}}

-- Toggle Dark-Mode{{{2
vim.api.nvim_create_user_command("Dark", function(args)
  if vim.env.LC_TERMINAL ~= "iTerm2" then
    if vim.o.background == "light" then
      vim.o.background = "dark"
    else
      vim.o.background = "light"
    end
    return
  end
  --  Switch iTerm2 profile based on light/dark mode
  if vim.o.background == "light" then
    vim.o.background = "dark"
    vim.loop.fs_write(2, "\27Ptmux;\27\27]1337;SetProfile=Default-dark\7\27\\", -1)
  else
    vim.o.background = "light"
    vim.loop.fs_write(2, "\27Ptmux;\27\27]1337;SetProfile=Default\7\27\\", -1)
  end
end, {
  desc = "Toggle dark mode",
})
vim.api.nvim_set_keymap("n", "<leader>td", "<cmd>Dark<CR>", { noremap = true })
-- }}}

-- Handling large file{{{2
-- https://www.reddit.com/r/neovim/comments/z85s1l/disable_lsp_for_very_large_files/
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    vim.b.large_buf = false
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    if vim.fn.fnamemodify(bufname, ":e") == "log" then
      if vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) > 200000 then
        vim.b.large_buf = true
        vim.b.copilot_enabled = false
        vim.b.codeium_enabled = false
        vim.opt.foldmethod = "manual"
        vim.opt.spell = false
      end
      return
    end
    local ok, stats = pcall(vim.loop.fs_stat, bufname)
    if ok and stats and (stats.size > 1000000) then
      vim.b.large_buf = true
      vim.cmd("syntax off")
      vim.g.indent_blankline_enabled = false
      vim.b.copilot_enabled = false
      vim.b.codeium_enabled = false
      vim.opt.foldmethod = "manual"
      vim.opt.spell = false
    end
  end,
  group = augroup("large_buf"),
  pattern = "*",
})
-- }}}

-- Lsp formatting {{{2
vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format({ async = true }) end, {
  desc = "Format the current buffer",
})
-- }}}

-- Close some filetypes with <q> {{{2
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
-- }}}

-- {{{2 Telescope
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
  function() require("telescope.builtin").find_files({ previewer = false }) end,
  { silent = true, desc = "find files" }
)

vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find in oldfiles" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find in git files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find lsp symbols" })
vim.keymap.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find lsp implementations" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Select colorscheme" })
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })
vim.keymap.set("n", "<leader>fp", function()
  require("lazy").load({ plugins = { "project.nvim" } })
  vim.schedule(function() vim.cmd("Telescope projects") end)
end, { desc = "Find Project" })


vim.keymap.set(
  "n",
  "<leader>fv",
  function()
    require("telescope.builtin").find_files({
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
if vim.g.notes_dir then
  vim.api.nvim_create_user_command("Notes", function(opts)
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
    complete = function() return vim.fn.map(vim.fn.globpath(vim.g.notes_dir, "*", 0), "v:val[len(g:notes_dir)+1:]") end,
    desc = "Find and view notes",
  })
  vim.keymap.set("n", "<leader>fn", "<cmd>Notes<cr>", { desc = "Find in notes" })
end
-- }}}

-- {{{2 Toggle Treesitter
vim.keymap.set("n", "<leader>ts", function()
  ---@diagnostic disable: undefined-field
  if vim.b.ts_highlight then
    print("treesitter: off")
    vim.treesitter.stop()
  else
    print("treesitter: on")
    vim.treesitter.start()
  end
end, { desc = "Toggle treesitter" })
-- }}}

-- {{{2 Toggle Symbols Outline
vim.keymap.set("n", "<leader>to", function()
  local outline = require("outline")
  outline.toggle_outline()
end, { desc = "Toggle Symbols Outline" })
--- }}}

--Toggle LSP{{{2
local toggle_lsp_client = function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  if not vim.tbl_isempty(clients) then
    vim.cmd("LspStop")
  else
    vim.cmd("LspStart")
    vim.notify("Starting LSP Server", vim.log.levels.INFO, { title = "LSP" })
  end
end

local start_lsp_client = function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  if not vim.tbl_isempty(clients) then
    vim.cmd("LspRestart")
    vim.notify("Restarting LSP Server", vim.log.levels.INFO, { title = "LSP" })
  else
    vim.cmd("LspStart")
    vim.notify("Starting LSP Server", vim.log.levels.INFO, { title = "LSP" })
  end
end

vim.keymap.set("n", "<leader>lt", toggle_lsp_client, { desc = "Toggle LSP server" })
vim.keymap.set("n", "<leader>lr", start_lsp_client, { desc = "Start/Restart LSP Server" })
--- }}}

-- Supper K {{{2
local function show_documentation()
  local fn = vim.fn
  if dap and dap.session() then
    require("dapui").eval()
  else
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "markdown" }, filetype) then
      local clients = { "Vim", "Man" }
      vim.ui.select(clients, {
        prompt = "Select a action:",
        format_item = function(client) return string.lower(client) end,
      }, function(item)
        if item == "Vim" then
          vim.cmd("h " .. fn.expand("<cword>"))
        elseif item == "Man" then
          vim.cmd("Man " .. fn.expand("<cword>"))
        end
      end)
      return
    end

    if vim.tbl_contains({ "vim", "help" }, filetype) then
      ---@diagnostic disable-next-line: missing-parameter
      vim.cmd("h " .. fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
      ---@diagnostic disable-next-line: missing-parameter
      vim.cmd("Man " .. fn.expand("<cword>"))
    ---@diagnostic disable-next-line: missing-parameter
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
      require("crates").show_popup()
    elseif filetype == "rust" then
      vim.cmd("RustHoverActions")
    else
      vim.lsp.buf.hover()
    end
  end
end

vim.keymap.set("n", "K", show_documentation, { desc = "show document for underline word" })
-- }}}

-- Diagnostic navigation{{{2
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set location list" })
--}}}

-- Make {{{2
vim.api.nvim_create_user_command(
  "Make",
  function(opts) require("myrc.utils.term_run").gulp(opts.fargs) end,
  { nargs = "*", desc = "Run Build Tools" }
)
--}}}

-- vim: set fdm=marker fdl=1: }}}
