local cmd = vim.api.nvim_create_user_command

-- Editing a protected file as 'sudo'
cmd("W", "w !sudo tee % > /dev/null", { bang = true })

-- Zoom / Restore window
cmd("ZoomToggle", function() vim.fn["misc#ZoomToggle"]() end, {})

-- Lookup ansible-doc {{{2
cmd("Adoc", function(args)
  vim.cmd(
    "new | setlocal buftype=nofile bufhidden=hide noswapfile ft=man sw=4 |" .. "r !ansible-doc " .. args.args .. ""
  )
  vim.defer_fn(function() vim.cmd('exec "norm ggM"') end, 100)
end, {
  nargs = "+",
  desc = "Lookup ansible document",
})
-- }}}
-- Toggle Dark-Mode {{{2
cmd("Dark", function(args)
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
-- }}}
-- Make {{{2
cmd(
  "Make",
  function(opts) require("myrc.utils.term_run").gulp(opts.fargs) end,
  { nargs = "*", desc = "Run Build Tools" }
)
--}}}
-- LSP {{{2
-- Lsp formatting
cmd("Format", function() vim.lsp.buf.format({ async = true }) end, {
  desc = "Format the current buffer",
})

-- Toggle LSP Inlay-Hint
cmd("InlayHintToggle", function()
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
-- FoldMarker {{{2
-- 创建用户命令 :FoldMarker [level] [prefix]
-- 参数1: 折叠级别（可选，默认 2）
-- 参数2: 标记前缀文字（可选，放在 {{{ 前面）
cmd("FoldMarker", function(opts)
  -- 解析参数：第一个参数是 level，第二个是 prefix
  local args = {}
  if opts.args and opts.args ~= "" then
    for arg in opts.args:gmatch("%S+") do
      table.insert(args, arg)
    end
  end

  local level = tonumber(args[1]) or 2
  local prefix_text = args[2] or ""

  local buf = vim.api.nvim_get_current_buf()
  local start_line = opts.line1
  local end_line = opts.line2

  -- 获取注释字符串
  local comment_str = vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", "")
  -- 如果无法获取，使用常见默认值
  if comment_str == "" or comment_str == nil then
    local ft = vim.bo.filetype
    local comment_map = {
      lua = "--",
      python = "#",
      vim = '"',
      c = "//",
      cpp = "//",
      java = "//",
      javascript = "//",
      typescript = "//",
      rust = "//",
      go = "//",
      sh = "#",
      bash = "#",
      ruby = "#",
      perl = "#",
      yaml = "#",
      toml = "#",
      sql = "--",
      haskell = "--",
      ocaml = "(*", -- 简化处理
    }
    comment_str = comment_map[ft] or "#"
  end

  -- 获取选中的行
  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
  if #lines == 0 then return end

  local first_line = lines[1]
  local last_line = lines[#lines]

  -- 匹配 marker 起始和结束的模式
  local start_pat = "^(%s*)(.-)" .. comment_str .. "%s*(.-)%{%{%{(%d*)"
  local end_pat = "^(%s*)(.-)" .. comment_str .. "%s*(.-)%}%}%}(.*)$"

  local s_indent, s_pre, s_rest, s_level = first_line:match(start_pat)
  local e_indent, e_pre, e_rest, e_post = last_line:match(end_pat)

  if s_indent and e_indent then
    -- 选区首行已是起始标记，尾行已是结束标记 → 替换为新的 marker
    local new_first = s_indent
      .. (s_pre or "")
      .. comment_str
      .. " "
      .. prefix_text
      .. "{{{"
      .. level
      .. " "
      .. (s_rest or "")
    local new_last = e_indent .. (e_pre or "") .. comment_str .. " " .. e_rest .. "}}}" .. (e_post or "")
    vim.api.nvim_buf_set_lines(buf, start_line - 1, start_line, false, { new_first })
    vim.api.nvim_buf_set_lines(buf, end_line - 1, end_line, false, { new_last })
  else
    -- 未检测到完整的标记对 → 在选区前后插入新标记行
    local indent = first_line:match("^(%s*)") or ""

    -- 构建新行，只有 prefix_text 不为空时才添加空格
    local comment_prefix = prefix_text ~= "" and (comment_str .. " " .. prefix_text .. " ") or (comment_str .. " ")
    local start_marker = indent .. comment_prefix .. "{{{" .. level
    local end_marker = indent .. comment_str .. " }}}"

    vim.api.nvim_buf_set_lines(buf, start_line - 1, start_line - 1, false, { start_marker })
    -- 因为上面插入了一行，结束行需要 +1
    vim.api.nvim_buf_set_lines(buf, end_line+1, end_line+1, false, { end_marker })
  end

  -- 提示
  local prefix_info = prefix_text ~= "" and (' with prefix "' .. prefix_text .. '"') or ""
  vim.notify(
    string.format("Folded lines %d-%d as level %d%s", start_line, end_line, level, prefix_info),
    vim.log.levels.INFO
  )
end, {
  range = true,
  nargs = "?",
})
-- }}}

-- vim: set fdm=marker fdl=1: }}}
