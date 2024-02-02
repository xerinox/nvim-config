return {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
        { "<leader>gs", "<cmd>Git<CR>", desc = "Git Status" },
        { "<leader>gf", "<cmd>diffget //2<CR>", desc = "Git accept left change"},
        { "<leader>gj", "<cmd>diffget //3<CR>", desc = "Git accept right change"}
    },
}
