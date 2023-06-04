-- require("null-ls.sources").disable({"mypy", "pylint"})
local pylint = require("null-ls.sources").get("pylint")[1]
if pylint then
  pylint.generator.opts.runtime_condition = function(params)
    local name = vim.fn.bufname(params.bufnr)
    if string.find(name, "migrations") then
      vim.b.pylint_skipped=1
      print("pylint skipped")
      return nil
    end
    if string.find(name, "_pb2.+py") then
      vim.b.pylint_skipped=1
      print("pylint skipped")
      return nil
    end
    return true
  end
end