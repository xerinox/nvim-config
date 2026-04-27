require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/laytan/cloak.nvim" },
    })

    local ok, cloak = pcall(require, "cloak")
    if not ok then return end
    cloak.setup({
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        patterns = {
            {
                file_pattern = { ".env*", "wrangler.toml", ".dev.vars" },
                cloak_pattern = "=.+"
            },
        },
    })
end)
