---@diagnostic disable: missing-parameter
-- configure DAP {{{1
local dap = require("dap")
_G.dap = dap

local is_windows = vim.fn.has("win32") == 1

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

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

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

-- {{{1 dapui
local dapui = require("dapui")
_G.dapui = dapui

dapui.setup({})
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
-- close Dap UI with :DapCloseUI
vim.api.nvim_create_user_command("DapCloseUI", function() require("dapui").close() end, {})
-- }}}

-- {{{1 Commands
vim.api.nvim_create_user_command("DapAdapterDoc", function(args)
  local open_url = require("myrc.utils.system").open_url
  open_url("https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation")
end, {
  nargs = "*",
  desc = "Open Debug-Adapter installation page",
})

vim.api.nvim_create_user_command("DapOSVListen", function(args)
  local port = args.args or 8086
  require"osv".launch({port=tonumber(port)})
end, {
  nargs = "*",
  desc = "Launch DAP Server (OSV)",
})
vim.api.nvim_create_user_command("DapOSVStop", function()
  require"osv".stop()
end, {
  desc = "Stop OSV DAP Server",
})
-- }}}

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
      if value ~= "" then return value end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port: ", "54321"))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap.adapters.nlua = function(callback, config) callback({ type = "server", host = config.host, port = config.port }) end

-- python {{{1
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
local getPythonPath = function()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    if is_windows then return venv_path .. "\\Scripts\\python.exe" end
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
  if not config.pythonPath and not config.python then config.pythonPath = getPythonPath() end
  config.console = "integratedTerminal"
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
    console = "integratedTerminal", -- Or "externalTerminal"
    stopOnEntry = true,
    -- env = {}
  },
  {
    type = "python",
    request = "launch",
    name = "Launch Django Server (8000)",
    program = "${workspaceFolder}/manage.py", -- Path to your manage.py
    args = { "runserver", "0.0.0.0:8000" }, -- Arguments for runserver
    pythonPath = getPythonPath,
    console = "integratedTerminal", -- Or "externalTerminal"
    justMyCode = false, -- Set to true to skip debugging library code
  },
  {
    type = "python",
    request = "launch",
    name = "Launch Django Server (Prompt)",
    program = "${workspaceFolder}/manage.py", -- Path to your manage.py
    args = {
      "runserver",
      function()
        local addr = vim.fn.input("listen: ", "0.0.0.0:8001")
        if addr ~= "" then return addr end
        return addr
      end,
    },
    pythonPath = getPythonPath,
    console = "integratedTerminal", -- Or "externalTerminal"
    justMyCode = false, -- Set to true to skip debugging library code
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

-- go {{{1
-- https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua
require("dap-go").setup()
table.insert(dap.configurations.go, {
  -- first: start debuggee as bellow
  -- dlv debug -l 127.0.0.1:38697 --headless .\main.go
  type = "go",
  request = "attach",
  name = "Attach Remote (Prompt)",
  mode = "remote",
  port = function()
    local port = vim.fn.input("dlv listen port: ", "38697")
    return port
  end,
})

-- c/c++/rust {{{1
-- codelldb ref: https://github.com/vadimcn/vscode-lldb/blob/master/MANUAL.md#launching-a-new-process
local getLLDBPath = function()
  local llvm_root = os.getenv("LLVM_ROOT")
  if llvm_root ~= nil then
    return is_windows and llvm_root .. "/bin/lldb-vscode" or llvm_root .. "/bin/lldb-vscode.exe"
  end
  if vim.fn.executable("/usr/local/bin/lldb-vscode") == 1 then return "/usr/local/bin/lldb-vscode" end
  if vim.fn.executable("/usr/local/opt/llvm/bin/lldb-vscode") == 1 then return "/usr/local/opt/llvm/bin/lldb-vscode" end
  return "lldb-vscode"
end

dap.adapters.lldb = {
  type = "executable",
  command = getLLDBPath(),
}

---@diagnostic disable-next-line: missing-parameter
local vscode_codelldb_path = vim.fn.globpath(vim.loop.os_homedir() .. "/.vscode/extensions", "*vscode-lldb*")
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vscode_codelldb_path .. "/adapter/codelldb",
    args = { "--port", "${port}" },
    detach = not vim.fn.has("win32"),
  },
}

dap.configurations.cpp = {
  {
    name = "Launch - codelldb",
    type = "codelldb",
    request = "launch",
    program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "Launch - vscode-lldb",
    type = "lldb",
    request = "launch",
    program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
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
local vscode_js_debug_path =
  vim.fn.globpath(vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src", "dapDebugServer.js")
if vscode_js_debug_path ~= "" then
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}", --let both ports be the same for now...
    executable = {
      command = "node",
      args = { vscode_js_debug_path, "${port}" },
    },
  }

  if not dap.adapters["node"] then
    dap.adapters["node"] = function(cb, config)
      if config.type == "node" then config.type = "pwa-node" end
      local nativeAdapter = dap.adapters["pwa-node"]
      if type(nativeAdapter) == "function" then
        nativeAdapter(cb, config)
      else
        cb(nativeAdapter)
      end
    end
  end
  for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        port = 9229,
        address = "127.0.0.1",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch Current File (tsx)",
        cwd = "${workspaceFolder}",
        program = "${file}",
        runtimeExecutable = "tsx",
        -- args = { '${file}' },
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        outFiles = { "${workspaceFolder}/**/**/*", "!**/node_modules/**" },
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
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
end

-- vim: set fdm=marker fdl=0: }}}
