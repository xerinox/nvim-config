require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/chomosuke/typst-preview.nvim" },
    })

    local ok, tp = pcall(require, "typst-preview")
    if not ok then return end
    tp.setup({
        dependencies_bin = { ['tinymist'] = 'tinymist' }
    })
end)
