require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/chrisgrieser/nvim-spider" },
    })

    local ok, spider = pcall(require, 'spider')
    if not ok then return end
    spider.setup({ subwordMovement = true })
    vim.keymap.set("n", "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
end)
