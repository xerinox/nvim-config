local api = vim.api

api.nvim_set_keymap("v", "<leader>kz", ":'<,'>TZNarrow<CR>", {})
api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", {})
api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", {})
api.nvim_set_keymap("n", "<leader>kz", ":TZAtaraxis<CR>", {})
