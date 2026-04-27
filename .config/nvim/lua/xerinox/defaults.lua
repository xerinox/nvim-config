local function setbufsettings()
    vim.cmd([[let g:netrw_bufsettings = 'noma nomod nu relnu nobl nowrap ro']])
end
vim.api.nvim_create_autocmd('BufWinEnter', {
    once = true,
    pattern = "*",
    callback = setbufsettings
})
function ColorMyPencils(color)
	color = color or "zenbones"
	vim.cmd.colorscheme(color)

if vim.g.neovide then
    vim.g.neovide_opacity = 0.8
    vim.g.neovide_normal_opacity = 0.8
    vim.g.neovide_cursor_animation_length = 0.05
end

--    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function SetupUndoTree()
    vim.cmd("packadd nvim.undotree")
    vim.keymap.set("n", "<leader>u", require("undotree").open)
end

SetupUndoTree()
