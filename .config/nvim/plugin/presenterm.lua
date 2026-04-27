require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/Piotr1215/presenterm.nvim" },
    })

    local ok, presenterm = pcall(require, "presenterm")
    if not ok then return end
    presenterm.setup({ default_keybindings = true })
end)
