require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/stevearc/oil.nvim" },
        { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    })

    local ok, oil = pcall(require, 'oil')
    if not ok then return end
    oil.setup()
    vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Open Directory in Oil" })
end)
