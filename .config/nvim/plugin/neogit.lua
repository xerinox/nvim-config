require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/NeogitOrg/neogit" },
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/sindrets/diffview.nvim" },
    })

    vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })
end)
