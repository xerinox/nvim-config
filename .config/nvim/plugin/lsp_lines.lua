require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    })

    local ok, lsp_lines = pcall(require, "lsp_lines")
    if not ok then return end
    lsp_lines.setup()
    vim.diagnostic.config({ virtual_text = false })
    vim.diagnostic.config({ virtual_lines = true })

    local virtual_lines_enabled = true
    vim.keymap.set("n", "<Leader>vl", function()
        virtual_lines_enabled = not virtual_lines_enabled
        if virtual_lines_enabled then
            print("Turned on virtual lines")
        else
            print("Turned off virtual lines")
        end
        vim.diagnostic.config({
            virtual_lines = virtual_lines_enabled,
            virtual_text = not virtual_lines_enabled
        })
    end, { desc = "Toggle Virtual lines" })
end)
