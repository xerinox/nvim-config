local M = {}

local vim_enter_queue = {}
local override_queue = {}
local vim_entered = false

local event_queues = {}
local event_fired = {}

local function drain(queue)
  local sync_cbs = {}
  local async_cbs = {}
  for _, entry in ipairs(queue) do
    if entry.sync then
      table.insert(sync_cbs, entry.fn)
    else
      table.insert(async_cbs, entry.fn)
    end
  end
  for _, fn in ipairs(sync_cbs) do
    fn()
  end
  for _, fn in ipairs(async_cbs) do
    vim.schedule(fn)
  end
end

function M.on_vim_enter(fn, opts)
  opts = opts or {}
  if vim_entered then
    if opts.sync then
      fn()
    else
      vim.schedule(fn)
    end
    return
  end
  table.insert(vim_enter_queue, { fn = fn, sync = opts.sync })
end

function M.on_event(event, fn, opts)
  opts = opts or {}
  local key = type(event) == "table" and table.concat(event, ",") or event
  if event_fired[key] then
    vim.schedule(fn)
    return
  end
  if not event_queues[key] then
    event_queues[key] = {}
    vim.api.nvim_create_autocmd(event, {
      once = true,
      callback = function()
        event_fired[key] = true
        drain(event_queues[key])
        event_queues[key] = nil
      end,
    })
  end
  table.insert(event_queues[key], { fn = fn, sync = opts.sync })
end

function M.on_override(fn)
  if vim_entered then
    vim.schedule(fn)
    return
  end
  table.insert(override_queue, { fn = fn, sync = false })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim_entered = true
    drain(vim_enter_queue)
    vim.schedule(function()
      drain(override_queue)
    end)
  end,
})

return M
