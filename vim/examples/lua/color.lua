local telescope_actions = require("telescope.actions")

-- kitty @ set-colors -c ~/.config/kitty/kitty-themes/themes/PencilLight.conf

-- this is our single source of truth created above
local config_dir = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

local themes_dir = vim.fn.expand(config_dir .. "/kitty/kitty-themes/themes")
print(themes_dir)
-- this function is the only way we should be setting our colorscheme
local function set_colorscheme(name)
  -- write our colorscheme back to our single source of truth
  -- vim.fn.writefile({name}, base16_theme_fname)
  -- set Neovim's colorscheme
  -- vim.cmd('colorscheme '..name)
  -- execute `kitty @ set-colors -c <color>` to change terminal window's
  -- colors and newly created terminal windows colors
  print(string.format(themes_dir .. "/%s.conf", name))
  vim.loop.spawn("kitty", {
    args = {
      "@",
      "set-colors",
      "-c",
      string.format(themes_dir .. "/%s.conf", name),
    },
  }, function(code, signal) -- on exit
    print("exit code", code)
    print("exit signal", signal)
  end)
end

set_colorscheme("OneDark")

vim.keymap.set("n", "<leader>c", function()
  -- get our base16 colorschemes
  local colors = vim.fn.getcompletion("base16", "color")
  -- we're trying to mimic VSCode so we'll use dropdown theme
  local theme = require("telescope.themes").get_dropdown()
  -- create our picker
  require("telescope.pickers")
    .new(theme, {
      prompt = "Change Base16 Colorscheme",
      finder = require("telescope.finders").new_table({
        results = colors,
      }),
      sorter = require("telescope.config").values.generic_sorter(theme),
      -- attach_mappings = function(bufnr)
      --     -- change the colors upon selection
      --     telescope_actions.select_default:replace(function()
      --         set_colorscheme(action_state.get_selected_entry().value)
      --         telescope_actions.close(bufnr)
      --     end)
      --     telescope_action_set.shift_selection:enhance({
      --         -- change the colors upon scrolling
      --         post = function()
      --             set_colorscheme(action_state.get_selected_entry().value)
      --         end
      --     })
      --     return true
      -- end
    })
    :find()
end)
