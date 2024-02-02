return {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    keys = {
        { "[c", function() require("treesitter-context").go_to_context(vim.v.count1) end, { silent = true, desc = "Jump out one context" } }
    },
}
