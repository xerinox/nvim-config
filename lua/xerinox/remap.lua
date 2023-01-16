vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--Zen mode
vim.keymap.set("n", "<leader>zn", ":TZNarrow<CR>", {})
vim.keymap.set("v", "<leader>kz", ":'<,'>TZNarrow<CR>", {})
vim.keymap.set("n", "<leader>zm", ":TZMinimalist<CR>", {})
vim.keymap.set("n", "<leader>kz", ":TZAtaraxis<CR>", {})

--Keep position during search
vim.keymap.set("n", "Y", "yG$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--Paste over selection without changing registry content
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

--Delete to void
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

--Format buffer
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format({ braces = "k&r" })
end)

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

function Toggle_list()
	if vim.o.list == true then
		vim.o.list = false
	elseif vim.o.list == false then
		vim.o.list = true
	else
		vim.o.list = false
	end
end
vim.keymap.set('n', '<leader><F5>', ':lua Toggle_list()<CR>', {noremap = true, silent = true})
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<M-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<M-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<F12>", ":lua require'dap'.step_over()<cr>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<cr>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<cr>")
vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<cr>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<cr>")

local defaults = { noremap = true, silent = true };
vim.api.nvim_set_keymap("i", "jk", "<esc>l", defaults);
vim.keymap.set("n", "<leader><F12>", ":lua require'dapui'.toggle()<cr>")
