local M = {}

local function splitByChunk(text, chunkSize)
  local s = {}
  for i = 1, #text, chunkSize do
    s[#s + 1] = text:sub(i, i + chunkSize - 1)
  end
  return s
end

local function splitStringWithPlus(line, maxchars)
  local prefix, surround, str = string.match(line, "([^\"']*)([\"'])(.*)%2")
  if not str then
    return {}
  end

  local t = splitByChunk(str, maxchars)
  local ret = {}
  for index, value in ipairs(t) do
    if index == 1 then
      table.insert(ret, prefix .. surround .. value .. surround .. " +")
    elseif index ~= #t then
      table.insert(ret, string.rep(" ", 4) .. surround .. value .. surround .. " +")
    else
      table.insert(ret, string.rep(" ", 4) .. surround .. value .. surround .. ";")
    end
  end
  return ret
end

function M.splitJsString(maxChars)
  maxChars = maxChars or 74
  local line = vim.fn.getline(".")
  local result = splitStringWithPlus(line, maxChars)
  vim.fn.append(".", result)
end

--[[
--
const s = "sdfsdfsdfsfsdfasdfasdfasdfasdfasdfasdfasdfsksdfjklasdfjlksadjflaskjflsadfjsdlkfsdfsdfsdfsfsdfasdfasdfasdfasdfasdfasdfasdfsksdfjklasdfjlksadjflaskjflsadfjsdlkfsdfsdfsdfsfsdfasdfasdfasdfasdfasdfasdfasdfsksdfjklasdfjlksadjflaskjflsadfjsdlkf";
const s = 'sdfsdfsdfsfsdfasdfasdfasdfasdfasdfasdfasdfsksdfjklasdfjlksadjflaskjflsadfjsdlkfsdfsdfsdfsfsdfasdfasdfasdfasdfasdfasdfasdfsksdfjklasdfjlksadjflaskjflsadfjsdlkfsdfsdfsdfsfsdfasdfasdfasdfasdfasdfasdfasdfsksdfjklasdfjlksadjflaskjflsadfjsdlkf';
--]]

return M
