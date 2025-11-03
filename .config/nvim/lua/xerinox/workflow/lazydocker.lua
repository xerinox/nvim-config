local M = {}

M.term_state = {
    win_id = nil,
    buf_id = nil,
}

local function get_git_root()
    local git_dir_path = vim.fn.findfile('.git', '.;')

    if git_dir_path and  git_dir_path ~= '' then
        return vim.fs.dirname(git_dir_path)
    end

    return vim.fn.getcwd()
end

function M.docker_client_toggle()
    local state = M.term_state

    if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
        vim.api.nvim_win_close(state.win_id, true)
        state.win_id = nil
        state.buf_id = nil
        return
    end

    local cmd = 'lazydocker'
    local git_root = get_git_root()

    local buf = vim.api.nvim_create_buf(false, true)
    state.buf_id = buf

    vim.bo[buf].bufhidden = 'wipe'

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        border = 'double',
        style = 'minimal',
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)
    state.win_id = win

    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', {
        buffer = buf,
        noremap = true,
        silent = true,
        desc = 'Exit terminal mode',
    })

    local function on_exit_callback()
        vim.schedule(function()
            if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
                vim.api.nvim_win_close(state.win_id, true)
            end
            state.win_id = nil
            state.buf_id = nil
        end)
    end

    vim.fn.termopen(cmd, {
        cwd = git_root,
        on_exit = on_exit_callback,
    })

    vim.cmd('startinsert')
end

function M.setup()
    vim.api.nvim_create_user_command('LazyDocker', M.docker_client_toggle, {desc = 'Toggle LazyDocker terminal'})
end

return M
