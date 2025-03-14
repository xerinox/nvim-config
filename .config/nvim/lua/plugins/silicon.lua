return {
    "narutoxy/silicon.lua",
    dependencies = {"nvim-lua/plenary.nvim"},
    lazy = false,
    config = function()
        local silicon = require('silicon');
        silicon.setup({})
        vim.keymap.set('v', '<Leader>s', function() silicon.visualize_api() end)
    end
}
