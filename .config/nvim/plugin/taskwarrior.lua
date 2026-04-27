require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/ribelo/taskwarrior.nvim" },
    })

    local ok, tw = pcall(require, "taskwarrior_nvim")
    if not ok then return end
    tw.setup({})
end)
