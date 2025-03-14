return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { "saghen/blink.cmp" },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        opts = {
            inlay_hints = { enabled = true },
            diagnostics = {
                virtual_lines = true,
                virtual_text = false
            },
            setup = {
                rust_analyzer = function() return true end,
            }
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
                        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

                    --rust

                    vim.g.rustacejnvim = {
                        tools = {
                            float_win_config = {
                                auto_focus = true,
                            }
                        },
                        server = {
                            capabilities = vim.lsp.protocol.make_client_capabilities(),
                            ---@diagnostics disable-next-line: unused-local
                            on_attach = function(client, bufnr)
                                vim.keymap.set("n", "<leader>a", function()
                                    vim.cmd.RustLsp "codeAction"
                                end, { silent = true, buffer = bufnr, desc = "Code action" })

                                vim.keymap.set("n", "<leader>d", function()
                                    vim.cmd.RustLsp "openDocs"
                                    vim.notify("Opening docs")
                                end, { silent = true, buffer = bufnr, desc = "Open docs" })

                                vim.keymap.set("n", "<leader>d", function()
                                    vim.cmd.RustLsp "renderDiagnostic"
                                end, { silent = true, buffer = bufnr, desc = "Render diagnostic" })

                                vim.keymap.set("n", "<leader>i", function()
                                    vim.cmd.RustLsp "explainError"
                                end, { silent = true, buffer = bufnr, desc = "Explain error" })
                            end,

                        }
                    }
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    "rust_analyzer",
                    "pylsp"
                },
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                    rust_analyzer = function()
                    end,

                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = {
                                            'vim'
                                        }
                                    }
                                }
                            }
                        })
                    end
                }
            })
        end
    },
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        keys = function()
            local dap = require("dap")
            local widgets = require("dap.ui.widgets")
            return {
                {
                    "<leader>ds",
                    function() widgets.centered_float(widgets.scopes, { border = "rounded" }) end,
                    desc = "DAP Scopes",
                },
                {
                    "<F1>",
                    function() widgets.hover(nil, { border = "rounded" }) end,
                    desc = "DAP Hover",
                },
                { "<F4>",  dap.terminate,         desc = "DAP Terminate" },
                { "<F5>",  dap.continue,          desc = "DAP Continue" },
                { "<F6>",  dap.run_to_cursor,     desc = "Run to Cursor" },
                { "<F9>",  dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
                { "<F10>", dap.step_over,         desc = "Step Over" },
                { "<F11>", dap.step_into,         desc = "Step Into" },
                { "<F12>", dap.step_out,          desc = "Step Out" },
                { "<F17>", dap.run_last,          desc = "Run Last" },
                {
                    "<F21>",
                    function()
                        vim.ui.input(
                            { prompt = "Breakpoint condition: " },
                            function(input) dap.set_breakpoint(input) end
                        )
                    end,
                    desc = "Conditional Breakpoint",
                },
                {
                    "<A-r>",
                    function() dap.repl.toggle(nil, "tab split") end,
                    desc = "Toggle DAP REPL",
                },
            }
        end,
        config = function()
            -- Signs
            for _, group in pairs({
                "DapBreakpoint",
                "DapBreakpointCondition",
                "DapBreakpointRejected",
                "DapLogPoint",
            }) do
                vim.fn.sign_define(group, { text = "●", texthl = group })
            end

            -- Setup

            -- Decides when and how to jump when stopping at a breakpoint
            -- The order matters!
            --
            -- (1) If the line with the breakpoint is visible, don't jump at all
            -- (2) If the buffer is opened in a tab, jump to it instead
            -- (3) Else, create a new tab with the buffer
            --
            -- This avoid unnecessary jumps
            require("dap").defaults.fallback.switchbuf = "usevisible,usetab,newtab"
            require("dap").adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" }
                }

            }
        end,
    },
}
