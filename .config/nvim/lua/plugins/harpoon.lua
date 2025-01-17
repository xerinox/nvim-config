return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED
    end,
    keys = {
        { "<leader>a", function() require('harpoon'):list():add() end, desc = "Add file to harpoon" },
        {
            "<C-e>",
            function()
                local harpoon = require('harpoon')
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Show harpoon",
        },
        { "<C-h>",     function() require('harpoon'):list():select(1) end },
        { "<C-j>",     function() require('harpoon'):list():select(2) end },
        { "<C-k>",     function() require('harpoon'):list():select(3) end },
    },
}
