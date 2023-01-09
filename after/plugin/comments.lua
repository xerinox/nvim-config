require('nvim_comment').setup({
  marker_padding = true,
  comment_empty = false,
  create_mappings = true,
  line_mapping = "gcc",
  operator_mapping = "gc",
  comment_chunk_text_object = "ic"
})
require("todo-comments").setup()
