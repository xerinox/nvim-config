require("lazyload").on_vim_enter(function()
    vim.pack.add({
        { src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/nvim-telescope/telescope-project.nvim" },
        { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
    })

    require('telescope').setup({
        pickers = {
            buffers = {
                show_all_buffers = true,
                sort_mru = true,
                mappings = {
                    i = { ["<C-d>"] = "delete_buffer" }
                }
            }
        }
    })
    require('telescope').load_extension('project')
    require('telescope').load_extension('ui-select')
    pcall(require('telescope').load_extension, "grapple")

    vim.keymap.set("n", "<leader>b",  "<cmd>Telescope buffers<CR>",    { desc = "Choose buffer" })
    vim.keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
    vim.keymap.set("n", "<C-p>",      "<cmd>Telescope git_files<CR>",  { desc = "Find project files" })
    vim.keymap.set("n", "<leader>pw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Find workspace symbols" })
    vim.keymap.set("n", "<leader>pS", "<cmd>Telescope live_grep<CR>",   { desc = "Grep files" })
    vim.keymap.set("n", "<leader>pt", "<cmd>Telescope treesitter<CR>",  { desc = "Treesitter symbols" })
    vim.keymap.set("n", "<leader>pc", "<cmd>Telescope commands<CR>",    { desc = "Telescope commands" })
    vim.keymap.set("n", "<leader>ps", function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Grep files" })
    vim.keymap.set("n", "<leader>pp", function()
        require("CopilotChat").select_prompt()
    end, { desc = "CopilotChat - Prompt actions (Telescope)" })
    vim.keymap.set("n", "<leader>m", function()
        require("telescope").extensions.grapple.tags()
    end, { noremap = true, silent = true, desc = "Browse Grapple Marks" })
end)
