return {
    'nvim-telescope/telescope.nvim',
    tag          = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-project.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
    config       = function()
        require('telescope').setup({
            pickers = {
                buffers = {
                    show_all_buffers = true,
                    sort_mru = true,
                    mappings = {
                        i = {
                            ["<C-d>"] = "delete_buffer",
                        }
                    }
                }
            }
        })
        require 'telescope'.load_extension('project')
        require 'telescope'.load_extension('ui-select')
        require("telescope").load_extension("grapple")
    end,
    keys         = {
        { "<leader>b",  "<cmd>Telescope buffers<CR>",    desc = "Choose buffer" },
        { "<leader>pf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<C-p>",      "<cmd>Telescope git_files<CR>",  desc = "Find project files" },
        { "<leader>pw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find workspace symbols" },
        { "<leader>pS", "<cmd>Telescope live_grep<CR>",   desc = "Grep files" },
        { "<leader>pt", "<cmd>Telescope treesitter<CR>",  desc = "Treesitter symbols" },
        { "<leader>pc", "<cmd>Telescope commands<CR>",    desc = "Telescope commands" },
        {
            "<leader>ps",
            function()
                require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
            end,
            desc = "Grep files",
        },
        {
            "<leader>pp",
            function()
                local actions = require("CopilotChat.actions")

                require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            end,
            desc = "Copilot chat in telescope"
        },
        { "<leader>m", function() require("telescope").extensions.grapple.tags() end, noremap = true, silent = true, desc = "Browse Grapple Marks", mode = 'n'}
    }
}
