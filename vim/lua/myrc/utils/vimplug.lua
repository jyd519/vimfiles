local configs = {
  lazy = {},
  start = {},
}

local Plug = {
  begin = vim.fn["plug#begin"],

  -- "end" is a keyword, need something else
  ends = function()
    vim.fn["plug#end"]()

    for _, config in pairs(configs.start) do
      if type(config) == "function" then
        config()
      else
        local f = loadstring(config)
        f()
      end
    end
  end,
}

-- Not a fan of global functions, but it'll work better
-- for the people that will copy/paste this
_G.VimPlugApplyConfig = function(plugin_name)
  local fn = configs.lazy[plugin_name]
  if type(fn) == "function" then
    fn()
  end
  if type(fn) == "string" then
    local f = loadstring(fn)
    f()
  end
end

local plug_name = function(repo)
  return repo:match("[/\\]([%w-_.]+)$")
end

-- "Meta-functions"
local meta = {

  -- Function call "operation"
  __call = function(self, opts)
    local repo
    if type(opts) == "string" then
      repo = opts
      opts = vim.empty_dict()
    else
      repo = opts[1]
      table.remove(opts, 1)
      if next(opts) == nil then
        opts = vim.empty_dict()
      end
    end

    -- we declare some aliases for `do` and `for`
    opts["do"] = opts.run
    opts.run = nil

    opts["for"] = opts.ft
    opts.ft = nil

    vim.call("plug#", repo, opts)

    if opts.config then
      local plugin = opts.as or plug_name(repo)

      if opts["for"] == nil and opts.on == nil then
        configs.start[plugin] = opts.config
      else
        configs.lazy[plugin] = opts.config

        local user_cmd = [[ autocmd! User %s ++once lua VimPlugApplyConfig('%s') ]]
        vim.cmd(user_cmd:format(plugin, plugin))
      end
    end
  end,
}

-- https://github.com/junegunn/vim-plug/wiki/tips
-- augroup load_us_ycm
--   autocmd!
--   autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
--                      \| autocmd! load_us_ycm
-- augroup END

-- Meta-tables are awesome
return setmetatable(Plug, meta)
