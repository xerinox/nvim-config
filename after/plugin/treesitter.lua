require'nvim-treesitter.configs'.setup {
	ensure_installed = {"javascript", "typescript", "help", "c", "lua", "rust", "vim"},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}
