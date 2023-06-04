-- https://github.com/anuvyklack/hydra.nvim
local Hydra = require("hydra")

Hydra(
    {
        name = "Side scroll",
        mode = "n",
        body = "z",
        heads = {
            {"h", "5zh"},
            {"l", "5zl", {desc = "←/→"}},
            {"H", "zH"},
            {"L", "zL", {desc = "half screen ←/→"}}
        }
    }
)

local venn_hint =
    [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _b_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]

Hydra(
    {
        name = "Draw Diagram",
        hint = venn_hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded"
            },
            on_enter = function()
                vim.o.virtualedit = "all"
            end
        },
        mode = "n",
        body = "<leader>v",
        heads = {
            {"H", "<C-v>h:VBox<CR>"},
            {"J", "<C-v>j:VBox<CR>"},
            {"K", "<C-v>k:VBox<CR>"},
            {"L", "<C-v>l:VBox<CR>"},
            {"b", ":VBox<CR>", {mode = "v"}},
            {"<Esc>", nil, {exit = true}}
        }
    }
)

Hydra(
    {
        name = "Window resizing",
        hint = [[调整窗口大小:
      左右  _b_ : bigger   _s_ : smaller
      上下  _+_ : expand   _-_ : shrink]],
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded"
            }
        },
        mode = "n",
        body = "<leader>W",
        heads = {
            {"+", "<C-W>+"},
            {"-", "<C-W>-"},
            {"b", "<C-W>>", {desc = "← →"}},
            {"s", "<C-W><", {desc = "→ ←"}},
            {"q", nil, {exit = true}},
            {"<Esc>", nil, {exit = true}}
        }
    }
)

local dap_hint =
    [[
     ^ ^Step^ ^ ^      ^ ^     Action
 ----^-^-^-^--^-^----  ^-^-------------------------------------------------
     ^ ^back^ ^ ^     ^_t_: toggle breakpoint  ^_<F5>_/_S_: Start/Continue
     ^ ^ _B_^ ^        _T_: clear breakpoints  ^_<F10>_: step over
 out _H_ ^ ^ _s_ into  _c_: continue           ^_<F11>_: step into
     ^ ^ _n_ ^ ^       _x_: stop               ^_<F12>_: step out 
     ^ ^over ^ ^     ^^_r_: open repl          ^_R_:  Run to cursor

     ^ ^  _q_: exit
]]
local dap = require("dap")
Hydra {
    name = "Dap Debug",
    hint = dap_hint,
    config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
            border = "rounded",
            position = "bottom-right"
        },
        on_exit = function()
            vim.cmd("DapStop")
        end
    },
    mode = {"n"},
    body = "<leader>D",
    heads = {
        {"S", DebugTest, {desc = "Start Debugging"}},
        {"<F5>", DebugTest, {desc = "Start Debugging"}},
        {"H", dap.step_out, {desc = "step out"}},
        {"<F12>", dap.step_out, {desc = "step out"}},
        {"n", dap.step_over, {desc = "step over"}},
        {"<F10>", dap.step_over, {desc = "step over"}},
        {"B", dap.step_back, {desc = "step back"}},
        {"s", dap.step_into, {desc = "step into"}},
        {"<F11>", dap.step_into, {desc = "step into"}},
        {"R", dap.run_to_cursor, {desc = "run to cursor"}},
        {"t", dap.toggle_breakpoint, {desc = "toggle breakpoint"}},
        {"<F9>", dap.toggle_breakpoint, {desc = false}},
        {"T", dap.clear_breakpoints, {desc = "clear breakpoints"}},
        {"c", dap.continue, {desc = "continue"}},
        {"x", dap.stop, {desc = "stop"}},
        -- {"e", function () require"dapui".eval() end, {desc = "evaluate variable"}},
        {"r", dap.repl.open, {exit = true, desc = "open repl"}},
        {"q", nil, {exit = true, nowait = true, desc = "exit"}}
    }
}

-- Switch colorschemes

Hydra(
    {
        name = "Switch colorscheme",
        mode = {"n"},
        body = "<leader>cc",
        config = {
            color = "pink",
            invoke_on_body = true,
            on_enter = function()
               print(vim.g.colors_name, vim.go.background)
            end,
            on_key = function()
               print(vim.g.colors_name or "", vim.go.background)
            end
        },
        heads = {
            {"<left>", "<cmd>NextCS<cr>", {desc = "←"}},
            {"<right>", "<cmd>PreviousCS<cr>", {desc = "→"}},
            {
                "<space>",
                function()
                    if vim.o.background == "light" then
                        vim.o.background = "dark"
                    else
                        vim.o.background = "light"
                    end
                end,
                {desc = "dark/light"}
            },
            {"q", nil, {exit = true}}
        }
    }
)



-- diagnostics{{{2
--
local diagnostics_active = true
local toggle_diagnostics = function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.api.nvim_echo({{"Show diagnostics"}}, false, {})
        vim.diagnostic.enable(0)
    else
        vim.api.nvim_echo({{"Disable diagnostics"}}, false, {})
        vim.diagnostic.disable(0)
    end
end

local diagnostic_hint = [[
 _n_: next diagnostic   _N_: previous diagnostic  _f_: code action
 _a_: all diagnostics   _l_: buffer diagnostics   _t_: toggle diagnostics
 ^                      _q_: exit
]]

Hydra({
  hint = diagnostic_hint,
  name = 'Diagnostics',
  config = {
    invoke_on_body = true,
    color = 'pink',
    hint = {
      position = 'bottom',
      border = 'rounded'
    },
  },
  mode = {'n'},
  body = '<leader>x',
  heads = {
    {
      'n',
      function ()
        vim.diagnostic.goto_next()
      end,
      { desc="next diagnostic" }
    },
    {
      'N',
      function ()
        vim.diagnostic.goto_prev()
      end,
      { desc="previous diagnostic" }
    },
    {
      'a',
      function ()
        require"telescope.builtin".diagnostics{}
      end,
      { desc="diagnostics", exit = true, nowait = true}
    },
    { 't', toggle_diagnostics, { desc="toggle diagnostics" }},
    {
      'l',
      function ()
        require"telescope.builtin".diagnostics{bufnr=0}
      end,
      { desc="buffer diagnostics", exit = true, nowait = true}
    },
    {
      'f',
      function ()
        vim.lsp.buf.code_action()
        return '<Ignore>'
      end,
    },
    {
      'q',
      nil,
      { exit = true, nowait = true}
    }
  }
})
