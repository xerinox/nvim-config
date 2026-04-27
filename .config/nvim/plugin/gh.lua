require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/folke/which-key.nvim" },
        { src = "https://github.com/ldelossa/gh.nvim" },
        { src = "https://github.com/ldelossa/litee.nvim" },
    })

    local ok_lib, litee_lib = pcall(require, 'litee.lib')
    if not ok_lib then return end
    litee_lib.setup()
    local ok_gh, litee_gh = pcall(require, 'litee.gh')
    if not ok_gh then return end
    litee_gh.setup({
        keymaps = {
            open = '<CR>',
            expand = 'zo',
            collapse = 'zc',
            goto_issue = 'gd',
            details = 'd',
            submit_comment = '<C-s>',
            actions = '<C-a>',
            resolve_thread = '<C-r>',
            goto_web = 'gx',
        },
    })

    local ok_wk, wk = pcall(require, "which-key")
    if ok_wk then
        wk.add {
            { '<leader>ghcc', '<cmd>GHCloseCommit<cr>', desc = 'Close' },
            { '<leader>ghce', '<cmd>GHExpandCommit<cr>', desc = 'Expand' },
            { '<leader>ghco', '<cmd>GHOpenToCommit<cr>', desc = 'Open To' },
            { '<leader>ghcp', '<cmd>GHPopOutCommit<cr>', desc = 'Pop Out' },
            { '<leader>ghcz', '<cmd>GHCollapseCommit<cr>', desc = 'Collapse' },
            { '<leader>ghip', '<cmd>GHPreviewIssue<cr>', desc = 'Preview' },
            { '<leader>ghlt', '<cmd>LTPanel<cr>', desc = 'Toggle Panel' },
            { '<leader>ghpc', '<cmd>GHClosePR<cr>', desc = 'Close' },
            { '<leader>ghpd', '<cmd>GHPRDetails<cr>', desc = 'Details' },
            { '<leader>ghpe', '<cmd>GHExpandPR<cr>', desc = 'Expand' },
            { '<leader>ghpo', '<cmd>GHOpenPR<cr>', desc = 'Open' },
            { '<leader>ghpp', '<cmd>GHPopOutPR<cr>', desc = 'PopOut' },
            { '<leader>ghpr', '<cmd>GHRefreshPR<cr>', desc = 'Refresh' },
            { '<leader>ghpt', '<cmd>GHOpenToPR<cr>', desc = 'Open To' },
            { '<leader>ghpz', '<cmd>GHCollapsePR<cr>', desc = 'Collapse' },
            { '<leader>ghrb', '<cmd>GHStartReview<cr>', desc = 'Begin' },
            { '<leader>ghrc', '<cmd>GHCloseReview<cr>', desc = 'Close' },
            { '<leader>ghrd', '<cmd>GHDeleteReview<cr>', desc = 'Delete' },
            { '<leader>ghre', '<cmd>GHExpandReview<cr>', desc = 'Expand' },
            { '<leader>ghrs', '<cmd>GHSubmitReview<cr>', desc = 'Submit' },
            { '<leader>ghrz', '<cmd>GHCollapseReview<cr>', desc = 'Collapse' },
            { '<leader>ghtc', '<cmd>GHCreateThread<cr>', desc = 'Create' },
            { '<leader>ghtn', '<cmd>GHNextThread<cr>', desc = 'Next' },
            { '<leader>ghtt', '<cmd>GHToggleThread<cr>', desc = 'Toggle' },
        }
    end
end)
