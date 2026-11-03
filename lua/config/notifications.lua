local M = {}
local function noice_running()
	local config = package.loaded["noice.config"]
	return config and config.is_running()
end
function M.history()
	if noice_running() then
		require("noice").cmd("history")
	else
		vim.cmd.messages()
	end
end
function M.dismiss()
	if noice_running() then
		require("noice").cmd("dismiss")
	else
		vim.cmd("redraw!")
	end
end
return M
