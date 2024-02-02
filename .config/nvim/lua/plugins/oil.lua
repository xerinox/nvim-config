return {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {{ "nvim-tree/nvim-web-devicons", lazy = true }},
    config = function()
        require('oil').setup()
    end,
    keys = {
        { "<leader>pv", "<cmd>Oil<CR>", desc = "Open Directory in Oil", mode = "n" }
    }
}
