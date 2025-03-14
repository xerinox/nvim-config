return {
    'nvim-telescope/telescope.nvim',
    tag       = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-project.nvim' },
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
    end,
    keys         = {
        { "<leader>b",  "<cmd>Telescope buffers<CR>",    desc = "Choose buffer" },
        { "<leader>pf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<C-p>",      "<cmd>Telescope git_files<CR>",  desc = "Find project files" },
        {
            "<leader>ps",
            function()
                require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
            end,
            desc = "Grep files",
        },
        { "<leader>pp", function()
            local actions = require("CopilotChat.actions")

            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "Copilot chat in telescope"}
    }
}
