require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/mrcjkb/rustaceanvim" },
    })

    vim.g.rustaceanvim = {
        server = {
            on_attach = function(client, bufnr)
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
                    { buffer = bufnr, remap = false, desc = "Go to definition" })
                vim.keymap.set("n", "K", function() vim.cmd.RustLsp({'hover', 'actions'}) end,
                    { buffer = bufnr, remap = false, desc = "Show hover window" })
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
                    { buffer = bufnr, remap = false, desc = "Show workspace symbols" })
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
                    { buffer = bufnr, remap = false, desc = "Open diagnostics in float" })
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
                    { buffer = bufnr, remap = false, desc = "Go to next diagnostic" })
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
                    { buffer = bufnr, remap = false, desc = "Go to previous diagnostic" })
                vim.keymap.set("n", "<leader>vca", function() vim.cmd.RustLsp('codeAction') end,
                    { buffer = bufnr, remap = false, desc = "List code actions" })
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
                    { buffer = bufnr, remap = false, desc = "Show references" })
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
                    { buffer = bufnr, remap = false, desc = "Rename object(context aware" })
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
                    { buffer = bufnr, remap = false, desc = "Signature help" })
                vim.keymap.set("n", "<leader>h",
                    function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                    { buffer = bufnr, remap = false, desc = "Toggle inlay hints" })
            end,
        },
    }
end)
