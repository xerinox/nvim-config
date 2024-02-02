return {
    "chrisgrieser/nvim-spider",
    lazy = true,
    config = function()
        require('spider').setup({
            subwordMovement = true,
        })
    end,
    keys = {
        {"w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" }},
    }
}
