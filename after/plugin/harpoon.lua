local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
require("telescope").load_extension('harpoon')

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader><C-E>", function()
	vim.cmd('Telescope harpoon marks')
end)
vim.keymap.set("n", "<leader>da", mark.rm_file)
vim.keymap.set("n", "<leader>ca", mark.clear_all)

vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end)


require("harpoon").setup({
	menu = {
		width = math.floor(vim.api.nvim_win_get_width(0) / 1.25),
	}
})

