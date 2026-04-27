return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0e1415',
				base01 = '#0e1415',
				base02 = '#818b8c',
				base03 = '#818b8c',
				base04 = '#d5e2e2',
				base05 = '#f8feff',
				base06 = '#f8feff',
				base07 = '#f8feff',
				base08 = '#ff9fc1',
				base09 = '#ff9fc1',
				base0A = '#9be9ed',
				base0B = '#a5ffad',
				base0C = '#d0fcff',
				base0D = '#9be9ed',
				base0E = '#b6fbff',
				base0F = '#b6fbff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#818b8c',
				fg = '#f8feff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#9be9ed',
				fg = '#0e1415',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#818b8c' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#d0fcff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#b6fbff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#9be9ed',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#9be9ed',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#d0fcff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffad',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d5e2e2' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d5e2e2' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#818b8c',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
