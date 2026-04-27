require("lazyload").on_vim_enter(function()
    vim.pack.add({
        { src = "https://github.com/zbirenbaum/copilot.lua" },
        { src = "https://github.com/copilotlsp-nvim/copilot-lsp" },
    })

    local ok, copilot = pcall(require, "copilot")
    if not ok then return end
    copilot.setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        telemetry = {
            telemetryLevel = "off"
        }
    })
end)
