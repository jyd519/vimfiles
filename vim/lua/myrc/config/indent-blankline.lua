local api = vim.api

local filetype_exclude = {
    "lspinfo",
    "checkhealth",
    "help",
    "man",
    "qf",
    "startify",
    "markdown",
    "alpha",
    "dashboard",
    "neo-tree",
    "lazy"
}

require("ibl").setup(
    {
        indent = {
            char = "│"
        },
        -- filetype = { "python", "cpp", "c", "lua" },
        exclude = {
            filetypes = filetype_exclude,
            buftypes = {"terminal", "nofile"}
        },
        scope = {enabled = false}
    }
)
