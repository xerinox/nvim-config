require("lazyload").on_vim_enter(function()
    vim.pack.add({
        { src = "https://github.com/folke/which-key.nvim" },
    })

    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.setup({})

    wk.add({
        -- Top-level groups
        { "<leader>a", group = "AI / Copilot" },
        { "<leader>b", desc = "Choose buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Haunt / Bookmarks" },
        { "<leader>l", group = "Lazy" },
        { "<leader>N", group = "Notifications / News" },
        { "<leader>o", group = "Org / Octo" },
        { "<leader>p", group = "Project / Find" },
        { "<leader>u", group = "UI Toggles" },
        { "<leader>v", group = "LSP" },
        { "<leader>x", group = "Trouble / Diagnostics" },

        -- Git subgroups
        { "<leader>gh", group = "GitHub" },
        { "<leader>ghc", group = "Commits" },
        { "<leader>ghi", group = "Issues" },
        { "<leader>ghl", group = "Litee" },
        { "<leader>ghp", group = "Pull Request" },
        { "<leader>ghr", group = "Review" },
        { "<leader>ght", group = "Threads" },
    })
end)
