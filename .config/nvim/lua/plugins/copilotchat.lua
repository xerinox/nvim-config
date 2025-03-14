return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim",        branch = "master" },
            { "nvim-telescope/telescope.nvim" },
        },
        build = "make tiktoken",
        opts = {
            question_header = "## User ",
            answer_header = "## Copilot ",
            error_header = "## Error ",
            mappings = {
                -- Use tab for completion
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options",
                    insert = "<Tab>",
                },
                close = {
                    normal = "q",
                    insert = "<C-c>",
                },
                reset = {
                    normal = "<C-x>",
                    insert = "<C-x>",
                },
                submit_prompt = {
                    normal = "<CR>",
                    insert = "<C-CR>",
                },
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>"
                }
            }
        },
        config = function(_, opts)
            local chat = require("CopilotChat")
            chat.setup(opts)

            local select = require("CopilotChat.select")
            vim.api.nvim_create_user_command("CopilotChatInline", function(args)
                chat.ask(args.args, {
                    selection = select.visual,
                    window = {
                        layout = "float",
                        relative = "cursor",
                        width = 1,
                        height = 0.4,
                        row = 1,
                    },
                })
            end, { nargs = "*", range = true })

            vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
                chat.ask(args.args, { selection = select.buffer })
            end, { nargs = "*", range = true })

            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "copilot-*",
                callback = function()
                    vim.opt_local.relativenumber = true
                    vim.opt_local.number = true

                    local ft = vim.bo.filetype
                    if ft == "copilot-chat" then
                        vim.bo.filetype = "markdown"
                    end
                end

            })
        end,
        event = "VeryLazy",
        keys = {
            -- Show prompts actions with telescope
            {
                "<leader>ap",
                function()
                    require("CopilotChat").select_prompt({
                        context = {
                            "buffers",
                        },
                    })
                end,
                desc = "CopilotChat - Prompt actions",
            },
            {
                "<leader>ap",
                function()
                    require("CopilotChat").select_prompt()
                end,
                mode = "x",
                desc = "CopilotChat - Prompt actions",
            },
            -- Code related commands
            { "<leader>ae", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
            { "<leader>at", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
            { "<leader>ar", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
            { "<leader>aR", "<cmd>CopilotChatRefactor<cr>",      desc = "CopilotChat - Refactor code" },
            { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
            -- Chat with Copilot in visual mode
            {
                "<leader>av",
                ":CopilotChatVisual",
                mode = "x",
                desc = "CopilotChat - Open in vertical split",
            },
            {
                "<leader>ax",
                ":CopilotChatInline<cr>",
                mode = "x",
                desc = "CopilotChat - Inline chat",
            },
            -- Custom input for CopilotChat
            {
                "<leader>ai",
                function()
                    local input = vim.fn.input("Ask Copilot: ")
                    if input ~= "" then
                        vim.cmd("CopilotChat " .. input)
                    end
                end,
                desc = "CopilotChat - Ask input",
            },
            -- Generate commit message based on the git diff
            {
                "<leader>am",
                "<cmd>CopilotChatCommit<cr>",
                desc = "CopilotChat - Generate commit message for all changes",
            },
            -- Quick chat with Copilot
            {
                "<leader>aq",
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        vim.cmd("CopilotChatBuffer " .. input)
                    end
                end,
                desc = "CopilotChat - Quick chat",
            },
            -- Debug
            { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>",     desc = "CopilotChat - Debug Info" },
            -- Fix the issue with diagnostic
            { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
            -- Clear buffer and chat history
            { "<leader>al", "<cmd>CopilotChatReset<cr>",         desc = "CopilotChat - Clear buffer and chat history" },
            -- Toggle Copilot Chat Vsplit
            { "<leader>av", "<cmd>CopilotChatToggle<cr>",        desc = "CopilotChat - Toggle" },
            -- Copilot Chat Models
            { "<leader>a?", "<cmd>CopilotChatModels<cr>",        desc = "CopilotChat - Select Models" },
            -- Copilot Chat Agents
            { "<leader>aa", "<cmd>CopilotChatAgents<cr>",        desc = "CopilotChat - Select Agents" },
        },
    }
}
