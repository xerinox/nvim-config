require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/folke/todo-comments.nvim" },
    })

    local ok, todo = pcall(require, "todo-comments")
    if not ok then return end
    todo.setup({})
    vim.keymap.set("n", "<leader>td", "<cmd>TodoQuickFix<cr>", { desc = "Todo QuickFix" })
end)
