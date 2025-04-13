-- Globals {{{2
local vim = vim
local keymap = vim.keymap
keymap.amend = prequire("keymap-amend")

vim.g.enable_inlay_hint = true
-- }}}

-- General {{{2
--
-- Quick switch to normal mode
vim.keymap.set('i', 'jj', '<ESC>', { noremap = true })
-- Insert a blank line
vim.keymap.set('i', '<C-Return>', '<CR><CR><C-o>k<Tab>"', { noremap = true })

-- Quick editing myvimrc
vim.keymap.set('n', '<leader>ei', ':e! <C-r>=g:myinitrc<CR><CR>', { noremap = true })
vim.keymap.set('n', '<leader>ev', ':e! $MYVIMRC<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ss', ':source %<cr>', { noremap = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-j>', '<C-W>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-W>k', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-W>h', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-W>l', { noremap = true })

-- Tab management
vim.keymap.set('n', '<leader>tn', ':tabnew %<cr>', { noremap = true })
vim.keymap.set('n', '<leader>tc', ':tabclose<cr>', { noremap = true })
vim.keymap.set('n', '<leader>tm', ':tabmove', { noremap = true })

-- Switch to current dir
vim.keymap.set('n', '<leader>CD', ':lcd %:p:h<cr>:pwd<cr>', { noremap = true })

-- Delete current line without yanking the line breaks
vim.keymap.set('n', 'dil', '^d$', { noremap = true })
-- Yank current line without the line breaks
vim.keymap.set('n', 'yil', '^y$', { noremap = true })
vim.keymap.set('v', 'p', '"_dP', { noremap = true })

-- Move to begin of line / end to line
vim.keymap.set('i', '<C-e>', '<Esc>A', { noremap = true })
vim.keymap.set('i', '<C-a>', '<Esc>I', { noremap = true })
vim.keymap.set('c', '<C-a>', '<C-b>', { noremap = true })

-- Ctrl-V Paste from clipboard
if vim.fn.has("mac") == 0 then
  vim.keymap.set('c', '<C-V>', '<c-r>+', { noremap = true })
  vim.keymap.set('i', '<C-V>', '<c-r>+', { noremap = true })
end

-- Editing a protected file as 'sudo'
vim.api.nvim_create_user_command('W', 'w !sudo tee % > /dev/null', { bang = true })

-- Open with browser
if vim.fn.has("win32") == 1 then
  vim.keymap.set('n', '<leader>o', ':update<cr>:silent !start chrome.exe "file://%:p"<cr>', { noremap = true })
end
if vim.fn.has("mac") == 1 then
  vim.keymap.set('n', '<leader>o', ':update<cr>:silent !open -a "Google Chrome" "%:p"<cr>:redraw!<cr>', { noremap = true })
end

-- Terminal
-- to exit terminal-mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = true })
vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = true })
vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = true })
vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = true })
-- Search for visually selected text
vim.keymap.set('v', '*', function() require('misc').SearchVisualTextDown() end, { silent = true, noremap = true })
vim.keymap.set('v', '#', function() require('misc').SearchVisualTextUp() end, { silent = true, noremap = true })

-- Zoom / Restore window
vim.api.nvim_create_user_command('ZoomToggle', function() require('misc').ZoomToggle() end, {})
vim.keymap.set('n', '<leader>z', function() require('misc').ZoomToggle() end, { silent = true, noremap = true })

-- quickfix
vim.keymap.set('n', '<F2>', function() require('qf').ToggleQuickFix() end, { silent = true, noremap = true })
vim.keymap.set('n', '<S-F2>', function() require('qf').ToggleLocationList() end, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>xq', function() require('qf').ToggleQuickFix() end, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>xl', function() require('qf').ToggleLocationList() end, { silent = true, noremap = true })

-- enable osc52 copying for remote ssh connection
if vim.env.SSH_CONNECTION ~= "" and vim.g.is_vim then
  vim.keymap.set('n', '<leader>y', '<Plug>OSCYankVisual', { noremap = true })
end

-- Font zoom in/out
vim.keymap.set('n', '<C-=>', function() require('zoom').ZoomIn() end, { silent = true, noremap = true })
vim.keymap.set('n', '<C-->', function() require('zoom').ZoomOut() end, { silent = true, noremap = true })

-- aes-vim
vim.keymap.set('v', '<leader>ec', ':AesEnc<cr>', { noremap = true })
vim.keymap.set('n', '<leader>ed', ':AesDec<cr>', { noremap = true })

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

-- {{{2 Telescope Mappings
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
  { noremap = true, desc = "Refactoring" }
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
  { silent = true, desc = "Find Files" }
)
vim.keymap.set(
  "n",
  "<leader>f.",
  function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end,
  { silent = true, desc = "Find Files in current directory" }
)
vim.keymap.set(
  "n",
  "<leader>fw",
  function() require("telescope.builtin").grep_string({}) end,
  { silent = true, desc = "Grep the current word" }
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
end, { desc = "Find projects" })

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

vim.keymap.set(
  "n",
  "<leader>fd",
  function()
    require("telescope.builtin").find_files({
      cwd = table.concat({ vim.g.VIMFILES, "doc" }, "/"),
    })
  end,
  { desc = "Find vim docs" }
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
        local actions = require("telescope.actions")
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
  vim.keymap.set("n", "<leader>ft", "<cmd>Ft<cr>", { desc = "Find templates" })
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
    complete = function() return vim.fn.map(vim.fn.globpath(vim.g.notes_dir, "*", false), "v:val[len(g:notes_dir)+1:]") end,
    desc = "Find and view notes",
  })
  vim.keymap.set("n", "<leader>fn", "<cmd>Notes<cr>", { desc = "Find notes" })
end

-- Live grep
vim.api.nvim_create_user_command("Grep", function(args)
  local builtin = require("telescope.builtin")
  if args.args ~= "" then
    builtin.grep_string({ search = args.args })
  else
    builtin.live_grep()
  end
end, {
  nargs = "*",
  desc = "Live grep",
})

-- }}}

-- Lsp formatting {{{2
vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format({ async = true }) end, {
  desc = "Format the current buffer",
})
vim.api.nvim_create_user_command("InlayHintToggle", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = vim.api.nvim_get_current_buf() }))
  if vim.lsp.inlay_hint.is_enabled() then
    vim.g.enable_inlay_hint = true
    vim.notify("Inlay hints disabled", vim.log.levels.INFO, { title = "LSP" })
  else
    vim.g.enable_inlay_hint = false
    vim.notify("Inlay hints enabled", vim.log.levels.INFO, { title = "LSP" })
  end
end, {
  desc = "Toggle LSP Inlay-Hint",
})
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
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if not vim.tbl_isempty(clients) then
    vim.cmd("LspStop")
  else
    vim.cmd("LspStart")
    vim.notify("Starting LSP Server", vim.log.levels.INFO, { title = "LSP" })
  end
end

local start_lsp_client = function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
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
vim.keymap.set("n", "<leader>li", "<cmd>InlayHintToggle<cr>", { desc = "Toggle Inlay Hint" })
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
vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set location list" })
-- vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
vim.keymap.set("n", "]h", diagnostic_goto(true, "HINT"), { desc = "Next Hint" })
vim.keymap.set("n", "[h", diagnostic_goto(false, "HINT"), { desc = "Prev Hint" })
--}}}

-- Window related {{{2
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Split Window
vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
-- }}}

-- Make {{{2
vim.api.nvim_create_user_command(
  "Make",
  function(opts) require("myrc.utils.term_run").gulp(opts.fargs) end,
  { nargs = "*", desc = "Run Build Tools" }
)
--}}}

-- AI {{{2
-- https://github.com/olimorris/codecompanion.nvim
vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI assistant" })
vim.api.nvim_set_keymap("v", "<leader>ae", "", {
  desc = "Explain code",
  callback = function() require("codecompanion").prompt("explain") end,
  noremap = true,
  silent = true,
})
vim.api.nvim_set_keymap(
  "n",
  "<leader>al",
  "<cmd>CodeCompanionActions<cr>",
  { desc = "AI Actions", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>al",
  "<cmd>CodeCompanionActions<cr>",
  { desc = "AI Actions", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>am",
  "<cmd>CodeCompanionChat Add<cr>",
  { desc = "AI Chat Add", noremap = true, silent = true }
)
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ccc CodeCompanionChat]])
--}}}

-- Cancel search highlighting {{{2
if keymap.amend then
  keymap.amend("n", "<Esc>", function(original)
    if vim.v.hlsearch and vim.v.hlsearch == 1 then
      vim.cmd("nohlsearch")
    end
    original()
  end, { desc = "disable search highlight" })
end
-- }}}

-- Lookup ansible-doc {{{2
vim.api.nvim_create_user_command("Adoc", function(args)
  vim.cmd(
    "new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |" .. "r !ansible-doc " .. args.args .. ""
  )
  vim.defer_fn(function()
    vim.cmd('exec "norm ggM"')
  end, 100)
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

-- Lsp formatting {{{2
vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format({ async = true })
end, {
  desc = "Format the current buffer",
})
-- }}}

if vim.g.enabled_plugins.tmux == 1 then
  vim.keymap.set('n', '<c-h>', ':TmuxNavigateLeft<cr>', { silent = true })
  vim.keymap.set('n', '<c-j>', ':TmuxNavigateDown<cr>', { silent = true })
  vim.keymap.set('n', '<c-k>', ':TmuxNavigateUp<cr>', { silent = true })
  vim.keymap.set('n', '<c-l>', ':TmuxNavigateRight<cr>', { silent = true })
end

vim.keymap.set('n', '<leader>L', '<Plug>(ale_lint)', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>xF', '<Plug>(ale_fix)', { noremap = true, silent = false })

vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")

vim.cmd("tnoremap <C-o> <C-\\><C-n>")

-- Fast Search
if vim.fn.executable('rg') == 1 then
  -- Use rg over grep
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case --hidden'
  vim.opt.grepformat = '%f:%l:%c%m'

  -- Ag command
  vim.api.nvim_create_user_command('Ag', function(args)
    vim.cmd('silent! grep! ' .. args.args .. '|cwindow|redraw!')
  end, { nargs = '*', complete = 'file', bar = true })

  -- Jump to definition under cursor
  vim.keymap.set('n', 'gs', ':Rg <C-R><C-W><CR>', { silent = true })
elseif vim.fn.executable('ag') == 1 then
  -- Use ag over grep
  vim.opt.grepprg = 'ag --vimgrep $*'
  vim.opt.grepformat = '%f:%l:%c%m'

  -- Ag command
  vim.api.nvim_create_user_command('Ag', function(args)
    vim.cmd('silent! grep! ' .. args.args .. '|cwindow|redraw!')
  end, { nargs = '*', complete = 'file', bar = true })

  -- Jump to definition under cursor
  vim.keymap.set('n', 'gs', ':Ag <cword><CR>', { silent = true })
end

-- Trailing whitespace and tabs are forbidden, so highlight them.
vim.cmd([[
  highlight ForbiddenWhitespace ctermbg=red guibg=red
]], false)

vim.api.nvim_create_augroup("TrailingSpace", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "TrailingSpace",
  pattern = { "python", "c", "sh", "javascript", "typescript", "vim", "lua" },
  callback = function()
    vim.cmd("match ForbiddenWhitespace /\\s\\+$/")
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "TrailingSpace",
  pattern = { "python", "c", "cpp", "sh", "javascript", "typescript" },
  callback = function()
    vim.cmd("autocmd BufWritePre * :call TrimTrailingWhitespaces()")
  end,
})

local function show_spaces(arg)
  vim.cmd("let @/='\\v(\\s+$)|( +\\ze\\t)'")
  local old_hlsearch = vim.o.hlsearch
  if arg == nil then
    vim.o.hlsearch = not vim.o.hlsearch
  else
    vim.o.hlsearch = arg
  end
  return old_hlsearch
end

local function trim_trailing_whitespaces(firstline, lastline)
  local old_hlsearch = show_spaces(true)
  vim.cmd(firstline .. "," .. lastline .. "substitute /\\s\\+$//ge")
  vim.o.hlsearch = old_hlsearch
end

vim.api.nvim_create_user_command("ShowSpaces", function(opts)
  if (opts.args == "") then
    show_spaces(nil)
  else
    show_spaces(opts.args == "1")
  end
end, { nargs = "?" })

vim.api.nvim_create_user_command("TrimSpaces", function(opts)
  trim_trailing_whitespaces(opts.line1, opts.line2)
end, { range = true, nargs = 0 })

-- vim: set fdm=marker fdl=1: }}}
