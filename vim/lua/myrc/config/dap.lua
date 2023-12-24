---@diagnostic disable: missing-parameter
-- configure DAP {{{1
local dap = require("dap")
_G.dap = dap

local is_windows = function()
  return vim.loop.os_uname().sysname:find("Windows", 1, true) and true
end

local dap_breakpoint = {
  error = {
    text = "🟥",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
  },
  rejected = {
    text = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = "🟢",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "DiagnosticUnderlineInfo",
    numhl = "LspDiagnosticsSignInformation",
  },
}

--
-- vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#993939', guibg='#31353f' }, false)
-- vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
-- vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

-- vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
-- vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
-- vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapLogPoint",
  { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)

-- Configure Extensions: daui/dap-virtual-text {{{1
require("nvim-dap-virtual-text").setup({
  commented = true,
})

local dapui = require("dapui")
_G.dapui = dapui

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "ﱢ",
    },
  },
})
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  -- local ft = vim.bo.filetype
  -- if ft == "javascript" or ft == "typescript" then
  --     -- FIXME: typescript/javascript
  --     if string.match(dap.status(), "^Running.+") then
  --         return
  --     end
  -- end
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- }}}

-- Keymaps {{{1
local function DebugTest()
  if dap.session() then
    dap.continue()
    return
  end

  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:t")
  if ft == "go" then
    if string.match(file, ".*_test.go") then
      require("dap-go").debug_test()
      return
    end
  elseif ft == "typescript" or ft == "javascript" then
    if string.match(file, ".*test%.[jt]s") then
      require("myrc.config.dap-jest").debug()
      return
    end
  elseif ft == "python" then
    if string.match(file, ".*_test%.py") or string.match(file, "test_.+%.py") then
      require("dap-python").test_method()
      return
    end
  end
  if ft == "lua" then
    require("osv").run_this()
    return
  end

  dap.continue()
end
_G.DebugTest = DebugTest

-- Use hydra instead
local function setup_keymap()
  local mapkey = require("keymap-amend")

  mapkey("n", "<F5>", function()
    DebugTest()
  end, { silent = true, desc = "Start Debugging" })

  mapkey("n", "<F9>", function(fallback)
    if dap.session then
      require("dap").toggle_breakpoint()
    else
      fallback()
    end
  end, { silent = true, desc = "Toggle Breakpoints/Run" })

  mapkey("n", "<F10>", function(fallback)
    if dap.session then
      require("dap").step_over()
    else
      fallback()
    end
  end, { silent = true, desc = "Step Over" })

  mapkey("n", "<F11>", function(fallback)
    if dap.session() then
      dap.step_into()
    else
      fallback()
    end
  end, { silent = true, desc = "Step Into" })

  mapkey("n", "<F12>", function(fallback)
    if dap.session() then
      dap.step_out()
    else
      fallback()
    end
  end, { silent = true, desc = "Step out" })

  local keymap = {
    R = {
      function()
        require("dap").run_to_cursor()
      end,
      "Run to Cursor",
    },
    E = {
      function()
        require("dapui").eval(vim.fn.input("[Expression] > "))
      end,
      "Evaluate Input",
    },
    ["cb"] = {
      function()
        require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
      end,
      "Conditional Breakpoint",
    },
    U = {
      function()
        require("dapui").toggle()
      end,
      "Toggle UI",
    },
    c = {
      function()
        require("dap").continue()
      end,
      "Continue",
    },
    e = {
      function()
        require("dapui").eval()
      end,
      "Evaluate",
    },
    ["vs"] = {
      function()
        require("dapui").float_element("scopes", { enter = true })
      end,
      "Open scopes window",
    },
    g = {
      function()
        require("dap").session()
      end,
      "Get Session",
    },
    h = {
      function()
        require("dap.ui.widgets").hover()
      end,
      "Hover Variables",
    },
    S = {
      function()
        require("dap.ui.widgets").scopes()
      end,
      "Scopes",
    },
    i = {
      function()
        require("dap").step_into()
      end,
      "Step Into",
    },
    o = {
      function()
        require("dap").step_over()
      end,
      "Step Over",
    },
    p = {
      function()
        require("dap").pause.toggle()
      end,
      "Pause",
    },
    q = {
      function()
        dap.close()
      end,
      "Quit",
    },
    ["rp"] = {
      function()
        require("dap").repl.toggle()
      end,
      "Toggle Repl",
    },
    s = {
      function()
        require("dap").continue()
      end,
      "Start",
    },
    b = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "Toggle Breakpoint",
    },
    x = {
      function()
        require("dap").terminate()
      end,
      "Terminate",
    },
  }

  for sk, sv in pairs(keymap) do
    mapkey("n", "<leader>d" .. sk, sv[1], { desc = sv[2] })
  end

  mapkey("v", "<leader>e", function(original)
    if dap.session() then
      require("dapui").eval()
    else
      original()
    end
  end, { silent = true, desc = "Evaluate variable" })
end

-- Use hydra instead
-- setup_keymap()

-- Configure Debuggers {{{1
--
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
--

-- lua {{{1
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input("Host [127.0.0.1]: ")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port: ", "54321"))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host, port = config.port })
end

-- python {{{1
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
local getPythonPath = function()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    if is_windows() then
      return venv_path .. "\\Scripts\\python.exe"
    end
    return venv_path .. "/bin/python"
  end
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return vim.g.python3_host_prog or "python3"
  end
end

local enrich_config = function(config, on_config)
  if not config.pythonPath and not config.python then
    config.pythonPath = getPythonPath()
  end
  on_config(config)
end

local dap_python = require("dap-python")
local test_runner = dap_python.test_runners["django"]
---@diagnostic disable-next-line: duplicate-set-field
dap_python.test_runners["django"] = function(classname, methodname)
  local runner, args = test_runner(classname, methodname)
  if type(vim.g["test#python#djangotest#options"]) == "string" then
    table.insert(args, vim.g["test#python#djangotest#options"])
  end
  put("django:", args)
  return runner, args
end

dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb({
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
      enrich_config = enrich_config,
      options = {
        source_filetype = "python",
      },
    })
  else
    cb({
      type = "executable",
      command = getPythonPath(),
      args = { "-m", "debugpy.adapter" },
      enrich_config = enrich_config,
      options = {
        source_filetype = "python",
      },
    })
  end
end

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}",
    pythonPath = getPythonPath,
    -- stopOnEntry = true,
    -- env = {}
  },
  {
    type = "python",
    request = "attach",
    name = "Attach Running Process (5678)",
    connect = {
      host = "127.0.0.1",
      port = 5678,
    },
    pythonPath = getPythonPath,
    -- pathMappings = {
    --   {
    --     localRoot= "${workspaceFolder}",
    --     remoteRoot= "/home/ops/"
    --   }
    -- },
    justMyCode = false,
  },
  {
    type = "python",
    request = "attach",
    name = "Attach Running Process (Prompt)",
    connect = {
      host = "127.0.0.1",
      port = function()
        local val = tonumber(vim.fn.input("Port: ", "5678"))
        assert(val, "Please provide a port number")
        return val
      end,
    },
    pythonPath = getPythonPath,
    justMyCode = false,
  },
}

-- go {{{2
-- https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua
require("dap-go").setup({})

-- c/c++/rust {{{1
-- codelldb ref: https://github.com/vadimcn/vscode-lldb/blob/master/MANUAL.md#launching-a-new-process
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/local/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
}

---@diagnostic disable-next-line: missing-parameter
local vscode_lldb_path = vim.fn.globpath(os.getenv("HOME") .. "/.vscode/extensions", "*vscode-lldb*")
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vscode_lldb_path .. "/adapter/codelldb",
    args = { "--port", "${port}" },
    detach = not vim.fn.has("win32"),
  },
}

dap.configurations.cpp = {
  {
    name = "Launch - codelldb",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "Launch - vscode-lldb",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
      end
      return variables
    end,
    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- javascript {{{1
require("dap-vscode-js").setup({
  node_path = vim.g.node_path or "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
  -- Path to vscode-js-debug installation.
  debugger_path = os.getenv("HOME") .. "/dev/tools/vscode-js-debug",
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
        "--runTestsByPath",
        "${file}",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end

-- vim: set fdm=marker fdl=0: }}}
