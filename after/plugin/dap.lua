local has_dap, dap = pcall(require, "dap")
if not has_dap then
	return
end

local has_dap_ui, dapui = pcall(require, "dapui")
if not has_dap_ui then
	return
end

dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" }
}

dap.configurations.php = {
	{
		type = "php",
		request = "launch",
		name = "Listen for Xdebug",
		-- localSourceRoot = vim.fn.expand("%:p:h").."/",
		port = 33333,
		-- serverSourceRoot = "/opt/app-root/www",
		pathMappings = {
			-- ["/opt/app-root/www"] = "${workspaceFolder}/site_root",
			["/opt/app-root/www/"] = "${workspaceFolder}/site_root/",
			["/opt/app-root/www/*"] = "${workspaceFolder}/site_root/*",
			["/opt/app-root/www"] = "/home/xerinox/websites/opscomV2/site_root",
		}
	}
}

dap.set_exception_breakpoints({"Error", "Exception", "Warning", "*"})

require("nvim-dap-virtual-text").setup {
	enabled = true,
	enabled_commands = true,
	show_stop_reason = true,
	commented = true,
}

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end


