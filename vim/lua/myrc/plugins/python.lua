return {
  {
    "stevanmilic/nvim-lspimport",
    ft = { "python" },
    enabled = vim.g.enabled_plugins.python == 1,
    config = function()
      vim.keymap.set("n", "<leader>xf", require("lspimport").import, { noremap = true, desc = "lsp import" })
    end,
  },
  {
    "neolooong/whichpy.nvim",
    enabled = vim.g.enabled_plugins.python == 1,
    config = function()
      require("whichpy").setup({})
      vim.api.nvim_create_user_command("PrintPythonPath", function(opts)
        local venv = require("whichpy.envs").current_selected_name()
        if not venv then return end
        print("Python: " .. venv)
      end, {})
    end,
  },
  {
    "AnsonH/copy-python-path.nvim",
    version = "*",
    cmd = { "CopyPythonPath" },
    keys = {
      { "<leader>yp", "<cmd>CopyPythonPath dotted<cr>", desc = "Copy Python Path" },
      { "<leader>yi", "<cmd>CopyPythonPath import<cr>", desc = "Copy Python Path import" },
    },
    enabled = vim.g.enabled_plugins.python == 1,
    config = function()
      vim.api.nvim_create_user_command("CopyDjangoTestCommand", function(opts)
        local copy_python_path = require("copy-python-path")
        local path = copy_python_path.get_path_under_cursor("dotted")
        local command = "python manage.py test --keepdb " .. path
        vim.fn.setreg("+", command)
        vim.notify_once(command, vim.log.levels.INFO)
      end, {})
    end,
  },
}
