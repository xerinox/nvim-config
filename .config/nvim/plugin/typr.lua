require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/nvzone/typr" },
        { src = "https://github.com/nvzone/volt" },
    })
end)
