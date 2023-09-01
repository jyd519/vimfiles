-- https://github.com/anuvyklack/hydra.nvim
local Hydra = require("hydra")

-- Side scroll{{{2
Hydra({
  name = "Side scroll",
  mode = "n",
  body = "z",
  heads = {
    { "h", "5zh" },
    { "l", "5zl", { desc = "←/→" } },
    { "H", "zH" },
    { "L", "zL", { desc = "half screen ←/→" } },
  },
})

-- Draw Diagram{{{2
local venn_hint = [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _b_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]

Hydra({
  name = "Draw Diagram",
  hint = venn_hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      border = "rounded",
    },
    on_enter = function() vim.o.virtualedit = "all" end,
  },
  mode = "n",
  body = "<leader>v",
  heads = {
    { "H", "<C-v>h:VBox<CR>" },
    { "J", "<C-v>j:VBox<CR>" },
    { "K", "<C-v>k:VBox<CR>" },
    { "L", "<C-v>l:VBox<CR>" },
    { "b", ":VBox<CR>", { mode = "v" } },
    { "<Esc>", nil, { exit = true } },
  },
})

-- Window resizing{{{2
Hydra({
  name = "Window resizing",
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      border = "rounded",
    },
  },
  mode = "n",
  body = "<leader>W",
  heads = {
    { "+", "<C-W>+" },
    { "-", "<C-W>-" },
    { "r", "<C-W>r" },
    { "R", "<C-W>R" },
    { "B", "<C-W>>", { desc = "← →" } },
    { "S", "<C-W><", { desc = "→ ←" } },
    { "s", "<C-w>s" },
    { "v", "<C-w>v" },
    { ">", "<C-w>>", { desc = "← →" } },
    { "<", "<C-w><", { desc = "→ ←" } },
    { "=", "<C-w>=", { desc = "==" } },
    { "c", "<cmd>close<CR>", { desc = "close" } },
    { "o", "<cmd>only<CR>", { desc = "only" } },
    { "_", "<C-w>_" },
    { "|", "<C-w>|" },
    { "q", nil, { exit = true } },
    { "<Esc>", nil, { exit = true } },
  },
})

-- Dap{{{2
local dap_hint = [[
     ^ ^Step^ ^ ^      ^ ^     Action
 ----^-^-^-^--^-^----  ^-^-------------------------------------------------
     ^ ^back^ ^ ^     ^_t_: toggle breakpoint     ^_<F5>_/_S_: Start/Continue
     ^ ^ _B_^ ^        _T_: clear breakpoints     ^_<F10>_   : step over
 out _O_ ^ ^ _s_ into  _c_: continue              ^_<F11>_   : step into
     ^ ^ _n_  ^ ^      _x_: stop                  ^_<F12>_   : step out
     ^ ^over  ^ ^    ^^_r_: open repl             ^  _R_     : run to cursor
     ^ ^      ^ ^    ^^_E_: evaluate input        ^  _U_     : toggle UI
     ^ ^      ^ ^    ^^_C_: conditional breakpoint
     ^ ^  _q_: exit
]]
local dap = require("dap")
local dapui = require("dapui")
Hydra({
  name = "Dap Debug",
  hint = dap_hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      border = "rounded",
      position = "bottom-right",
    },
    on_exit = function() vim.cmd("silent! DapStop") end,
  },
  mode = { "n" },
  body = "<leader>D",
  heads = {
    { "S", DebugTest, { desc = "Start Debugging" } },
    { "<F5>", DebugTest, { desc = "Start Debugging" } },

    { "O", dap.step_out, { desc = "step out" } },
    { "<F12>", dap.step_out, { desc = "step out" } },

    { "n", dap.step_over, { desc = "step over" } },
    { "<F10>", dap.step_over, { desc = "step over" } },

    { "B", dap.step_back, { desc = "step back" } },

    { "s", dap.step_into, { desc = "step into" } },
    { "<F11>", dap.step_into, { desc = "step into" } },

    { "R", dap.run_to_cursor, { desc = "run to cursor" } },
    { "t", dap.toggle_breakpoint, { desc = "toggle breakpoint" } },
    { "<F9>", dap.toggle_breakpoint, { desc = false } },
    {
      "C",
      function() dap.set_breakpoint(vim.fn.input("[Condition] > ")) end,
      desc = "Conditional Breakpoint",
    },
    { "T", dap.clear_breakpoints, { desc = "clear breakpoints" } },

    { "c", dap.continue, { desc = "continue" } },
    { "x", dap.close, { desc = "stop" } },

    {
      "U",
      function() dapui.toggle() end,
      desc = "Toggle UI",
    },
    -- {"e", function () require"dapui".eval() end, {desc = "evaluate variable"}},
    {
      "E",
      function() dapui.eval(vim.fn.input("[Expression] > ")) end,
      desc = "Evaluate Input",
    },
    { "r", dap.repl.open, { exit = true, desc = "open repl" } },
    { "q", nil, { exit = true, nowait = true, desc = "exit" } },
  },
})

-- Switch colorschemes{{{2
--
local toggle_background = function()
  if vim.o.background == "light" then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end

local hydra_cs = Hydra({
  name = "Switch colorscheme",
  mode = { "n" },
  body = "<leader>c",
  config = {
    color = "pink",
    hint = { type = "window"},
    invoke_on_body = true,
    on_enter = function() print(vim.g.colors_name, vim.go.background) end,
    on_key = function() print(vim.g.colors_name or "", vim.go.background) end,
  },
  heads = {
    { "<left>", "<cmd>NextCS<cr>", { desc = "←" } },
    { "<right>", "<cmd>PreviousCS<cr>", { desc = "→" } },
    { "<space>", toggle_background, { desc = "dark/light" } },
    { "s", "<Cmd>Telescope colorscheme<cr>", { exit = true, desc = "select colorscheme" } },
    { "q", nil, { exit = true } },
    { "<Esc>", nil, { exit = true } },
  },
})

vim.api.nvim_create_user_command("SwitchCS", function() hydra_cs:activate() end, {})

-- diagnostics{{{2
--
local diagnostics_active = true
local toggle_diagnostics = function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.api.nvim_echo({ { "Show diagnostics" } }, false, {})
    vim.diagnostic.enable(0)
  else
    vim.api.nvim_echo({ { "Disable diagnostics" } }, false, {})
    vim.diagnostic.disable(0)
  end
end

local diagnostic_hint = [[
 _n_: next diagnostic   _N_: previous diagnostic  _F_: code action
 _a_: all diagnostics   _l_: buffer diagnostics   _t_: toggle diagnostics
 ^                      _q_: exit
]]

Hydra({
  name = "Diagnostics",
  mode = { "n" },
  body = "<leader>xn",
  hint = diagnostic_hint,
  config = {
    invoke_on_body = true,
    color = "pink",
    hint = {
      -- position = "bottom",
      border = "rounded",
    },
  },
  heads = {
    {
      "n",
      function() vim.diagnostic.goto_next() end,
      { desc = "next diagnostic" },
    },
    {
      "N",
      function() vim.diagnostic.goto_prev() end,
      { desc = "previous diagnostic" },
    },
    {
      "a",
      function() require("telescope.builtin").diagnostics({}) end,
      { desc = "diagnostics", exit = true, nowait = true },
    },
    { "t", toggle_diagnostics, { desc = "toggle diagnostics" } },
    {
      "l",
      function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,
      { desc = "buffer diagnostics", exit = true, nowait = true },
    },
    {
      "b",
      function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,
      { desc = "buffer diagnostics", exit = true, nowait = true },
    },
    {
      "F",
      function()
        vim.lsp.buf.code_action()
        return "<Ignore>"
      end,
    },
    {
      "q",
      nil,
      { exit = true, nowait = true },
    },
  },
})

-- vim: set foldlevel=1 fdm=marker:
