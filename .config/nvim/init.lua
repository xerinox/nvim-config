require("xerinox")

vim.api.nvim_create_user_command("PackUpdate", function() vim.pack.update() end, {})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.str' },
    callback = function()
        vim.bo.filetype = 'strudel'
    end,
    desc = 'Set filetype to strudel for .str files'
})
