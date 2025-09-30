-- pyright {{{2
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
local is_window = vim.fn.has("win32") == 1

local function getPythonPath()
  local p
  local python = is_window and "python.exe" or "python"
  if vim.env.VIRTUAL_ENV then
    p = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", python)
    if vim.uv.fs_stat(p) then return p end
  end

  p = vim.fs.joinpath(".venv", "Scripts", python)
  if vim.uv.fs_stat(p) then return p end
  p = vim.fs.joinpath(".venv", "bin", python)
  if vim.uv.fs_stat(p) then return p end

  return python
end

return {
  before_init = function(_, config)
    local p = getPythonPath()
    vim.defer_fn(function() vim.notify("Python (pyright): " .. p) end, 300)
    config.settings.python.pythonPath = p
  end,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        -- ignore = { '*' },
        -- typeCheckingMode = "basic",
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
}

