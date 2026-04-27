-- Colorschemes load eagerly (no VimEnter deferral)
vim.pack.add({
    { src = "https://github.com/zenbones-theme/zenbones.nvim" },
    { src = "https://github.com/rktjmp/lush.nvim" },
    { src = "https://github.com/RRethy/base16-nvim" },
})

-- dankcolors base16 setup
require('base16-colorscheme').setup({
    base00 = '#0f1416',
    base01 = '#0f1416',
    base02 = '#8a9395',
    base03 = '#8a9395',
    base04 = '#e3eef1',
    base05 = '#f8fdff',
    base06 = '#f8fdff',
    base07 = '#f8fdff',
    base08 = '#ff9fbf',
    base09 = '#ff9fbf',
    base0A = '#a1eafd',
    base0B = '#a5ffae',
    base0C = '#cef5ff',
    base0D = '#a1eafd',
    base0E = '#b2efff',
    base0F = '#b2efff',
})

vim.api.nvim_set_hl(0, 'Visual', { bg = '#8a9395', fg = '#f8fdff', bold = true })
vim.api.nvim_set_hl(0, 'Statusline', { bg = '#a1eafd', fg = '#0f1416' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8a9395' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cef5ff', bold = true })
vim.api.nvim_set_hl(0, 'Statement', { fg = '#b2efff', bold = true })
vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#a1eafd', bold = true })
vim.api.nvim_set_hl(0, 'Macro', { fg = '#a1eafd', italic = true })
vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })
vim.api.nvim_set_hl(0, 'Type', { fg = '#cef5ff', bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })
vim.api.nvim_set_hl(0, 'String', { fg = '#a5ffae', italic = true })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#e3eef1' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#e3eef1' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#8a9395', italic = true })

local current_file_path = vim.fn.stdpath("config") .. "/plugin/colorscheme.lua"
if not _G._matugen_theme_watcher then
    local uv = vim.uv or vim.loop
    _G._matugen_theme_watcher = uv.new_fs_event()
    _G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
        dofile(current_file_path)
        print("Theme reload")
    end))
end

ColorMyPencils()
