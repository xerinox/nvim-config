require("lazyload").on_vim_enter(function()
    vim.pack.add({
        { src = "https://github.com/nvim-lualine/lualine.nvim" },
    })

    local ok, lualine = pcall(require, 'lualine')
    if not ok then return end
    lualine.setup { options = { theme = 'zenbones' } }
end, { sync = true })
