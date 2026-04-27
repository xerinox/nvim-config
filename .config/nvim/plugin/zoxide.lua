require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/nanotee/zoxide.vim" },
    })
end)
