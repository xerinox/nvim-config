local function setbufsettings()
    vim.cmd([[let g:netrw_bufsettings = 'noma nomod nu relnu nobl nowrap ro']])
end
vim.api.nvim_create_autocmd('BufWinEnter', {
    once = true,
    pattern = "*",
    callback = setbufsettings
})
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
