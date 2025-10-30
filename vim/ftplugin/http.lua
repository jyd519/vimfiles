-- HTTP 文件类型插件

-- 先定义全局函数，然后再设置选项
_G.get_http_fold_level = function(lnum)
  local line = vim.fn.getline(lnum)
  if line:match("^%s*###") then return ">1" end
  return "="
end

_G.http_fold_text = function()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local title = start_line:gsub("^%s*###%s*", "")
  local line_count = vim.v.foldend - vim.v.foldstart

  if title == "" then
    title = vim.fn.getline(vim.v.foldstart + 1)
    title = title:gsub("^%s*(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)%s*", "")
  end

  local content_lines = 0
  for lnum = vim.v.foldstart, vim.v.foldend do
    local line_content = vim.fn.getline(lnum)
    if not line_content:match("^%s*$") then content_lines = content_lines + 1 end
  end

  return "▶ " .. title .. " [" .. content_lines .. " lines]"
end

-- 现在设置选项
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.get_http_fold_level(v:lnum)"
vim.opt_local.foldlevel = 0
vim.opt_local.foldminlines = 0
vim.opt_local.foldtext = "v:lua.http_fold_text()"

-- 导航函数
local function go_to_next_fold()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  -- 从下一行开始搜索
  for lnum = current_line + 1, total_lines do
    local line = vim.fn.getline(lnum)
    if line:match("^%s*###") then
      vim.fn.cursor(lnum, 1)
      -- 如果折叠是关闭的，打开它
      if vim.fn.foldclosed(lnum) ~= -1 then vim.cmd("normal! zo") end
      return
    end
  end
  print("已经是最后一个请求")
end

local function go_to_prev_fold()
  local current_line = vim.fn.line(".")
  -- 从上一行开始搜索
  for lnum = current_line - 1, 1, -1 do
    local line = vim.fn.getline(lnum)
    if line:match("^%s*###") then
      vim.fn.cursor(lnum, 1)
      -- 如果折叠是关闭的，打开它
      if vim.fn.foldclosed(lnum) ~= -1 then vim.cmd("normal! zo") end
      return
    end
  end
  print("已经是第一个请求")
end

-- 快捷键
-- local opts = { buffer = true, desc = "Next HTTP request" }
-- vim.keymap.set("n", "<space>j", go_to_next_fold, opts)
--
-- opts = { buffer = true, desc = "Previous HTTP request" }
-- vim.keymap.set("n", "<space>k", go_to_prev_fold, opts)
