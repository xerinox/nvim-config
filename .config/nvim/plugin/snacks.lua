---@diagnostic disable: undefined-global
vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
    animate = { enabled = true },
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    debug = { enabled = true },
    dim = { enabled = true },
    gh = {},
    git = { enabled = true },
    gitbrowse = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    keymap = { enabled = true },
    notifier = { enabled = true, timeout = 5000 },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
    styles = {
        notification = {
            wo = { wrap = true }
        }
    }
})

vim.keymap.set("n", "<leader>z",  function() Snacks.zen() end,                              { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>Z",  function() Snacks.zen.zoom() end,                         { desc = "Toggle Zoom" })
vim.keymap.set("n", "<leader>.",  function() Snacks.scratch() end,                          { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>S",  function() Snacks.scratch.select() end,                   { desc = "Select Scratch Buffer" })
vim.keymap.set("n", "<leader>Nn", function() Snacks.notifier.show_history() end,            { desc = "Notification History" })
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end,                        { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end,               { desc = "Rename File" })
vim.keymap.set({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end,               { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end,                   { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>gL", function() Snacks.lazygit.log_file() end,                 { desc = "Lazygit Current File History" })
vim.keymap.set("n", "<leader>gi", function() Snacks.picker.gh_issue() end,                  { desc = "Github issues (open)" })
vim.keymap.set("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "Github Issues (all)" })
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr() end,                     { desc = "Github Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end,    { desc = "Github Pull Requests (all)" })
vim.keymap.set("n", "<leader>gu", function() Snacks.picker.undo() end,                      { desc = "Undo tree" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end,                          { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end,                      { desc = "Lazygit Log (cwd)" })

vim.keymap.set("n", "<c-/>",      function() Snacks.terminal() end,                         { desc = "Toggle Terminal" })
vim.keymap.set("n", "<c-_>",      function() Snacks.terminal() end,                         { desc = "which_key_ignore" })
vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end,          { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end,         { desc = "Prev Reference" })
vim.keymap.set("n", "<leader>ld", function()
    local git_root = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
    if vim.v.shell_error ~= 0 then
        vim.notify("Not inside a git repository", vim.log.levels.ERROR)
        git_root = nil
    end
    local opts = {
        cwd = git_root,
        win = {
            border = "double",
            relative = "editor",
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.8),
        }
    }
    Snacks.terminal.open("lazydocker", opts)
end, { desc = "LazyDocker" })
vim.keymap.set("n", "<leader>NN", function()
    Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
        },
    })
end, { desc = "Neovim News" })

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        _G.dd = function(...)
            Snacks.debug.inspect(...)
        end
        _G.bt = function()
            Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
    end,
})
