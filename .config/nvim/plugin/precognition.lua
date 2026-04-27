require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/tris203/precognition.nvim" },
    })

    local ok, precog = pcall(require, "precognition")
    if not ok then return end
    precog.setup({ startVisible = false })
    vim.keymap.set("n", "<leader>;", function() require("precognition").peek() end, { desc = "Toggle jump hints" })
end)
