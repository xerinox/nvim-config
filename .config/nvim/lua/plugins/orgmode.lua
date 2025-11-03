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

return { {
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
                    org_toggle_checkbox = { '<C-c><C-c>' }
                }
            },
            org_agenda_files = { "~/notes/**/*" },
            org_default_notes_file = '~/notes/main.org',
            org_archive_location = '~/notes/archive/%s_archive::',
            org_todo_keywords = { 'TODO', 'NEXT', 'WAIT', '|', 'DONE', 'CANCEL' },
            org_pandoc_options = {
                {
                    option = '--filter',
                    value = 'pandoc-mermaid-filter',
                }
            },
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
        })
    end,
},
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("orgmode")

            vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
            vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
            vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
            vim.keymap.set("n", "<leader>off", function()
                require('telescope').extensions.orgmode.search_headings({
                    mode = "orgfiles"
                })
            end, {
                desc = "Find org files"
            })
        end,
    },
    {
        "chipsenkbeil/org-roam.nvim",
        tag = "0.1.1",
        dependencies = {
            "nvim-orgmode/orgmode",
        },
        config = function()
            require("org-roam").setup({
                directory = "~/notes/roam",
                org_files = {
                    "~/notes/*.org",
                },
                templates = {
                    d = {
                        description = "Default",
                        template = "%?",
                        target = "%<%Y%m%d%H%M%S>-%[slug].org"
                    },
                    t = {
                        description = "Todo (Inbox)",
                        template = "** TODO %?\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :CAPTURED_FROM: %a\n  :END:\n",
                        target = "inbox.org",
                        headline = "Tasks",
                        prepend = true,

                    },
                    f = {
                        description = "Fleeting Note (Inbox)",
                        template = "** %?\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :CAPTURED_FROM: %a\n  :END:\n",
                        target = "inbox.org",
                        headline = "Notes",
                        prepend = true,
                    },
                    u = {
                        description = "Question (Inbox)",
                        template = "** QUESTION %?\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :CAPTURED_FROM: %a\n  :END:\n",
                        target = "inbox.org",
                        headline = "Questions",
                        prepend = true,
                    },

                    m = {
                        description = "Meeting Note (Daily Journal)",
                        template = "** Meeting %[slug]\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :CAPTURED_FROM: %a\n  :END:\n  %?",
                        target = "daily/%<%Y-%m-%d>_journal.org",
                        prepend = true,
                    },

                    l = {
                        description = "Literature Note (Inbox)",
                        template = "** Literature Note: %?\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :END:\n  Source: \n  Link: \n\n  Quote/Excerpt:\n  #+begin_quote\n  \n  #+end_quote\n\n  My thoughts:\n\n  Keywords: \n  %a",
                        target = "inbox.org",
                        headline = "Literature Notes",
                        prepend = true,
                    },
                    r = {
                        description = "Research Item (Inbox)",
                        template = "** Research: %?\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :END:\n  Keywords: \n  Source: \n  Link: \n  Notes: \n  %a",
                        target = "inbox.org",
                        headline = "Research Items",
                        prepend = true,
                    },

                    s = {
                        description = "Code Snippet (Inbox)",
                        template = "** Code Snippet: %?\n  :PROPERTIES:\n  :CREATED: %<%Y-%m-%d %H:%M>\n  :END:\n  #+begin_src \n  \n  #+end_src\n  Description: \n  %a",
                        target = "inbox.org",
                        headline = "Code Snippets",
                        prepend = true,
                    }
                }

            })
        end

    }
}
