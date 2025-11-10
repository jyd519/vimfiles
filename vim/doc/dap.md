# DAP

`Neovim + nvim-dap (Client) <---- DAP协议 (JSON-RPC) ----> Debug Adapter (Server) <---- 原生协议 ----> 被调试进程`

## adapters

1. type = "executable" (标准模式)

nvim-dap 主动启动调试适配器进程，通过 stdin/stdout 进行 DAP 协议通信。
适用场景：大多数调试器，如 debugpy, lldb-vscode, vscode-cpptools

```
    nvim-dap (父进程)
        ↓ spawn
    [Adapter 进程]  ←→  stdin/stdout  ←→  被调试程序
```

```lua
dap.adapters.python = {
  type = 'executable',
  command = 'python',                    -- 可执行文件
  args = { '-m', 'debugpy.adapter' },    -- 参数
  -- 可选: cwd, env 等
}
```

2. type = "server" (服务模式)

`nvim-dap` 连接到一个已存在的调试适配器服务，通过 TCP 端口或 Unix socket 通信。
适用场景：调试器本身已作为独立服务运行，或需要网络远程调试，如 Chrome DevTools, Node.js Inspector, Delve (Go)

```
    nvim-dap
        ↓ connect to
    [Adapter 服务] (已运行在 127.0.0.1:PORT)  ←→  TCP/socket  ←→  被调试程序
```

+ 模式 A：自动启动服务 (推荐)
nvim-dap 先启动服务，再连接。配置需包含 executable 字段。

```lua
dap.adapters.delve = {
  type = 'server',
  port = '${port}',  -- 动态端口占位符，由 nvim-dap 分配
  executable = {      -- 可选：如果服务未启动，nvim-dap 会按此命令启动
    command = 'dlv',
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  },
}
```

+ 模式 B：手动启动服务
nvim-dap 只负责连接，不启动服务。假设服务已在运行。

```lua
dap.adapters.node2 = {
  type = 'server',
  host = '127.0.0.1',
  port = 9229,  -- 固定 Node.js Inspector 端口
  -- 注意：无 executable 字段，nvim-dap 不会尝试启动
}

-- $ node --inspect-brk=9229 your-script.js
```

## configurations

| 字段      | 作用                              | 示例                   |
| --------- | --------------------------------- | ---------------------- |
| `type`    | **关键**：关联 Adapter 的唯一标识 | `"python"`, `"cppdbg"` |
| `name`    | 配置显示名称（供用户选择）        | `"Launch Django"`      |
| `request` | 调试模式：`launch` 或 `attach`    | `launch`               |
| `program` | 要调试的程序入口                  | `"${file}"`            |
| `args`    | 程序命令行参数                    | `{ "--dev" }`          |
| `cwd`     | 工作目录                          | `"${workspaceFolder}"` |


## python

+ 安装debugpy
+ 查看配置

```
=dap.configurations.python
```

**调试方法**

+ 直接运行
+ 手动启动debugpy

```bash
python3 -m debugpy --listen 0.0.0.0:5678 manage.py runserver 0.0.0.0:8000 --nothreading --noreload
```
```lua
local dap = require("dap")
dap.adapters.pythonServer = {
    type = "server",
    host = "127.0.0.1",
    port = "5678",
    options = {
      source_filetype = 'python',
    }
}

local daputil = require("myrc.utils.dap")
daputil.add("python", {
    type = "pythonServer",
    request = "attach",
    name = "Attach remote Process",
    connect = {
        host = "127.0.0.1",
        port = 5678,
    },
    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    -- gevent = true,
    pathMappings = {
      {
        localRoot= "${workspaceFolder}",
        remoteRoot= "/home/joycloud/joycloud"
      }
    },
    justMyCode = false,
})
```

## javascript

+ 使用`mason`安装`js-debug-adapter`
+ 直接`F5`运行调试

## go

依赖

+ `delve`

需要注意dlv与golang的版本要匹配

**调试方法**

+ 直接`F5`运行调试
+ 远程调试

```sh
dlv debug -l 127.0.0.1:38697 --headless .\main.go

# F5: Attach remote
```

