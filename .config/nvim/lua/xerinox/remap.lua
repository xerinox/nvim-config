vim.g.mapleader = " "
vim.g.maplocalleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = "Browse files in folder"})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move line down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move line up"})

vim.keymap.set("n", "J", "mzJ`z", {desc = "Join line"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Screen down"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Screen up"})
vim.keymap.set("n", "n", "nzzzv", {desc = "Next search result"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Previous search result"})

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], {desc = "Replace content"})
vim.keymap.set("n", "<leader>p", [["+p]], {desc = "Paste from system clipboard"})

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], {desc = "Yank to system clipboard"})
vim.keymap.set("n", "<leader>Y", [["+Y]], {desc = "Yank line to system clipboard"})

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], {desc = "Delete without copy"})

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", {desc = "Sessionizer"})
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {desc = "LSP Format file"})

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {desc = "Next quickfix"})
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {desc = "Previous quickfix"})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {desc = "Next location"})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {desc = "Previous location"})

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "Search and replace"})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "make file executable"})
