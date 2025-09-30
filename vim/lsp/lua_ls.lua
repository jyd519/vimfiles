local function get_lua_library()
  local library = {}
  local path = vim.split(package.path, ";")

  -- this is the ONLY correct way to setup your path
  table.insert(path, "lua/?.lua")
  table.insert(path, "lua/?/init.lua")

  local function add(lib)
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
      local rp = vim.loop.fs_realpath(p)
      if rp then table.insert(library, rp) end
    end
  end

  -- add runtime
  add("$VIMRUNTIME")

  -- add your config
  add("$VIMFILES/lua")

  -- add plugins
  add("$VIMFILES/lazy/plenary.nvim/lua")
  add("$VIMFILES/lazy/nvim-cmp/lua")
  add("$VIMFILES/lazy/nvim-lspconfig/lua")
  -- TOO SLOW
  -- local paths = vim.api.nvim_get_runtime_file("", true)
  -- for _, p in pairs(paths) do
  --   table.insert(library, p)
  -- end
  table.insert(library, "${3rd}/luv/library")
  return library
end

return {
  root_dir = function(bufnr, on_dir)
    local primary =
      vim.fs.root(bufnr, { ".luarc.json", ".luarc.jsonc", ".project", "package.json", "pyproject.toml", ".git" })
    local fallback = vim.loop.cwd()
    on_dir(primary or fallback)
  end,
  on_init = function(client)
    if client.workspace_folders then
      if (vim.fs.root(0, "vimfiles") == nil) and (vim.fs.root(0, { ".luarc.json", ".luarc.jsonc" })) then return end
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "hs", "put", "vim" },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = get_lua_library(),
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
        -- maxPreload = 1000,
        -- preloadFileSize = 500,
        -- checkThirdParty = false,
      },
    })
  end,
  settings = {
    Lua = {
      hint = {
        enable = true,
        paramName = "Literal",
      },
      codeLens = {
        enable = true,
      },
    },
  },
}
