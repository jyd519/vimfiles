-- 创建一个 misc 模块
local M = {}

-- 获取视觉模式下选择的文本
local function get_visual_selection()
  -- 保存当前寄存器值
  local reg_save = vim.fn.getreg('"')
  local regtype_save = vim.fn.getregtype('"')
  local cb_save = vim.o.clipboard

  -- 复制选中内容到无名寄存器
  vim.cmd('normal! "xy')

  -- 获取复制的内容
  local selection = vim.fn.getreg("x")

  -- 还原寄存器
  vim.fn.setreg('"', reg_save, regtype_save)
  vim.o.clipboard = cb_save

  -- 返回处理后的选择文本
  return vim.fn.escape(selection, "\\/?.*$^~[]")
end

-- 向下搜索视觉选择的文本
function M.SearchVisualTextDown()
  local selection = get_visual_selection()
  -- 退出视觉模式
  vim.cmd("normal! `>")
  -- 设置搜索模式并执行向下搜索
  vim.fn.setreg("/", "\\V" .. selection)
  vim.cmd("normal! n")
  -- 高亮匹配项
  vim.cmd("set hlsearch")
end

-- 向上搜索视觉选择的文本
function M.SearchVisualTextUp()
  local selection = get_visual_selection()
  -- 退出视觉模式
  vim.cmd("normal! `<")
  -- 设置搜索模式并执行向上搜索
  vim.fn.setreg("/", "\\V" .. selection)
  vim.cmd("normal! N")
  -- 高亮匹配项
  vim.cmd("set hlsearch")
end

-- 设置键映射
vim.keymap.set("v", "*", function() M.SearchVisualTextDown() end, { silent = true })

vim.keymap.set("v", "#", function() M.SearchVisualTextUp() end, { silent = true })

-- 返回模块，这样其他脚本可以通过 require('misc') 来使用它
return M
