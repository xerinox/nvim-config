return {
    {
        'VonHeikemen/lsp-zero.nvim',
        lazy = true,
        config = false,
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()
            lsp_zero.preset("recommended")

            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()

            require('luasnip.loaders.from_vscode').lazy_load()

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                preselect = 'item',
                completion = {
                    completeopt = 'menu, menuone, noinsert',
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'luasnip' },
                },

                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                })
            })
        end,
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
        },
        opts = {
            inlay_hints = { enabled = true },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
                    { buffer = bufnr, remap = false, desc = "Go to definition" })
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
                    { buffer = bufnr, remap = false, desc = "Show hover window" })
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
                    { buffer = bufnr, remap = false, desc = "Show workspace symbols" })
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
                    { buffer = bufnr, remap = false, desc = "Open diagnostics in float" })
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
                    { buffer = bufnr, remap = false, desc = "Go to next diagnostic" })
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
                    { buffer = bufnr, remap = false, desc = "Go to previous diagnostic" })
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
                    { buffer = bufnr, remap = false, desc = "List code actions" })
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
                    { buffer = bufnr, remap = false, desc = "Show references" })
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
                    { buffer = bufnr, remap = false, desc = "Rename object(context aware" })
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
                    { buffer = bufnr, remap = false, desc = "Signature help" })
                vim.keymap.set("n", "<leader>vh", function()
                    vim.lsp.inlay_hint.enable(nil, not vim.lsp.inlay_hint.is_enabled())
                end, { buffer = bufnr, remap = false, desc = "Toggle inlay hints" })
            end)
            lsp_zero.set_sign_icons({
              error = '✘',
              warn = '▲',
              hint = '⚑',
              info = '»'
            })
            vim.g.rustaceanvim = {
                server = {
                    capabilities = lsp_zero.get_capabilities(),
                    on_attach = function(client, bufnr)
                        vim.keymap.set("n", "<leader>vca", function() vim.cmd.RustLsp('codeAction') end,
                            { buffer = bufnr, desc = "Show code actions" })
                        vim.lsp.inlay_hint.enable(bufnr, true)
                        vim.cmd.RustLsp('renderDiagnostic')
                    end,
                }
            }
            require('mason-lspconfig').setup({
                ensure_installed = {
                    "rust_analyzer",
                },
                handlers = {
                    lsp_zero.default_setup,

                    rust_analyzer = lsp_zero.noop,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        lua_opts.settings.Lua.diagnostics.globals = { 'vim' }
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end
                }
            })
        end
    }
}
