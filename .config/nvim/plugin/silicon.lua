require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/narutoxy/silicon.lua" },
    })

    local ok, silicon = pcall(require, 'silicon')
    if not ok then return end
    silicon.setup({})
    vim.keymap.set('v', '<Leader>s', function() silicon.visualize_api() end)
end)
