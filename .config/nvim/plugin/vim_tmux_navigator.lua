require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/christoomey/vim-tmux-navigator" },
    })

    vim.keymap.set("n", "<m-h>",  "<cmd>TmuxNavigateLeft<cr>")
    vim.keymap.set("n", "<m-j>",  "<cmd>TmuxNavigateDown<cr>")
    vim.keymap.set("n", "<m-k>",  "<cmd>TmuxNavigateUp<cr>")
    vim.keymap.set("n", "<m-l>",  "<cmd>TmuxNavigateRight<cr>")
    vim.keymap.set("n", "<m-\\>", "<cmd>TmuxNavigatePrevious<cr>")
end)
