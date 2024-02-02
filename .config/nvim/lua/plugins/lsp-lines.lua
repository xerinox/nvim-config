return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    lazy = true,
    config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_text = false })
        vim.diagnostic.config({ virtual_lines = true })

        local virtual_lines_enabled = true
        vim.keymap.set("n",
            "<Leader>l",
            function()
                virtual_lines_enabled = not virtual_lines_enabled
                if (virtual_lines_enabled) then
                    print("Turned on virtual lines")
                else
                    print("Turned off virtual lines")
                end
                vim.diagnostic.config({
                    virtual_lines = virtual_lines_enabled,
                    virtual_text = not
                        virtual_lines_enabled
                })
            end, { desc = "Toggle Virtual lines" }
        )
    end,
}
