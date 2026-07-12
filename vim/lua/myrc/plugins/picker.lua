local g = vim.g

local extra_cmds = {}
local extra_keys = {}

if g.mysnippets_dir then
  table.insert(extra_cmds, "Ft")
  table.insert(extra_keys, { "<leader>ft", "<cmd>Ft<cr>", desc = "Find templates" })
end
if g.notes_dir then
  table.insert(extra_cmds, "Notes")
  table.insert(extra_keys, { "<leader>fn", "<cmd>Notes<cr>", desc = "Find notes" })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = g.enabled_plugins.telescope == 1,
    cmd = vim.list_extend({ "Telescope", "Grep", "FindInPlugins", "Maps", "Colors" }, extra_cmds),
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "piersolenski/telescope-import.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = vim.fn.executable("cmake") == 1,
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    keys = vim.list_extend({
      { "<leader>xa", function() require("telescope.builtin").diagnostics({}) end, desc = "Show all diagnostics" },
      { "<leader>xb", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Show buffer diagnostics" },
      { "<leader>rf", function() require("telescope").extensions.refactoring.refactors() end, mode = "v", desc = "Refactoring" },
      { "<leader>fx", function() require("telescope.builtin").quickfix({ bufnr = 0 }) end, desc = "Find in Quickfix" },
      { "<leader>fm", function() require("telescope").extensions.bookmarks.list({ bufnr = 0 }) end, desc = "Find in bookmarks" },
      { "<leader>f.", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find Files in current directory" },
      { "<leader>fw", function() require("telescope.builtin").grep_string({}) end, desc = "Grep the current word" },
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find in oldfiles" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
      { "<leader>fgf", "<cmd>Telescope git_files<cr>", desc = "Find in git files" },
      { "<leader>fgc", "<cmd>Telescope git_commits<cr>", desc = "Find in Git commits" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find lsp symbols" },
      { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Find lsp implementations" },
      { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "List Colorschemes" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "List buffers" },
      {
        "<leader>fp",
        function()
          require("lazy").load({ plugins = { "project.nvim" } })
          vim.schedule(function() vim.cmd("Telescope projects") end)
        end,
        desc = "Find projects",
      },
      { "<leader>fv", function() require("telescope.builtin").find_files({ cwd = g.VIMFILES }) end, desc = "Find vimfiles" },
      { "<leader>fd", function() require("telescope.builtin").find_files({ cwd = g.VIMFILES .. "/doc" }) end, desc = "Find vim docs" },
      { "<leader>gd", function() require("telescope.builtin").git_status() end, desc = "Find git diff" },
    }, extra_keys),
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")

      telescope.setup({
        defaults = {
          filesize_limit = 2,
          mappings = {
            n = {
              ["<M-p>"] = action_layout.toggle_preview,
            },
            i = {
              ["<M-p>"] = action_layout.toggle_preview,
              ["<C-u>"] = false,
              ["<esc>"] = actions.close,
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
          import = { insert_at_top = true },
        },
        pickers = {
          buffers = {
            theme = "dropdown",
            previewer = false,
            sort_mru = true,
          },
          find_files = {
            mappings = {
              n = {
                ["cd"] = function(prompt_bufnr)
                  local selection = require("telescope.actions.state").get_selected_entry()
                  local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                  actions.close(prompt_bufnr)
                  vim.cmd(string.format("silent lcd %s", dir))
                end,
              },
            },
          },
          git_branches = {
            mappings = {
              i = {
                ["<CR>"] = function(prompt_bufnr)
                  local entry = require("telescope.actions.state").get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.cmd("DiffviewOpen " .. entry.name)
                end,
              },
            },
          },
          git_commits = {
            mappings = {
              i = {
                ["<CR>"] = function(prompt_bufnr)
                  local entry = require("telescope.actions.state").get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.cmd(("DiffviewOpen %s^!"):format(entry.value))
                end,
                ["<C-d>"] = function(prompt_bufnr)
                  local entry = require("telescope.actions.state").get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.cmd("DiffviewOpen " .. entry.value)
                end,
              },
            },
          },
        },
      })

      telescope.load_extension("ui-select")
      telescope.load_extension("bookmarks")
      telescope.load_extension("fzf")
      telescope.load_extension("projects")

      local cmd = vim.api.nvim_create_user_command

      vim.cmd([[com! Maps :Telescope keymaps]])
      vim.cmd([[com! Colors :Telescope colorscheme]])

      cmd("FindInPlugins", function(args)
        require("telescope.builtin").find_files({
          cwd = g.VIMFILES .. "/lazy/",
          search_file = args.args,
        })
      end, { nargs = "*", desc = "Find files in plugins" })

      cmd("Grep", function(args)
        local builtin = require("telescope.builtin")
        if args.args ~= "" then
          builtin.grep_string({ search = args.args })
        else
          builtin.live_grep()
        end
      end, { nargs = "*", desc = "Live grep" })

      if g.mysnippets_dir then
        cmd("Ft", function(opts)
          local find_opts = {
            prompt_title = "Find a template",
            layout_config = {
              width = 0.80,
              height = 0.60,
              preview_cutoff = 120,
              horizontal = { mirror = false },
              vertical = { mirror = false },
            },
            attach_mappings = function()
              local action_state = require("telescope.actions.state")
              local a = require("telescope.actions")
              a.select_default:replace(function(prompt_bufnr)
                a.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local file = selection.cwd .. "/" .. selection[1]
                vim.cmd("read " .. file)
              end)
              return true
            end,
          }
          local dir = g.mysnippets_dir
          local ft = vim.o.filetype
          if ft == "" or opts.args == "a" or opts.args == "all" then
            find_opts["cwd"] = dir
          else
            if vim.fn.isdirectory(dir .. "/" .. ft) == 1 then
              find_opts["cwd"] = dir .. "/" .. ft
            else
              find_opts["cwd"] = dir
            end
          end
          require("telescope.builtin").find_files(find_opts)
        end, { nargs = "*", desc = "Select a template to use" })
      end

      if g.notes_dir then
        cmd("Notes", function(opts)
          local find_opts = {}
          local cwd = g.notes_dir
          if vim.fn.isdirectory(cwd .. "/" .. opts.args) == 1 then
            find_opts["cwd"] = cwd .. "/" .. opts.args
          else
            find_opts["cwd"] = cwd
            find_opts["search_file"] = opts.args
          end
          require("telescope.builtin").find_files(find_opts)
        end, {
          nargs = "*",
          complete = function()
            return vim.fn.map(vim.fn.globpath(g.notes_dir, "*", false), "v:val[len(g:notes_dir)+1:]")
          end,
          desc = "Find and view notes",
        })
      end
    end,
  },
}
