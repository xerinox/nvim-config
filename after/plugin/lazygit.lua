local lg = require('telescope').extensions.lazygit
vim.keymap.set("n", "<leader>gg", function() lg.lazygit() end)
