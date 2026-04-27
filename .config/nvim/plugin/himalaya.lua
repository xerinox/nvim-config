require("lazyload").on_event("BufReadPost", function()
    vim.pack.add({
        { src = "https://github.com/pimalaya/himalaya-vim" },
    })

    vim.g.himalaya_folder_picker = 'telescope'
    vim.g.himalaya_executable = "/home/xerinox/.cargo/bin/himalaya"
end)
