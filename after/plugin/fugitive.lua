vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>");

local XerinoX_Fugitive = vim.api.nvim_create_augroup("XerinoX_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
	group = XerinoX_Fugitive,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local opts = {buffer = bufnr, remap = false}
		vim.keymap .set("n", "<leader>p", function()
			vim.cmd.Git('push')
		end, opts)

		vim.keymap.set("n", "<leader>P", function()
			vim.cmd.Git('pull')
		end, opts)

		--set upstream tracking branch
		vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
	end
})
