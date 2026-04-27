require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/hamidi-dev/org-super-agenda.nvim" },
        { src = "https://github.com/lukas-reineke/headlines.nvim" },
    })

    require("headlines").setup()
    require("org-super-agenda").setup({
        org_directories     = {'/home/xerinox/notes'},
        todo_states         = {
            {
                name           = 'TODO',
                keymap         = 'ot',
                color          = '#FF5555',
                strike_through = false,
                fields         = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' },
            },
            {
                name           = 'PROGRESS',
                keymap         = 'op',
                color          = '#FFAA00',
                strike_through = false,
                fields         = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' },
            },
            {
                name           = 'WAITING',
                keymap         = 'ow',
                color          = '#BD93F9',
                strike_through = false,
                fields         = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' },
            },
            {
                name           = 'DONE',
                keymap         = 'od',
                color          = '#50FA7B',
                strike_through = true,
                fields         = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' },
            },
        },
        filter_reset_keymap = 'oa',
        window           = {
            width        = 0.8,
            height       = 0.7,
            border       = "rounded",
            title        = 'Super Agenda',
            title_pos    = 'center',
            margin_left  = 0,
            margin_right = 0,
        },
        groups              = {
            { name = "📅 Today", matcher = function(i) return i.scheduled and i.scheduled:is_today() end },
            { name = "🗓️ Tomorrow", matcher = function(i) return i.scheduled and i.scheduled:days_from_today() == 1 end },
            {
                name = "⏰ Deadlines",
                matcher = function(i)
                    return i.deadline ~= nil and i.todo_state ~= 'DONE' and not i:has_tag("personal")
                end,
            },
            {
                name = "⭐ Important",
                matcher = function(i)
                    return i.priority == "A" and (i.deadline ~= nil or i.scheduled ~= nil)
                end
            },
            {
                name = '⏳ Overdue',
                matcher = function(it)
                    return it.todo_state ~= 'DONE' and (
                        (it.deadline and it.deadline:is_past()) or
                        (it.scheduled and it.scheduled:is_past())
                    )
                end
            },
            { name = "🏠 Personal", matcher = function(item) return item:has_tag("personal") end },
            { name = "💼 Work", matcher = function(item) return item:has_tag("work") end },
            {
                name = "📆 Upcoming",
                matcher = function(it)
                    local days = require('org-super-agenda.config').get().upcoming_days or 10
                    local deadline_ok = it.deadline and it.deadline:days_from_today() >= 0 and it.deadline:days_from_today() <= days
                    local sched_ok = it.scheduled and it.scheduled:days_from_today() >= 0 and it.scheduled:days_from_today() <= days
                    return deadline_ok or sched_ok
                end
            },
        },
        hide_empty_groups   = false,
        keep_order          = false,
        allow_unsafe_groups = true,
        group_format        = '* %s',
        other_group_name    = 'Other',
        show_other_group    = false,
        show_tags           = true,
        inline_dates        = true,
        short_date_labels   = false,
        show_filename       = true,
        heading_order       = { 'filename', 'todo', 'headline', 'priority', 'date' },
        heading_max_length  = 70,
        upcoming_days       = 10,
    })
end)
