-- Define a helper function to handle the diff logic.
-- Placing it here allows the keymap closures below to access it.

local function smart_diffget(direction)
  -- Look for fugitive buffers that include //2 or //3 in their names
  local has_fugitive_diff = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("//[23]$") then
      has_fugitive_diff = true
      break
    end
  end
  
  if has_fugitive_diff then
    -- We are in a fugitive session, use fugitive's syntax
    local target = (direction == 'left') and '//2' or '//3'
    vim.cmd('diffget ' .. target)
  else
    -- We are likely in a standard vimdiff/mergetool session.
    -- The layout is typically: 1=LOCAL, 2=BASE/MERGED, 3=REMOTE
    local target_buf = (direction == 'left') and '1' or '3'
    vim.cmd('diffget ' .. target_buf)
  end
end

return {
    "tpope/vim-fugitive",
    keys = {
        { "<leader>gs", "<cmd>Git<CR>", desc = "Git Status" },
        {
            "<leader>gf",
            function() smart_diffget('left') end,
            desc = "Diff/Merge: Get Left",
        },
        {
            "<leader>gj",
            function() smart_diffget('right') end,
            desc = "Diff/Merge: Get Right",
        },
    },
}
