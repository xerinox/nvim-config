require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/TheNoeTrevino/haunt.nvim" },
    })

    local ok_h, haunt_mod = pcall(require, "haunt")
    if not ok_h then return end
    haunt_mod.setup({
        sign = "󱙝",
        sign_hl = "DiagnosticInfo",
        virt_text_hl = "HauntAnnotation",
        annotation_prefix = " 󰆉 ",
        line_hl = nil,
        virt_text_pos = "eol",
        data_dir = nil,
        picker_keys = {
            delete = { key = "d", mode = { "n" } },
            edit_annotation = { key = "a", mode = { "n" } },
        },
    })

    local haunt = require("haunt.api")
    local haunt_picker = require("haunt.picker")
    local prefix = "<leader>h"

    vim.keymap.set("n", prefix .. "a", function() haunt.annotate() end, { desc = "Annotate" })
    vim.keymap.set("n", prefix .. "t", function() haunt.toggle_annotation() end, { desc = "Toggle annotation" })
    vim.keymap.set("n", prefix .. "T", function() haunt.toggle_all_lines() end, { desc = "Toggle all annotations" })
    vim.keymap.set("n", prefix .. "d", function() haunt.delete() end, { desc = "Delete bookmark" })
    vim.keymap.set("n", prefix .. "C", function() haunt.clear_all() end, { desc = "Delete all bookmarks" })
    vim.keymap.set("n", prefix .. "p", function() haunt.prev() end, { desc = "Previous bookmark" })
    vim.keymap.set("n", prefix .. "n", function() haunt.next() end, { desc = "Next bookmark" })
    vim.keymap.set("n", prefix .. "l", function() haunt_picker.show() end, { desc = "Show Picker" })
    vim.keymap.set("n", prefix .. "q", function() haunt.to_quickfix() end, { desc = "Quickfix all" })
    vim.keymap.set("n", prefix .. "Q", function() haunt.to_quickfix({ current_buffer = true }) end, { desc = "Quickfix buffer" })
    vim.keymap.set("n", prefix .. "y", function() haunt.yank_locations({ current_buffer = true }) end, { desc = "Yank buffer locations" })
    vim.keymap.set("n", prefix .. "Y", function() haunt.yank_locations() end, { desc = "Yank all locations" })
end)
