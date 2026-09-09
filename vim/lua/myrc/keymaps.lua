-- Globals {{{2
local vim = vim
local keymap = vim.keymap
-- }}}

-- General {{{2
-- Insert a blank line
vim.keymap.set("i", "<C-Return>", '<CR><CR><C-o>k<Tab>"', { noremap = true })

-- Quick editing myvimrc
vim.keymap.set("n", "<leader>ei", ":e! $MYVIMRC<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ev", ":e! <C-r>=g:myinitrc<CR><CR>", { noremap = true })
vim.keymap.set("n", "<leader>ss", ":source %<cr>", { noremap = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-j>", "<C-W>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-W>k", { noremap = true })
vim.keymap.set("n", "<C-h>", "<C-W>h", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-W>l", { noremap = true })

-- Tab management
vim.keymap.set("n", "<leader>tn", ":tabnew %<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { noremap = true })
vim.keymap.set("n", "<leader>tm", ":tabmove", { noremap = true })

-- Switch to current dir
vim.keymap.set("n", "<leader>cd", ":lcd %:p:h<cr>:pwd<cr>", { noremap = true, desc = "Change current dir to file dir" })

-- Delete current line without yanking the line breaks
vim.keymap.set("n", "dil", "^d$", { noremap = true })
-- Yank current line without the line breaks
vim.keymap.set("n", "yil", "^y$", { noremap = true })
vim.keymap.set("v", "p", '"_dP', { noremap = true })

-- Move to begin of line / end to line
vim.keymap.set("i", "<C-e>", "<Esc>A", { noremap = true })
vim.keymap.set("i", "<C-a>", "<Esc>I", { noremap = true })
vim.keymap.set("c", "<C-a>", "<C-b>", { noremap = true })

-- Ctrl-V Paste from clipboard
if vim.fn.has("mac") == 0 then
  vim.keymap.set("c", "<C-V>", "<c-r>+", { noremap = true })
  vim.keymap.set("i", "<C-V>", "<c-r>+", { noremap = true })
end

-- Open with browser
if vim.fn.has("win32") == 1 then
  vim.keymap.set("n", "<leader>o", ':update<cr>:silent !start chrome.exe "file://%:p"<cr>', { noremap = true })
end
if vim.fn.has("mac") == 1 then
  vim.keymap.set(
    "n",
    "<leader>o",
    ':update<cr>:silent !open -a "Google Chrome" "%:p"<cr>:redraw!<cr>',
    { noremap = true }
  )
end

-- Terminal
-- to exit terminal-mode
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true }) -- conflict with lazygit
vim.keymap.set("t", "<C-o>", "<C-\\><C-N>", { noremap = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { noremap = true })
vim.keymap.set("t", "<C-v>", '<C-\\><C-n>"+Pi', { noremap = true })
vim.keymap.set("t", "<sc-v>", '<C-\\><C-n>"+Pi', { noremap = true })

-- Zoom / Restore window
vim.keymap.set("n", "<leader>z", "<cmd>ZoomToggle<CR>", { silent = true, noremap = true })

-- quickfix
keymap.set(
  "n",
  "<F2>",
  function() vim.fn["qf#ToggleQuickFix"]() end,
  { silent = true, noremap = true, desc = "Toggle Quickfix" }
)
keymap.set(
  "n",
  "<leader>xq",
  function() vim.fn["qf#ToggleQuickFix"]() end,
  { silent = true, noremap = true, desc = "Toggle Quickfix" }
)
keymap.set(
  "n",
  "<S-F2>",
  function() vim.fn["qf#ToggleLocationList"]() end,
  { silent = true, noremap = true, desc = "Toggle Location List" }
)
keymap.set(
  "n",
  "<leader>xl",
  function() vim.fn["qf#ToggleLocationList"]() end,
  { silent = true, noremap = true, desc = "Toggle Location List" }
)

-- Font zoom in/out
vim.keymap.set("n", "<C-=>", function() vim.fn["zoom#ZoomIn"]() end, { silent = true, noremap = true })
vim.keymap.set("n", "<C-->", function() vim.fn["zoom#ZoomOut"]() end, { silent = true, noremap = true })

-- aes-vim
vim.keymap.set("v", "<leader>ec", ":AesEnc<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ed", ":AesDec<cr>", { noremap = true })

-- fold
for i = 0, 5 do
  vim.keymap.set("n", "z" .. i, function()
    vim.wo.foldlevel = i
    vim.wo.foldenable = true
  end, { noremap = true })
end
-- }}}

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

--Toggle LSP{{{2
local toggle_lsp_client = function()
  local filetype = vim.bo.filetype
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  put(clients)
  if #clients > 0 then
    for _, client in ipairs(clients) do
      vim.lsp.enable(client.name, false)
      client:stop()
    end
    vim.notify("LSP Server stopped", vim.log.levels.INFO, { title = "LSP" })
  else
    vim.lsp.enable(filetype)
    vim.notify("Starting LSP Server", vim.log.levels.INFO, { title = "LSP" })
  end
end

local start_lsp_client = function()
  local filetype = vim.bo.filetype
  if filetype == "" then return end
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if not vim.tbl_isempty(clients) then
    vim.lsp.enable(filetype)
    vim.notify("Restarting LSP Server", vim.log.levels.INFO, { title = "LSP" })
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
      vim.cmd.RustLsp { 'hover', 'range' }
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

-- Tmux {{{2
if vim.g.enabled_plugins.tmux == 1 then
  vim.keymap.set("n", "<c-h>", ":TmuxNavigateLeft<cr>", { silent = true })
  vim.keymap.set("n", "<c-j>", ":TmuxNavigateDown<cr>", { silent = true })
  vim.keymap.set("n", "<c-k>", ":TmuxNavigateUp<cr>", { silent = true })
  vim.keymap.set("n", "<c-l>", ":TmuxNavigateRight<cr>", { silent = true })
end
-- }}}
-- Fast Search {{{2
if vim.fn.executable("rg") == 1 then
  -- Use rg over grep
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
  vim.opt.grepformat = "%f:%l:%c%m"

  -- Ag command
  vim.api.nvim_create_user_command(
    "Ag",
    function(args) vim.cmd("silent! grep! " .. args.args .. "|cwindow|redraw!") end,
    { nargs = "*", complete = "file", bar = true }
  )

  -- Jump to definition under cursor
  vim.keymap.set("n", "gs", ":Rg <C-R><C-W><CR>", { silent = true })
elseif vim.fn.executable("ag") == 1 then
  -- Use ag over grep
  vim.opt.grepprg = "ag --vimgrep $*"
  vim.opt.grepformat = "%f:%l:%c%m"

  -- Ag command
  vim.api.nvim_create_user_command(
    "Ag",
    function(args) vim.cmd("silent! grep! " .. args.args .. "|cwindow|redraw!") end,
    { nargs = "*", complete = "file", bar = true }
  )

  -- Jump to definition under cursor
  vim.keymap.set("n", "gs", ":Ag <cword><CR>", { silent = true })
end
--- }}}

-- Trailing whitespace / Line endings {{{2
local function trim_trailing_whitespaces(firstline, lastline)
  local old_hlsearch = vim.o.hlsearch
  vim.cmd(firstline .. "," .. lastline .. "substitute /\\v\\s+$//ge")
  vim.o.hlsearch = old_hlsearch
end

vim.api.nvim_create_user_command(
  "TrimSpaces",
  function(opts) trim_trailing_whitespaces(opts.line1, opts.line2) end,
  { range = "%", nargs = 0, desc = "Trim trailing whitespaces" }
)
vim.api.nvim_create_user_command("FixLineEndings", "%s/\r$//ge", { nargs = 0, desc = "Fix line endings" })

-- Custom actions {{{2
vim.keymap.set("n", "<leader>gx", function()
  local custom_actions = require("myrc.utils.custom_actions")
  custom_actions.pick_actions()
  if not custom_actions.registered then
    local register_action = require("myrc.utils.custom_actions").register_action
    register_action("Fix line endings", function() vim.cmd("%s/\r$//ge") end, { override = true })
    register_action("Trim trailing whitespaces", function() vim.cmd("%TrimSpaces") end, { override = true })
    register_action("Run Jest test", function() vim.cmd("silent !npm test -- %") end, { ft = "javascript" })
    custom_actions.registered = true
  end
end, { desc = "Pick custom actions" })
-- }}}

-- ALE{{{2
vim.keymap.set("n", "<leader>L", "<Plug>(ale_lint)", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>xF", "<Plug>(ale_fix)", { noremap = true, silent = false })

-- EasyAlign{{{2
vim.keymap.set("v", "ga", "<Plug>(EasyAlign)")
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")

-- Copy Filename{{{2
local function copy_to_clipboard(content, message)
  vim.fn.setreg("+", content)
  vim.notify('Copied "' .. content .. '" to the clipboard!', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("CopyRelativePath", function()
  local path = vim.fn.expand("%")
  copy_to_clipboard(path, 'Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
  local path = vim.fn.expand("%:p")
  copy_to_clipboard(path, 'Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyRelativePathWithLine", function()
  local path = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local result = path .. ":" .. line
  copy_to_clipboard(result, 'Copied "' .. result .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyAbsolutePathWithLine", function()
  local path = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local result = path .. ":" .. line
  copy_to_clipboard(result, 'Copied "' .. result .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyFileName", function()
  local path = vim.fn.expand("%:t")
  copy_to_clipboard(path, 'Copied "' .. path .. '" to the clipboard!')
end, {})


-- 复制路径（relative / absolute）
local function copy_path(rel, is_visual)
  local path = rel and vim.fn.expand('%') or vim.fn.expand('%:p')
  if is_visual then
    local start = vim.fn.line("'<")
    local finish = vim.fn.line("'>")
    if start > finish then start, finish = finish, start end
    path = string.format("%s:L%d-%d", path, start, finish)
  end
  vim.fn.setreg('+', path)
  print("已复制: " .. path)
end

vim.keymap.set('n', '<leader>yr', function() copy_path(true, false) end, { desc = "复制相对路径" })
vim.keymap.set('n', '<leader>ya', function() copy_path(false, false) end, { desc = "复制绝对路径" })
vim.keymap.set('x', '<leader>yr', function() copy_path(true, true) end, { desc = "复制相对路径+行范围" })
vim.keymap.set('x', '<leader>ya', function() copy_path(false, true) end, { desc = "复制绝对路径+行范围" })


-- FloatTerm{{{2
keymap.set(
  { "n", "i", "t" },
  "<A-`>",
  function() vim.cmd(vim.v.count .. "ToggleTerm") end,
  { noremap = true, desc = "Toggle FloatTerm" }
)
keymap.set(
  "n",
  "<A-t>v",
  function() vim.cmd(vim.v.count1 .. "ToggleTerm direction=vertical") end,
  { noremap = true, desc = "Toggle Vertical FloatTerm " }
)
keymap.set(
  "n",
  "<A-t>h",
  function() vim.cmd(vim.v.count1 .. "ToggleTerm direction=horizontal") end,
  { noremap = true, desc = "Toggle horizontal FloatTerm" }
)

keymap.set(
  "v",
  "<space>s",
  function() require("toggleterm").send_lines_to_terminal("single_line", true, { args = vim.v.count }) end
)
keymap.set({ "n", "t" }, "<A-s>", "<cmd>TermSelect<CR>", { noremap = true, desc = "Select Terminal" })
keymap.set("n", "<S-F12>", "<cmd>ToggleTerm<CR>", { noremap = true, desc = "Toggle FloatTerm" })
keymap.set("t", "<S-F12>", "<C-\\><C-n>:ToggleTerm<CR>", { noremap = true, desc = "Toggle FloatTerm" })
keymap.set({ "n", "t" }, "<S-F11>", "<cmd>TermSelect<CR>", { noremap = true, desc = "Select Terminal" })
vim.cmd([[
com! TermNewV :TermNew direction=vertical
com! TermNewH :TermNew direction=horizontal
com! TermNewT :TermNew direction=tab
]])

-- vim: set fdm=marker fdl=1: }}}
