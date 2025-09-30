
local function process(result)
  local ok, res = pcall(vim.json.decode, result)
  if not ok or not res[1] then
    -- vim.notify "Failed to parse dictionary response"
    return
  end

  local json = res[1]

  local lines = {
    json.word,
  }

  for _, def in ipairs(json.meanings[1].definitions) do
    lines[#lines+1] = ''
    lines[#lines+1] = def.definition
    if def.example then
      lines[#lines+1] = 'Example: '..def.example
    end
  end

  return lines
end


local function done(result)
  put(result)
end

local execute = async.void(function(done)
  local word = vim.fn.expand('<cword>')

  local output = job {
    'curl', 'https://api.dictionaryapi.dev/api/v2/entries/en/'..word
  }

  local results = process(output)
  if not results then
    results = {'no definition for '..word}
  end
  done(results and {lines=results, filetype="markdown"})
end)

execute("lookup")
