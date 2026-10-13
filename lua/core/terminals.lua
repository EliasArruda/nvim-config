local M = {}
local hidden = {}

function M.toggle()
	local visible = {}
	for _, terminal in pairs(Snacks.terminal.list()) do
		if terminal:win_valid() then
			visible[#visible + 1] = terminal
		end
	end
	if #visible > 0 then
		hidden = visible
		for _, terminal in ipairs(visible) do
			terminal.opts.height = vim.api.nvim_win_get_height(terminal.win)
			terminal.opts.width = vim.api.nvim_win_get_width(terminal.win)
			terminal:hide()
		end
	elseif #hidden > 0 then
		for _, terminal in ipairs(hidden) do
			if terminal:buf_valid() then
				terminal:show()
			end
		end
		hidden = {}
	else
		Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.35 } })
	end
end

function M.new_split()
	local count = 1
	while Snacks.terminal.get(nil, { count = count, create = false }) do
		count = count + 1
	end
	Snacks.terminal.get(nil, {
		count = count,
		win = { position = "right", width = 0.5, relative = "win", wo = { winfixwidth = true } },
	})
end
return M
