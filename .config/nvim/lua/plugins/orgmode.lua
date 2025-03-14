local templates = {
    r = {
        description = "Repo",
        template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
        target = "~/notes/repos.org"
    },
    t = {
        description = "Todo",
        template = '* TODO %?\n %u',
        target = '~/notes/todo.org',
    },
    T = {
        description = "Todo with file link",
        template = "* TODO %?\n %u\n%a",
        target = "~/notes/todo.org",
    }
}

return {
    'nvim-orgmode/orgmode',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter', lazy = true },
        {
            'akinsho/org-bullets.nvim',
            lazy = true,
            config = function()
                require('org-bullets').setup({
                    symbols = {
                        headlines = { "◉", "○", "✸", "✿" },
                    }
                })
            end
        },
        {
            "dhruvasagar/vim-table-mode",
            keys = {
                { "<leader>tm", "<cmd>TableModeToggle<CR>" }
            }
        },
        {
            'danilshvalov/org-modern.nvim',
            lazy = true,
        },
        {
            "Saghen/blink.cmp"
        }
    },
    event = { 'VeryLazy' },
    ft = { 'org' },
    config = function()
        local Menu = require("org-modern.menu")

        -- Setup orgmode
        require('orgmode').setup({
            ui = {
                menu = {
                    handler = function(data)
                        Menu:new({
                            window = {
                                margin = { 1, 0, 1, 0 },
                                padding = { 0, 1, 0, 1 },
                                title_pos = "center",
                                border = "single",
                                zindex = 1000,
                            },
                            icons = {
                                separator = "➜",
                            },
                        }):open(data)
                    end,
                },
            },
            mappings = {
                org = {
                    org_toggle_checkbox = {'<C-c><C-c>'}
                }
            },
            org_agenda_files = { "~/notes/**/*" },
            org_default_notes_file = '~/notes/main.org',
            org_archive_location = '~/notes/archive/%s_archive::',
            org_todo_keywords = { 'TODO', 'NEXT', 'WAIT', '|', 'DONE', 'CANCEL' },
            win_split_mode = "float",
            org_todo_keyword_faces = {
                WAIT = ':foreground orange :weight bold',
                NEXT = ':foreground yellow :weight bold',
                CANCEL = ':foreground magenta :weight bold'
            },
            org_hide_leading_stars = true,
            org_blank_before_new_entry = { heading = true, plain_list_item = false },

            org_capture_templates = templates,
        })
        require("blink.cmp").setup({
            sources = {
                per_filetype = {
                    org = {'orgmode'}
                },
                providers = {
                    orgmode = {
                        name = 'Orgmode',
                        module = 'orgmode.org.autocompletion.blink',
                        fallbacks = { 'buffer' }
                    }
                }
            }
        })
    end,
}
