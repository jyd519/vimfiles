local M = {}

--- 解析空格分隔、支持引号的字段行
---@param input_str string
---@return string[]
M.parse_args = function (input_str)
  if not input_str or input_str == "" then return {} end

  local args = {}
  local current_arg = ""
  local in_quote = false
  local quote_char = nil
  local escape_next = false

  for i = 1, #input_str do
    local char = input_str:sub(i, i)

    if escape_next then
      -- 处理转义字符
      current_arg = current_arg .. char
      escape_next = false
    elseif char == "\\" then
      -- 遇到转义符，标记下一个字符需要转义
      escape_next = true
    elseif char == '"' or char == "'" then
      if in_quote then
        if char == quote_char then
          -- 结束引号
          in_quote = false
          quote_char = nil
        else
          -- 在一种引号内遇到另一种引号，当作普通字符
          current_arg = current_arg .. char
        end
      else
        -- 开始引号
        in_quote = true
        quote_char = char
      end
    elseif char == " " and not in_quote then
      -- 空格且不在引号内，结束当前参数
      if current_arg ~= "" then
        table.insert(args, current_arg)
        current_arg = ""
      end
    else
      -- 普通字符
      current_arg = current_arg .. char
    end
  end

  -- 处理最后一个参数
  if current_arg ~= "" then table.insert(args, current_arg) end

  return args
end

vim.api.nvim_create_user_command("Rg", function(opts)
  local input = opts.args
  if input == "" then
    vim.notify("Usage: Rg <pattern>", vim.log.levels.WARN)
    return
  end

  -- 构建命令参数列表（安全！无需 shellescape）
  local cmd = { "rg", "--vimgrep", "--no-heading", "--smart-case" }

  -- 将用户输入按 shell 规则分割成参数（支持带引号的空格）
  local args = M.parse_args(input)
  vim.list_extend(cmd, args)
  -- 使用 vim.system 执行（自动处理参数转义）
  vim.system(cmd, { text = true }, function(obj)
    if obj.code ~= 0 then
      put(cmd)
      if obj.stderr and obj.stderr ~= "" then vim.notify("rg error: " .. obj.stderr, vim.log.levels.ERROR) end
      vim.notify("No matches found: code = " .. obj.code, vim.log.levels.INFO)
      return
    end

    -- 成功后加载 quickfix 列表
    local output = obj.stdout
    if output and output ~= "" then
      local lines = vim.split(output, "\n", { trimempty = true })
      -- 解析 --vimgrep 格式: filename:line:col:match
      local results = {}
      for _, line in ipairs(lines) do
        local file, lnum, col, text = line:match("^(.-):(%d+):(%d+):(.*)$")
        if file and lnum and col and text then
          table.insert(results, {
            filename = file,
            lnum = tonumber(lnum),
            col = tonumber(col),
            text = text,
          })
        end
      end
      if #results > 0 then
        vim.schedule(function()
          vim.fn.setqflist(results, "r")
          vim.cmd("copen")
          vim.cmd("wincmd J") -- 可选：将 quickfix 窗口移到底部
        end)
      else
        put(cmd)
        vim.schedule(function() vim.notify("No matches found", vim.log.levels.INFO) end)
      end
    else
      put(cmd)
      vim.schedule(function() vim.notify("No output from rg", vim.log.levels.INFO) end)
    end
  end)
end, {
  nargs = "*",
  complete = function() return {} end,
  desc = "Search with ripgrep (rg)",
})

return M
