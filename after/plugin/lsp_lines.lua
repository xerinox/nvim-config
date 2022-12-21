vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {only_current_line = true},
})

vim.keymap.set(
	"n",
	"<leader>l",
	require("lsp_lines").toggle,
	{ desc = "Toggle lsp_lines" }
)
