-- https://github.com/anuvyklack/hydra.nvim
local Hydra = require("hydra")
local cmd = require("hydra.keymap-util").cmd

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
  mode = "n",
  body = "<leader>v",
  hint = venn_hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
          border = "rounded",
      },
    },
    on_enter = function() vim.o.virtualedit = "all" end,
  },
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
  mode = "n",
  body = "<leader>W",
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
      },
    },
  },
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
--
local dap_hint = [[
 ^_,b_^: ^toggle breakpoint     ^_,S_/_<F5>_^: ^start/continue
 ^_,c_^: ^continue              ^_,r_     ^^^: ^run to cursor
 ^_,x_: stop  ^^                ^_,p_^: ^open repl ^         _,u_: ^toggle UI
 ^_,n_/_<F10>_: step over       _,i_/_<F11>_^: ^step into    ^_,o_/_<F12>_^: ^step out
 ^_,T_: ^clear breakpoints ^    ^^_,B_: ^conditional breakpoint
 ^_,e_/_,E_: evaluate input     ^_q_^: ^exit
]]

Hydra({
  name = "Dap Debug",
  mode = { "n" },
  body = "<leader>D",
  hint = dap_hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
      },
      position = "bottom-right",
    },
    on_exit = function() vim.cmd("silent! DapTerminate") end,
  },
  heads = {
    { ",S", function() require("myrc.utils.dap").debug_test() end, { desc = "Start Debugging" } },
    { "<F5>", function() require("myrc.utils.dap").debug_test() end, { desc = "Start Debugging" } },

    { "<F12>", function() require("dap").step_out() end, { desc = "step out" } },
    { ",o", function() require("dap").step_out() end, { desc = "step out" } },
    { "<F10>", function() require("dap").step_over() end, { desc = "step over" } },
    { ",n", function() require("dap").step_over() end, { desc = "step over" } },
    { ",i", function() require("dap").step_into() end, { desc = "step into" } },
    { "<F11>", function() require("dap").step_into() end, { desc = "step into" } },

    { ",r", function() require("dap").run_to_cursor() end, { desc = "run to cursor" } },
    { ",c", function() require("dap").continue() end, { desc = "continue" } },
    { ",b", function() require("dap").toggle_breakpoint() end, { desc = "toggle breakpoint" } },
    { "<F9>", function() require("dap").toggle_breakpoint() end, { desc = false } },
    {
      ",B",
      function() require("dap").set_breakpoint(vim.fn.input("[Condition] > ")) end,
      desc = "Conditional Breakpoint",
    },
    { ",T", function() require("dap").clear_breakpoints() end, { desc = "clear breakpoints" } },
    { ",x", function() require("dap").close() end, { desc = "stop" } },
    {
      ",u",
      function() require("dapui").toggle() end,
      desc = "Toggle UI",
    },
    { ",e", function() require("dapui").eval() end, { desc = "evaluate variable" } },
    {
      ",E",
      function() require("dapui").eval(vim.fn.input("[Expression] > ")) end,
      desc = "Evaluate Input",
    },
    { ",p", function() require("dap").repl.open() end, { desc = "open repl" } },
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
  body = "<leader>cs",
  config = {
    color = "pink",
    hint = { type = "window" },
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
    vim.diagnostic.enable(true)
  else
    vim.api.nvim_echo({ { "Disable diagnostics" } }, false, {})
    vim.diagnostic.enable(false)
  end
end

local diagnostic_hint = [[
 _n_: Next diagnostic   _N_: Previous diagnostic  _F_: Code action
 _a_: All diagnostics   _l_: Buffer diagnostics   _t_: Toggle diagnostics
 ^^                     _q_: Exit
]]

Hydra({
  name = "Diagnostics",
  mode = { "n" },
  body = "<leader>X",
  hint = diagnostic_hint,
  config = {
    invoke_on_body = true,
    color = "pink",
    hint = {
      float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
          border = "double",
      },
    },
  },
  heads = {
    {
      "n",
      function() vim.diagnostic.jump({count=1}) end,
      { desc = "next diagnostic" },
    },
    {
      "N",
      function() vim.diagnostic.jump({count=-1}) end,
      { desc = "previous diagnostic" },
    },
    {
      "L",
      function() vim.diagnostic.setloclist() end,
      { desc = "setloclist" },
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

local telescope_hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_
]]

Hydra({
  name = "Telescope",
  hint = telescope_hint,
  config = {
    color = "teal",
    invoke_on_body = true,
    hint = {
      position = "middle",
      float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
          border = "double",
      },
    },
    on_enter = function() vim.cmd([[Lazy load telescope.nvim]]) end,
  },
  mode = "n",
  body = "<space>f",
  heads = {
    { "f", cmd("Telescope find_files") },
    { "g", cmd("Telescope live_grep") },
    { "o", cmd("Telescope oldfiles"), { desc = "recently opened files" } },
    { "h", cmd("Telescope help_tags"), { desc = "vim help" } },
    { "m", cmd("MarksListBuf"), { desc = "marks" } },
    { "k", cmd("Telescope keymaps") },
    { "O", cmd("Telescope vim_options") },
    { "r", cmd("Telescope resume") },
    { "p", cmd("Telescope projects"), { desc = "projects" } },
    { "/", cmd("Telescope current_buffer_fuzzy_find"), { desc = "search in file" } },
    { "?", cmd("Telescope search_history"), { desc = "search history" } },
    { ";", cmd("Telescope command_history"), { desc = "command-line history" } },
    { "c", cmd("Telescope commands"), { desc = "execute command" } },
    { "u", cmd("silent! %foldopen! | UndotreeToggle"), { desc = "undotree" } },
    { "<Enter>", cmd("Telescope"), { exit = true, desc = "list all pickers" } },
    { "<Esc>", nil, { exit = true, nowait = true } },
  },
})

local git_hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

Hydra({
   name = 'Git',
   hint = git_hint,
   config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
        float_opts = {
            -- row, col, height, width, relative, and anchor should not be
            -- overridden
            style = "minimal",
            focusable = false,
            noautocmd = true,
        },
      },
      on_enter = function()
         vim.cmd 'mkview'
         vim.cmd 'silent! %foldopen!'
         vim.bo.modifiable = false
         local gs = require("gitsigns")
         gs.toggle_signs(true)
         gs.toggle_linehl(true)
      end,
      on_exit = function()
         local cursor_pos = vim.api.nvim_win_get_cursor(0)
         vim.cmd 'loadview'
         vim.api.nvim_win_set_cursor(0, cursor_pos)
         vim.cmd 'normal zv'
         local gs = require("gitsigns")
         gs.toggle_signs(false)
         gs.toggle_linehl(false)
         gs.toggle_deleted(false)
      end,
   },
   mode = {'n','x'},
   body = '<leader>g',
   heads = {
      { 'J',
         function()
            if vim.wo.diff then return ']c' end
            local gs = require("gitsigns")
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
         end,
         { expr = true, desc = 'next hunk' } },
      { 'K',
         function()
            if vim.wo.diff then return '[c' end
            local gs = require("gitsigns")
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
         end,
         { expr = true, desc = 'prev hunk' } },
      { 's', ':Gitsigns stage_hunk<CR>', { silent = true, desc = 'stage hunk' } },
      { 'u', require("gitsigns").undo_stage_hunk, { desc = 'undo last stage' } },
      { 'S', require("gitsigns").stage_buffer, { desc = 'stage buffer' } },
      { 'p', require("gitsigns").preview_hunk, { desc = 'preview hunk' } },
      { 'd', require("gitsigns").toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
      { 'b', require("gitsigns").blame_line, { desc = 'blame' } },
      { 'B', function() require("gitsigns").blame_line{ full = true } end, { desc = 'blame show full' } },
      { '/', require("gitsigns").show, { exit = true, desc = 'show base file' } }, -- show the base of the file
      { '<Enter>', '<Cmd>Neogit<CR>', { exit = true, desc = 'Neogit' } },
      { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
   }
})

-- vim: set foldlevel=1 fdm=marker:
