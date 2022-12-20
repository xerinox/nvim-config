vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})
vim.keymap.set(
  "n",
  "<Leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)
