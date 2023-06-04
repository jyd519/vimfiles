Hydra(
    {
        name = "Switch colorscheme",
        mode = {"n"},
        body = "<leader>cc",
        config = {
            color = "pink",
            invoke_on_body = true,
            on_enter = function()
               print(vim.g.colors_name, vim.go.background)
            end,
            on_exit = function()
               print(vim.g.colors_name, vim.go.background)
            end
        },
        heads = {
            {"<left>", "<cmd>NextCS<cr>", {desc = "←"}},
            {"<right>", "<cmd>PreviousCS<cr>", {desc = "→"}},
            {
                "<space>",
                function()
                    if vim.o.background == "light" then
                        vim.o.background = "dark"
                    else
                        vim.o.background = "light"
                    end
                end,
                {desc = "dark/light"}
            },
            {"q", nil, {exit = true}}
        }
    }
)