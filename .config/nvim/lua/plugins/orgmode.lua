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
        }
    },
    event = { 'VeryLazy' },
    config = function()
        -- Load treesitter grammar for org
        require('orgmode').setup_ts_grammar()

        -- Setup treesitter
        require('nvim-treesitter.configs').setup({
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'org' },
            },
            ensure_installed = { 'org' },
        })
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
            org_todo_keywords = { 'TODO', 'NEXT', '|', 'DONE', 'CANCEL' },
            win_split_mode = "float",
            org_todo_keyword_faces = {
                NEXT = ':foreground yellow :weight bold',
                CANCEL = ':foreground magenta :weight bold'
            },

            org_capture_templates = templates,
        })
    end,
}
