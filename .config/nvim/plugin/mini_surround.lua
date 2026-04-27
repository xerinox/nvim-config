require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/echasnovski/mini.surround" },
    })

    local ok, surround = pcall(require, 'mini.surround')
    if not ok then return end
    surround.setup {}
end)
