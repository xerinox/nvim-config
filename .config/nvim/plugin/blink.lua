require("lazyload").on_vim_enter(function()
    vim.pack.add({
        { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
        { src = "https://github.com/rafamadriz/friendly-snippets" },
        { src = "https://github.com/giuxtaposition/blink-cmp-copilot" },
        { src = "https://github.com/L3MON4D3/LuaSnip" },
    })

    local ok, blink = pcall(require, "blink.cmp")
    if not ok then return end
    blink.setup({
        keymap = { preset = 'default' },
        snippets = { preset = 'luasnip' },
        enabled = function() return not vim.tbl_contains({ "markdown", "typr" }, vim.bo.filetype) end,
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
            kind_icons = {
                Copilot = "",
                Text = '󰉿',
                Method = '󰊕',
                Function = '󰊕',
                Constructor = '󰒓',
                Field = '󰜢',
                Variable = '󰆦',
                Property = '󰖷',
                Class = '󱡠',
                Interface = '󱡠',
                Struct = '󱡠',
                Module = '󰅩',
                Unit = '󰪚',
                Value = '󰦨',
                Enum = '󰦨',
                EnumMember = '󰦨',
                Keyword = '󰻾',
                Constant = '󰏿',
                Snippet = '󱄽',
                Color = '󰏘',
                File = '󰈔',
                Reference = '󰬲',
                Folder = '󰉋',
                Event = '󱐋',
                Operator = '󰪚',
                TypeParameter = '󰬛'
            }
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', "copilot" },
            per_filetype = {
                org = { 'orgmode' }
            },
            providers = {
                orgmode = {
                    name = 'Orgmode',
                    module = 'orgmode.org.autocompletion.blink',
                    fallbacks = { 'buffer' }
                },
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 100,
                    async = true,
                    transform_items = function(_, items)
                        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                        local kind_idx = #CompletionItemKind + 1
                        CompletionItemKind[kind_idx] = "Copilot"
                        for _, item in ipairs(items) do
                            item.kind = kind_idx
                        end
                        return items
                    end,
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
    })
end)
