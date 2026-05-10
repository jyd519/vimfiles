-- 配合gitr命令使用
--
local function find_win_for_buf(buf_nr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf_nr then
      return win
    end
  end
  return nil
end

local function show_git_show(hash)
  local bufname = 'git-show'
  local existing_buf = vim.fn.bufnr(bufname)
  -- 执行 git show（无论新/旧 buffer 都需要最新结果）
  local output = vim.fn.systemlist('git show ' .. hash)
  if vim.v.shell_error ~= 0 then
    vim.notify('git show failed:\n' .. table.concat(output, '\n'), vim.log.levels.ERROR)
    return
  end

  local buf
  if existing_buf ~= -1 then
    buf = existing_buf
    -- 更新 buffer 内容
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = 'git'

    -- 检查该 buffer 是否已在某窗口中显示
    if find_win_for_buf(buf) == nil then
      -- 窗口已被关闭，重新打开（自然会切换过去）
      vim.cmd('vertical rightbelow sbuffer ' .. buf)
    end

    -- 如果窗口仍在，只更新内容，不跳转，光标留在原 buffer
    local win = vim.fn.bufwinid(buf)
    if win and win ~= -1 then
      vim.api.nvim_set_current_win(win)
    end
  else
    -- 创建新 buffer 并填入结果
    vim.cmd('vertical rightbelow new')
    buf = vim.api.nvim_get_current_buf()
    -- 命名，确保后续复用
    vim.api.nvim_buf_set_name(buf, bufname)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

    -- 只读展示
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = 'git'      -- 或 'diff' 看偏好
  end
end

vim.keymap.set('n', '<enter>', function()
  -- 获取并清洁光标单词
  local raw_word = vim.fn.expand('<cword>')
  local word = vim.trim(raw_word)   -- 去掉不可见字符/前后空格

  -- 宽松匹配：十六进制（大小写），长度 7~40
  if not (word:match('^[0-9a-fA-F]+$') and #word >= 7 and #word <= 40) then
    vim.notify('Not a commit hash: "' .. word .. '"', vim.log.levels.WARN)
    return
  end

  local original_win = vim.api.nvim_get_current_win()
  show_git_show(word)
  vim.api.nvim_set_current_win(original_win)
end, { buf = 0, noremap = true, silent = true, desc = 'Git show commit under cursor' })

vim.keymap.set('n', 'K', function()
  -- 获取并清洁光标单词
  local raw_word = vim.fn.expand('<cword>')
  local word = vim.trim(raw_word)   -- 去掉不可见字符/前后空格

  -- 宽松匹配：十六进制（大小写），长度 7~40
  if not (word:match('^[0-9a-fA-F]+$') and #word >= 7 and #word <= 40) then
    vim.notify('Not a commit hash: "' .. word .. '"', vim.log.levels.WARN)
    return
  end

  show_git_show(word)
end, { buf = 0, noremap = true, silent = true, desc = 'Git show commit under cursor' })
