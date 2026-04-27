local vim = vim
local M = {}

-- A function to start work on a Jira ticket.
-- It fetches the ticket summary, transitions it to 'In Progress',
-- and creates a correctly named Git branch.
function M.create_branch()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local line_content = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1] or ""

    -- Try to extract issue key from current line
    local issue_key = string.match(line_content, '%[([A-Z]+%-[0-9]+)%]')

    -- Define the processing function
    local function process_issue(key)
        if not key or key == '' then
            vim.notify('Branch creation cancelled.', vim.log.levels.INFO)
            return
        end

        -- 1. Fetch issue summary for the branch name.
        local summary_cmd = 'jira-terminal detail ' .. key .. ' --fields summary'
        local summary_output = vim.fn.system(summary_cmd)

        -- Use the entire output as the summary since there's no prefix
        local summary = summary_output:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace

        if not summary or summary == '' then
            vim.notify('Failed to fetch Jira issue summary for ' .. key, vim.log.levels.ERROR)
            return
        end

        -- 2. Transition the issue to 'In Progress' in Jira.
        local transition_cmd = "jira-terminal transition 'In Progress' --ticket " .. key
        vim.fn.system(transition_cmd)
        vim.notify('Transitioned ' .. key .. ' to In Progress.', vim.log.levels.INFO)

        -- 3. Create a "slug" from the summary for a clean branch name.
        local summary_slug = summary:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')

        -- 4. Construct and check out the new branch.
        local branch_name = 'feature/' .. key .. '/' .. summary_slug
        local git_cmd = 'git checkout -b ' .. branch_name
        vim.fn.system(git_cmd)
        local push_cmd = 'git push -u origin ' .. branch_name
        vim.fn.system(push_cmd)
        vim.notify('Created and checked out branch: ' .. branch_name .. ' and set upstream to origin/' .. branch_name,  vim.log.levels.INFO)
    end

    -- Function to show Telescope with all Jira issues
    local function show_jira_issues()
        -- Only sync once
        M.jira_sync()
        local dashboard_file = vim.fn.expand('~/notes/work_dashboard.org')
        local path = require('plenary.path'):new(dashboard_file)
        if not path:exists() then
            vim.notify("Dashboard file does not exist: " .. dashboard_file, vim.log.levels.ERROR)
            return
        end
        local file_content = path:read()
        if not file_content then
            vim.notify("Failed to read dashboard file: " .. dashboard_file, vim.log.levels.ERROR)
            return
        end

        local entries = {}
        line_num = 0
        for line in file_content:gmatch("[^\r\n]+") do
            line_num = line_num + 1
            -- Look for lines with TODO and Jira issue links
            if line:match('%*%* TODO') then
                -- Extract issue key from format [[URL][KEY]]
                local found_key = string.match(line, '%[%[.*/browse/([A-Z]+%-[0-9]+)%]%[%1%]%]')
                if found_key then
                    local title = line:match('%*%* TODO%s+(.-)%s+%[%[')
                    if title then
                        table.insert(entries, {
                            text = line,
                            lnum = line_num,
                            col = 1,
                            filename = dashboard_file,
                            issue_key = found_key,
                            display = title .. ' (' .. found_key .. ')'
                        })
                    end
                end
            end
        end

        if #entries == 0 then
            vim.notify('No Jira issues found in the dashboard', vim.log.levels.WARN)
            return
        end

        require('telescope.pickers').new({
            prompt_title = 'Search for Jira Issues',
            finder = require('telescope.finders').new_table({
                results = entries,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.display,
                        ordinal = entry.display,
                        filename = entry.filename,
                        lnum = entry.lnum,
                        col = entry.col,
                        issue_key = entry.issue_key,
                    }
                end
            }),
            sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
            attach_mappings = function(_, map)
                map('i', '<CR>', function(prompt_bufnr)
                    local selection = require('telescope.actions.state').get_selected_entry()
                    require('telescope.actions').close(prompt_bufnr)
                    if selection then
                        local selected_key = selection.issue_key
                        if selected_key then
                            process_issue(selected_key)
                        else
                            vim.notify('No valid Jira issue key found in selection.', vim.log.levels.ERROR)
                        end
                    end
                    return true
                end)
                return true
            end
        }):find()
    end

    -- If we found the key in the current line, use it directly
    if issue_key then
        process_issue(issue_key)
    else
        -- If no issue key on current line, show all issues
        vim.notify('No issue key found on current line, showing all issues', vim.log.levels.INFO)
        show_jira_issues()
    end
end

function M.add_jira_comment()
    local headline = require('orgmode').api.current():get_closest_headline()
    if not headline then
        vim.notify('No headline found to add a comment.', vim.log.levels.ERROR)
        return
    end

    local issue_key = headline:get_property("ID")
    if not issue_key or issue_key == '' then
        vim.notify('No Jira issue key found in the headline.', vim.log.levels.ERROR)
        return
    end

    vim.ui.input({ prompt = 'Enter your comment for ' .. issue_key .. ': ' }, function(comment)
        if not comment or comment == '' then return end

        local cmd = string.format("jira-terminal comment '%s' --ticket %s", comment, issue_key)
        vim.fn.system(cmd)
        vim.notify('Added comment to ' .. issue_key, vim.log.levels.INFO)
    end)
end

function M.jira_sync()
    local dashboard_file = vim.fn.expand('~/notes/work_dashboard.org')
    local dashboard_marker = '* Current Jira Issues'

    vim.notify('Syncing Jira issues...', vim.log.levels.INFO)

    local cmd = 'jira-terminal list --me --json'
    local json_output = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        vim.notify('Failed to fetch Jira issues: ' .. json_output, vim.log.levels.ERROR)
        return
    end

    local ok, issues = pcall(vim.json.decode, json_output)
    if not ok or type(issues) ~= 'table' then
        vim.notify('Failed to parse Jira issues: ' .. json_output, vim.log.levels.ERROR)
        return
    end

    local org_lines = { dashboard_marker, '' }

    for _, issue in ipairs(issues) do
        local jira_host = 'https://opscomsystems.atlassian.net'
        local link = string.format('[[%s/browse/%s][%s]]', jira_host, issue.key, issue.key)
        table.insert(org_lines, string.format('** TODO %s %s', issue.summary, link))
        table.insert(org_lines, '    :PROPERTIES:')
        table.insert(org_lines, string.format('    :ID:          %s', issue.key))
        table.insert(org_lines, string.format('    :Status:      %s', issue.status))
        table.insert(org_lines, string.format('    :Priority:    %s', issue.priority))
        table.insert(org_lines, '    :END:')
        table.insert(org_lines, '')
    end

    -- Simply write the new content directly to the file
    local out_file = io.open(dashboard_file, 'w')
    if out_file then
        out_file:write(table.concat(org_lines, '\n'))
        out_file:close()
        vim.notify('Updated dashboard file: ' .. dashboard_file, vim.log.levels.INFO)
    else
        vim.notify('Failed to write to dashboard file: ' .. dashboard_file, vim.log.levels.ERROR)
    end
end

-- Create a user command for easy access.
vim.api.nvim_create_user_command('JiraStart', M.create_branch, {})
vim.api.nvim_create_user_command('JiraSync', M.jira_sync, {})

return M
