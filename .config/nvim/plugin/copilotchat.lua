require("lazyload").on_event("InsertEnter", function()
    vim.pack.add({
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
    })

    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            if ev.data.spec.name == "CopilotChat.nvim" then
                vim.fn.system({ "make", "tiktoken", "-C", ev.data.path })
            end
        end,
    })

    local ok, chat_mod = pcall(require, "CopilotChat")
    if not ok then return end
    local chat = chat_mod
    chat.setup({
        question_header = "## User ",
        answer_header = "## Copilot ",
        error_header = "## Error ",
        model = "claude-sonnet-4.5",
        tools = "copilot",
        prompts = {
            Architecture = {
                prompt = "Discuss the architecture and design patterns in this code. What are the key design decisions and their implications? Focus on explaining the reasoning behind the structure.",
            },
            Alternatives = {
                prompt = "What are alternative approaches to solve this problem? Discuss the tradeoffs of each approach without making changes.",
            },
            Tradeoffs = {
                prompt = "Analyze the tradeoffs in this code. What are the pros and cons of the current approach? What would we gain or lose with different approaches?",
            },
            Security = {
                prompt = "Review this code for security implications. What potential vulnerabilities or concerns should I be aware of? Explain the security considerations.",
            },
            Performance = {
                prompt = "Discuss the performance characteristics of this code. What are the potential bottlenecks? What are the performance tradeoffs in the current implementation?",
            },
            Clarify = {
                prompt = "Help me understand this code. Explain what it does, why it might be structured this way, and the key concepts involved.",
            },
            Impact = {
                prompt = "If I were to change this code, what would be the potential impact? What other parts of the system might be affected?",
            },
            Dependencies = {
                prompt = "Explain the dependencies and relationships in this code. How does it interact with other components?",
            },
        },
        mappings = {
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
    })

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

    -- Keymaps
    vim.keymap.set("n", "<leader>ap", function()
        require("CopilotChat").select_prompt({ context = { "buffers" } })
    end, { desc = "CopilotChat - Prompt actions" })
    vim.keymap.set("x", "<leader>ap", function()
        require("CopilotChat").select_prompt()
    end, { desc = "CopilotChat - Prompt actions" })
    vim.keymap.set("n", "<leader>ae", "<cmd>CopilotChatExplain<cr>",       { desc = "CopilotChat - Explain code" })
    vim.keymap.set("n", "<leader>at", "<cmd>CopilotChatTests<cr>",         { desc = "CopilotChat - Generate tests" })
    vim.keymap.set("n", "<leader>ar", "<cmd>CopilotChatReview<cr>",        { desc = "CopilotChat - Review code" })
    vim.keymap.set("n", "<leader>aR", "<cmd>CopilotChatRefactor<cr>",      { desc = "CopilotChat - Refactor code" })
    vim.keymap.set("n", "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", { desc = "CopilotChat - Better Naming" })
    vim.keymap.set("n", "<leader>ac", "<cmd>CopilotChatClarify<cr>",       { desc = "CopilotChat - Clarify code" })
    vim.keymap.set("n", "<leader>aA", "<cmd>CopilotChatArchitecture<cr>",  { desc = "CopilotChat - Discuss architecture" })
    vim.keymap.set("n", "<leader>aT", "<cmd>CopilotChatTradeoffs<cr>",     { desc = "CopilotChat - Analyze tradeoffs" })
    vim.keymap.set("n", "<leader>as", "<cmd>CopilotChatSecurity<cr>",      { desc = "CopilotChat - Security review" })
    vim.keymap.set("n", "<leader>aP", "<cmd>CopilotChatPerformance<cr>",   { desc = "CopilotChat - Performance analysis" })
    vim.keymap.set("n", "<leader>aD", "<cmd>CopilotChatDependencies<cr>",  { desc = "CopilotChat - Explain dependencies" })
    vim.keymap.set("n", "<leader>aI", "<cmd>CopilotChatImpact<cr>",        { desc = "CopilotChat - Discuss impact" })
    vim.keymap.set("n", "<leader>aO", "<cmd>CopilotChatAlternatives<cr>",  { desc = "CopilotChat - Discuss alternatives" })
    vim.keymap.set("x", "<leader>av", ":CopilotChatVisual",               { desc = "CopilotChat - Open in vertical split" })
    vim.keymap.set("x", "<leader>ax", ":CopilotChatInline<cr>",           { desc = "CopilotChat - Inline chat" })
    vim.keymap.set("n", "<leader>ai", function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then vim.cmd("CopilotChat " .. input) end
    end, { desc = "CopilotChat - Ask input" })
    vim.keymap.set("n", "<leader>am", "<cmd>CopilotChatCommit<cr>",       { desc = "CopilotChat - Generate commit message for all changes" })
    vim.keymap.set("n", "<leader>aq", function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then vim.cmd("CopilotChatBuffer " .. input) end
    end, { desc = "CopilotChat - Quick chat" })
    vim.keymap.set("n", "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>",     { desc = "CopilotChat - Debug Info" })
    vim.keymap.set("n", "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", { desc = "CopilotChat - Fix Diagnostic" })
    vim.keymap.set("n", "<leader>al", "<cmd>CopilotChatReset<cr>",         { desc = "CopilotChat - Clear buffer and chat history" })
    vim.keymap.set("n", "<leader>av", "<cmd>CopilotChatToggle<cr>",        { desc = "CopilotChat - Toggle" })
    vim.keymap.set("n", "<leader>a?", "<cmd>CopilotChatModels<cr>",        { desc = "CopilotChat - Select Models" })
    vim.keymap.set("n", "<leader>aa", "<cmd>CopilotChatAgents<cr>",        { desc = "CopilotChat - Select Agents" })
end)
