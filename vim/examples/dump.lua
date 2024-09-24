function _G.dump(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v, {newline =''}))
  end

  print(table.concat(objects, '\n'))
  return ...
end

dump(vim.uv.os_uname())

