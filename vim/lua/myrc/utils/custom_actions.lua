local M = {}

-- MRU 数据文件路径（保存在 Neovim 配置目录）
local mru_file = vim.fn.stdpath("data") .. "/custom_actions_mru.json"

-- 加载 MRU 列表
local function load_mru()
  local ok, data = pcall(vim.fn.readfile, mru_file)
  if ok and data and #data > 0 then
    local json_str = table.concat(data, "\n")
    local success, result = pcall(vim.fn.json_decode, json_str)
    if success then return result end
  end
  return {}
end

-- 保存 MRU 列表
local function save_mru(mru_list)
  local json_str = vim.fn.json_encode(mru_list)
  vim.fn.writefile({ json_str }, mru_file)
end

-- 更新 MRU（将选中的命令移到最前）
local function update_mru(selected_name)
  local mru = load_mru()
  -- 移除已存在的
  local new_mru = {}
  for _, name in ipairs(mru) do
    if name ~= selected_name then table.insert(new_mru, name) end
  end
  -- 插入到最前面
  table.insert(new_mru, 1, selected_name)
  -- 限制 MRU 长度（可选）
  while #new_mru > 10 do
    table.remove(new_mru)
  end
  save_mru(new_mru)
end

-- 存储所有注册的自定义 actions
-- 结构: { { name = "...", fn = function, opts = { ft = "...", pattern = "...", ... } }, ... }
M._registered_actions = {}

--- 注册一个自定义 action
-- @param name string 显示名称
-- @param fn function 执行函数
-- @param opts table 可选：{ ft = "python", pattern = "%.py$" } 等
M.register_action = function(name, fn, opts)
  opts = opts or {}
  if type(name) ~= "string" then error("Action name must be a string") end
  if type(fn) ~= "function" then error("Action function must be a function") end
  -- 检查是否已存在同名 action
  local exists_idx = nil
  for i, act in ipairs(M._registered_actions) do
    if act.name == name then
      exists_idx = i
      break
    end
  end

  if exists_idx then
    if opts.override then
      -- 覆盖
      M._registered_actions[exists_idx] = {
        name = name,
        fn = fn,
        opts = opts,
      }
      vim.notify(string.format('Custom action "%s" overridden.', name), vim.log.levels.INFO)
    else
      -- 默认：静默忽略（或可改为 warn）
      vim.notify(
        string.format('Custom action "%s" already registered. Use { override = true } to replace.', name),
        vim.log.levels.WARN
      )
    end
  else
    -- 新注册
    table.insert(M._registered_actions, {
      name = name,
      fn = fn,
      opts = opts,
    })
  end
end

-- 根据当前 buffer 筛选适用的自定义 actions
local function get_applicable_custom_actions()
  local ft = vim.bo.filetype
  local bufname = vim.api.nvim_buf_get_name(0)
  local actions = {}

  for _, act in ipairs(M._registered_actions) do
    local opts = act.opts

    -- 如果指定了 filetype，必须匹配
    if opts.ft and opts.ft ~= ft then goto continue end

    -- 如果指定了文件名 pattern（Lua 模式），必须匹配
    if opts.pattern and not string.match(bufname, opts.pattern) then goto continue end

    -- 如果指定了 exclude_ft，且当前 ft 在排除列表中，则跳过
    if opts.exclude_ft then
      local excluded = false
      if type(opts.exclude_ft) == "string" then
        excluded = opts.exclude_ft == ft
      else
        for _, eft in ipairs(opts.exclude_ft) do
          if eft == ft then
            excluded = true
            break
          end
        end
      end
      if excluded then goto continue end
    end

    -- 通过所有条件，加入列表
    table.insert(actions, {
      title = act.name,
      action = act.fn,
    })

    ::continue::
  end

  local mru = load_mru()
  local mru_set = {}
  for _, name in ipairs(mru) do
    mru_set[name] = true
  end

  -- 1. MRU 命令（按最近使用顺序）
  local mru_commands = {}
  for _, name in ipairs(mru) do
    for _, cmd in ipairs(actions) do
      if cmd.title == name then
        table.insert(mru_commands, cmd)
        break
      end
    end
  end

  -- 2. 未使用过的命令（保持原始顺序）
  local unused_commands = {}
  for _, cmd in ipairs(actions) do
    if not mru_set[cmd.title] then table.insert(unused_commands, cmd) end
  end
  return vim.list_extend(mru_commands, unused_commands)
end

-- 主函数：自定义 actions
M.pick_actions = function()
  local custom_actions = get_applicable_custom_actions()
  M._show_telescope_picker({}, custom_actions)
end

-- 内部：显示 Telescope picker
M._show_telescope_picker = function(lsp_actions, custom_actions)
  local all_actions = vim.list_extend(vim.deepcopy(lsp_actions), custom_actions)
  local original_buf = vim.api.nvim_get_current_buf()
  if vim.tbl_isempty(all_actions) then
    vim.notify("No actions available", vim.log.levels.WARN)
    return
  end

  local themes = require("telescope.themes")
  require("telescope.pickers")
    .new(themes.get_cursor({}), {
      finder = require("telescope.finders").new_table({
        results = all_actions,
        entry_maker = function(action)
          return {
            value = action,
            display = action.title,
            ordinal = action.title,
          }
        end,
      }),
      sorter = require("telescope.sorters").get_fzy_sorter(),
      previewer = false,
      attach_mappings = function(prompt_bufnr)
        local actions = require("telescope.actions")
        local select_action = function()
          local selection = require("telescope.actions.state").get_selected_entry()
          update_mru(selection.ordinal)
          if selection and selection.value and type(selection.value.action) == "function" then
            vim.api.nvim_buf_call(original_buf, function() selection.value.action() end)
          end
          require("telescope.actions").close(prompt_bufnr)
        end
        actions.select_default:replace(select_action)
        return true
      end,
    })
    :find()
end

return M
