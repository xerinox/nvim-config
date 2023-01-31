require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "help", "javascript", "typescript", "c", "lua", "rust", },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,


	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			},
			-- selection_modes = {
			-- ['@parameter.outer'] = 'v',
			-- ['@function.outer'] = 'V',
			-- ['@class.outer'] = '<c-v>',
			-- include_surrounding_whitespace = true,
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]a"] = "@parameter.outer",
			},
			goto_next_end = {
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[a"] = "@parameter.outer",
			},
			goto_previous_end = {
			}
		},
		lsp_interop = {
			enable = true,
			border = 'none',
			flaoting_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
	},

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}
require('treesitter-context').setup({
	mode = 'topline',
	line_numbers = true,
})

vim.cmd("highlight TreesitterContextBottom gui=underline guisp=#b595dd guibg=#1e1e2e guifg=#89b4fa")
vim.cmd("highlight ColorColumn guibg=#1e1e2e")
