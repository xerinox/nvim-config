return {
    'webhooked/kanso.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('kanso').setup({
            theme = "zen",
            background = {
                dark = "zen",
                light = "pearl"
            }
        })
    end,
}
