local M = {}
local active, sidebar, list_buf, panel_win
local hidden_commands, restore_panel = {}, false
local busy = false
local height = 0.35

local function sessions()
	local list = {}
	for _, terminal in pairs(Snacks.terminal.list()) do
		if terminal.cmd == nil then
			list[#list + 1] = terminal
		end
	end
	table.sort(list, function(a, b)
		return a.buf < b.buf
	end)
	return list
end

local function close_sidebar()
	if sidebar and vim.api.nvim_win_is_valid(sidebar) then
		vim.api.nvim_win_close(sidebar, true)
	end
	sidebar = nil
end

local function select_row()
	local terminal = sessions()[vim.api.nvim_win_get_cursor(sidebar)[1]]
	if terminal then
		M.select(terminal)
	end
end

local function render_sidebar()
	local list = sessions()
	close_sidebar()
	if #list < 2 or not active or not active:win_valid() then
		return
	end
	if not list_buf or not vim.api.nvim_buf_is_valid(list_buf) then
		list_buf = vim.api.nvim_create_buf(false, true)
		vim.bo[list_buf].bufhidden = "hide"
		vim.bo[list_buf].filetype = "terminal_sessions"
		vim.keymap.set("n", "<CR>", select_row, { buffer = list_buf, silent = true })
		vim.keymap.set("n", "<LeftMouse>", function()
			local mouse = vim.fn.getmousepos()
			if mouse.winid == sidebar and mouse.line > 0 and mouse.line <= #sessions() then
				vim.api.nvim_win_set_cursor(sidebar, { mouse.line, 0 })
				select_row()
			end
		end, { buffer = list_buf, silent = true })
		vim.keymap.set("n", "q", M.toggle, { buffer = list_buf, silent = true })
	end
	local lines, selected = {}, 1
	for index, terminal in ipairs(list) do
		lines[index] = ("  %s %d"):format(vim.fs.basename(vim.o.shell), index)
		if terminal == active then
			selected = index
		end
	end
	vim.bo[list_buf].modifiable = true
	vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, lines)
	vim.bo[list_buf].modifiable = false
	sidebar = vim.api.nvim_open_win(list_buf, false, { split = "right", win = active.win, width = 18 })
	for key, value in pairs({
		number = false,
		relativenumber = false,
		signcolumn = "no",
		foldcolumn = "0",
		wrap = false,
		winfixwidth = true,
		winfixheight = true,
		winbar = "",
		statusline = " ",
		cursorline = false,
		winhighlight = "Normal:NormalSB,NormalNC:NormalSB,EndOfBuffer:NormalSB",
	}) do
		vim.api.nvim_set_option_value(key, value, { win = sidebar })
	end
	local ns = vim.api.nvim_create_namespace("terminal_sessions")
	vim.api.nvim_buf_clear_namespace(list_buf, ns, 0, -1)
	vim.api.nvim_buf_set_extmark(list_buf, ns, selected - 1, 0, { line_hl_group = "PmenuSel" })
	vim.api.nvim_win_set_cursor(sidebar, { selected, 0 })
end

function M.select(terminal)
	if busy or not terminal:buf_valid() then
		return
	end
	if active and active:win_valid() then
		height = vim.api.nvim_win_get_height(active.win)
	end
	busy = true
	close_sidebar()
	for _, other in ipairs(sessions()) do
		if other ~= terminal and other:win_valid() then
			other:hide()
		end
	end
	active = terminal
	terminal.opts.position, terminal.opts.height, terminal.opts.winbar = "bottom", height, ""
	terminal:show()
	panel_win = terminal.win
	vim.api.nvim_set_current_win(terminal.win)
	render_sidebar()
	busy = false
end

function M.toggle()
	local visible = false
	for _, terminal in ipairs(sessions()) do
		visible = visible or terminal:win_valid()
	end
	local commands = {}
	for _, terminal in pairs(Snacks.terminal.list()) do
		if terminal.cmd ~= nil and terminal:win_valid() then
			commands[#commands + 1] = terminal
		end
	end
	if visible or #commands > 0 then
		restore_panel, hidden_commands = visible, commands
		busy = true
		if active and active:win_valid() then
			height = vim.api.nvim_win_get_height(active.win)
		end
		vim.cmd.stopinsert()
		close_sidebar()
		for _, terminal in ipairs(sessions()) do
			if terminal:win_valid() then
				terminal:hide()
			end
		end
		for _, terminal in ipairs(commands) do
			terminal:hide()
		end
		panel_win = nil
		busy = false
	else
		local restore_commands = hidden_commands
		hidden_commands = {}
		if #restore_commands > 0 and not restore_panel then
			local restored = false
			for _, terminal in ipairs(restore_commands) do
				if terminal:buf_valid() then
					terminal:show()
					restored = true
				end
			end
			if restored then
				return
			end
		end
		local list = sessions()
		if active and active:buf_valid() then
			M.select(active)
		elseif #list > 0 then
			M.select(list[#list])
		else
			M.new_split()
		end
		for _, terminal in ipairs(restore_commands) do
			if terminal:buf_valid() then
				terminal:show()
			end
		end
	end
end

function M.new_split()
	local count = 1
	while Snacks.terminal.get(nil, { count = count, create = false }) do
		count = count + 1
	end
	busy = true
	close_sidebar()
	for _, terminal in ipairs(sessions()) do
		if terminal:win_valid() then
			height = vim.api.nvim_win_get_height(terminal.win)
			terminal:hide()
		end
	end
	local terminal = Snacks.terminal.get(nil, {
		count = count,
		win = { position = "bottom", height = height, wo = { winbar = "" } },
	})
	busy = false
	M.select(terminal)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("terminal_sessions", { clear = true })
	local mouse_key = vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true)
	vim.on_key(function(key, typed)
		if key ~= mouse_key and typed ~= mouse_key then
			return
		end
		-- The first click enters this buffer using Neovim's existing mouse
		-- handling. Select afterward, without replacing global mouse mappings.
		vim.schedule(function()
			if sidebar and vim.api.nvim_win_is_valid(sidebar) and vim.api.nvim_get_current_win() == sidebar then
				select_row()
			end
		end)
	end, vim.api.nvim_create_namespace("terminal_sessions.mouse"))
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		callback = function(event)
			if busy then
				return
			end
			local shell = vim.b[event.buf].snacks_terminal
			if not shell or shell.cmd ~= nil then
				return
			end
			vim.schedule(function()
				for _, terminal in ipairs(sessions()) do
					if terminal.buf == event.buf and terminal:win_valid() then
						M.select(terminal)
						break
					end
				end
			end)
		end,
	})
	vim.api.nvim_create_autocmd({ "TermClose", "BufWipeout", "WinClosed" }, {
		group = group,
		callback = function(event)
			if busy then
				return
			end
			if event.event == "WinClosed" then
				if tonumber(event.match) == sidebar then
					sidebar = nil
					return
				end
				if tonumber(event.match) ~= panel_win then
					return
				end
			else
				if not vim.api.nvim_buf_is_valid(event.buf) then
					return
				end
				local info = vim.b[event.buf].snacks_terminal
				if not info or info.cmd ~= nil then
					return
				end
			end
			local was_visible = sidebar ~= nil or (active and active:win_valid())
			vim.schedule(function()
				if busy then
					return
				end
				if active and active:win_valid() then
					busy = true
					render_sidebar()
					busy = false
				elseif sidebar or was_visible then
					close_sidebar()
					if
						event.event == "TermClose"
						or event.event == "BufWipeout"
						or (active and not active:buf_valid())
					then
						local list = sessions()
						if #list > 0 then
							M.select(list[#list])
						end
					end
				end
			end)
		end,
	})
end
return M
