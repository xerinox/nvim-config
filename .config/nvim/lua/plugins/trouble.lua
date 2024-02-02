return {
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup {
            icons = true,
        }
    end,
    keys = {
        { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { silent = true, noremap = true, desc = "Trouble" } }
    }
}
