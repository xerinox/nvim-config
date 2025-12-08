return {
    {
        'mason-org/mason.nvim',
        lazy = false,
        config = true,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { "saghen/blink.cmp" },
            { 'mason-org/mason.nvim' },
            { 'mason-org/mason-lspconfig.nvim' },
        },
        opts = {
            inlay_hints = { enabled = true },
            diagnostics = {
                virtual_lines = true,
                virtual_text = false
            },
            servers = {
                rust_analyzer = false,
            },
            setup = {
                rust_analyzer = function() return true end,
            },
        },
        init = function()
            vim.opt.signcolumn = 'yes'
        end,

        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
                        { buffer = opts.buffer, remap = false, desc = "Go to definition" })
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
                        { buffer = opts.buffer, remap = false, desc = "Show hover window" })
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
                        { buffer = opts.buffer, remap = false, desc = "Show workspace symbols" })
                    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
                        { buffer = opts.buffer, remap = false, desc = "Open diagnostics in float" })
                    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
                        { buffer = opts.buffer, remap = false, desc = "Go to next diagnostic" })
                    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
                        { buffer = opts.buffer, remap = false, desc = "Go to previous diagnostic" })
                    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
                        { buffer = opts.buffer, remap = false, desc = "List code actions" })
                    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
                        { buffer = opts.buffer, remap = false, desc = "Show references" })
                    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
                        { buffer = opts.buffer, remap = false, desc = "Rename object(context aware" })
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
                        { buffer = opts.buffer, remap = false, desc = "Signature help" })
                    vim.keymap.set("n", "<leader>h",
                        function()
                            local bufnr = vim.api.nvim_get_current_buf()
                            local clients = vim.lsp.get_clients({ bufnr = bufnr })
                            
                            -- Check if any attached client supports inlay hints
                            local has_inlay_hints = false
                            for _, client in ipairs(clients) do
                                if client.server_capabilities.inlayHintProvider then
                                    has_inlay_hints = true
                                    break
                                end
                            end
                            
                            if has_inlay_hints then
                                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                                print("Inlay hints " .. (vim.lsp.inlay_hint.is_enabled() and "enabled" or "disabled"))
                            else
                                print("No LSP client with inlay hint support attached")
                            end
                        end,
                        { buffer = opts.buffer, remap = false, desc = "Toggle inlay hints" })

                    -- rust keymaps are now set in rustaceanvim config
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    "pylsp",
                    "rust_analyzer"
                },
                automatic_installation = true,
                automatic_enable = {
                    exclude = { "rust_analyzer" }
                },
                handlers = {
                    function(server_name)
                        local capabilities = require('blink.cmp').get_lsp_capabilities()
                        require('lspconfig')[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    rust_analyzer = function() end,

                    lua_ls = function()
                        local capabilities = require('blink.cmp').get_lsp_capabilities()
                        require('lspconfig').lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { 'vim' }
                                    }
                                }
                            }
                        })
                    end
                }
            })
        end
    },
}
