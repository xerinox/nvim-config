require("lazyload").on_event("BufReadPost", function()
    vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
            if ev.data.spec.name == "nvim-treesitter" then
                vim.cmd("TSUpdate")
            end
        end,
    })

    vim.pack.add({
        { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
    })

    local ok, ts = pcall(require, 'nvim-treesitter')
    if not ok then return end
    ts.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "python", "latex", "regex" },
        sync_install = false,
        auto_install = true,
        ignore_install = { "javascript" },
        highlight = {
            enable = true,
            disable = function(lang, buf)
                local max_filesize = 100 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = { 'org' },
        },
    }
    ts.install({ 'c', 'lua', 'vim', 'vimdoc', 'query', 'rust', 'python', 'latex', 'regex' })

    vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true, desc = "Jump out one context" })
end)
