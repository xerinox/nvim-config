local function save_mark()
    local char = vim.fn.getcharstr()
    if char == '' or vim.startswith(char, '<') then return end
    local grapple = require('grapple')
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local tag_opts = { name = char }
    if cursor_pos and #cursor_pos == 2 then
        tag_opts.cursor = cursor_pos
    end
    grapple.tag(tag_opts)
    local filepath = vim.api.nvim_buf_get_name(0)
    local filename = vim.fn.fnamemodify(filepath, ':t')
    vim.notify("Marked " .. filename .. " with tag '" .. char .. "'")
end

local function open_mark()
    local char = vim.fn.getcharstr()
    if char == '' or vim.startswith(char, '<') then return end
    local grapple = require('grapple')
    if char == "'" then
        grapple.toggle_tags()
        return
    end
    grapple.select({ name = char })
end

require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/cbochs/grapple.nvim" },
    })

    vim.keymap.set('n', 'm', save_mark, { noremap = true, silent = true, desc = "Save Grapple Mark" })
    vim.keymap.set('n', "'", open_mark, { noremap = true, silent = true, desc = "Open Grapple Mark" })
end)
