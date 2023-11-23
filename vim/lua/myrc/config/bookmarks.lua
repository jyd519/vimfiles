local bm = require("bookmarks")

local toggle = function()
    if vim.bo.filetype == "nerdtree" then
        return
    end
    bm.bookmark_toggle()
end

bm.setup(
    {
        on_attach = function()
            local map = vim.keymap.set
            map("n", "mt", toggle) -- add or remove bookmark at current line
            map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
            map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
            map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
            map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
            map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
        end
    }
)
