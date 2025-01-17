return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
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
            local cmp = require("cmp")
            local luasnip = require('luasnip')

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
                    { name = 'orgmode' },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        else
                            fallback()
                        end
                    end),
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.jumpable(1) then
                            luasnip.jump(1)
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        else
                            fallback()
                        end
                    end),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                })
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
        },
        opts = {
            inlay_hints = { enabled = true },
        },
        init = function()
            vim.opt.signcolumn = 'yes'
        end,
        config = function()
            local lsp_defaults = require('lspconfig').util.default_config
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )
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
                    vim.keymap.set("n", "<leader>vh",
                        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
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
    }
}
