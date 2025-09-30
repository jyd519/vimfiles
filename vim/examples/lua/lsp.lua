
for _, client in pairs(vim.lsp.buf_get_clients(0)) do
  if client and client.supports_method('textDocument/hover') then
    put(client.name)
  end
end


local function done(result)
  put("hover result", result)
end

local function hover() 
  local util = require('vim.lsp.util')
  local params = util.make_position_params()
  -- put(params)
  vim.lsp.buf_request(0, 'textDocument/hover', params, function(_, result, _, _)
    if not result or not result.contents then
      done()
      return
    end

    local lines = util.convert_input_to_markdown_lines(result.contents)
    lines = util.trim_empty_lines(lines)

    if vim.tbl_isempty(lines) then
      done()
      return
    end

    done{lines=lines, filetype="markdown"}
  end)
end

vim.keymap.set("n", "<leader><leader>t", function()
  hover()
end, { desc="hover test" })
           
