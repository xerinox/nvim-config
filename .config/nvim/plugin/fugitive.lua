require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/tpope/vim-fugitive" },
    })

    local function smart_diffget(direction)
        local has_fugitive_diff = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:match("//[23]$") then
                has_fugitive_diff = true
                break
            end
        end
        if has_fugitive_diff then
            local target = (direction == 'left') and '//2' or '//3'
            vim.cmd('diffget ' .. target)
        else
            local target_buf = (direction == 'left') and '1' or '3'
            vim.cmd('diffget ' .. target_buf)
        end
    end

    vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git Status" })
    vim.keymap.set("n", "<leader>gf", function() smart_diffget('left') end, { desc = "Diff/Merge: Get Left" })
    vim.keymap.set("n", "<leader>gj", function() smart_diffget('right') end, { desc = "Diff/Merge: Get Right" })
end)
