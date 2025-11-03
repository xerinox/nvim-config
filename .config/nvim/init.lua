require("xerinox")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.str' },
    callback = function()
        vim.bo.filetype = 'strudel'
    end,
    desc = 'Set filetype to strudel for .str files'
})

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
ColorMyPencils()
