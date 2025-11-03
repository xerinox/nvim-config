return {
    "https://github.com/pimalaya/himalaya-vim",
    init = function()
        vim.g.himalaya_folder_picker = 'telescope'
        vim.g.himalaya_executable = "/home/xerinox/.cargo/bin/himalaya"
    end
}
