local map = vim.keymap.set

-- ============================================================
-- 📟 TERMINAL
-- ============================================================

-- Fixa o tamanho do terminal sempre que a janela for criada/focada
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
	pattern = "term://*",
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local total = vim.o.lines
		local target = math.floor(total * 0.35)
		vim.api.nvim_win_set_height(win, target)
		vim.wo[win].winfixheight = true
	end,
})

local terminal_layout = nil
map({ "n", "t", "i" }, "<C-t>", function()
	local terminals = {}
	local count = 1
	while true do
		local term = Snacks.terminal.get(nil, { count = count, create = false })
		if not term or not term.win or not vim.api.nvim_win_is_valid(term.win) then
			break
		end
		table.insert(terminals, { count = count, win = term.win, buf = term.buf })
		count = count + 1
	end

	if vim.tbl_isempty(terminals) then
		if terminal_layout then
			for _, t in ipairs(terminal_layout) do
				Snacks.terminal.toggle(nil, {
					count = t.count,
					win = t.win_opts,
				})
			end
			terminal_layout = nil
		else
			Snacks.terminal.toggle(nil, {
				count = 1,
				win = { position = "bottom", height = 0.35 },
			})
		end
	else
		terminal_layout = {}
		for _, t in ipairs(terminals) do
			local w = t.win
			local opts = {
				position = "bottom",
				height = vim.api.nvim_win_get_height(w) / vim.o.lines,
				wo = { winfixwidth = vim.wo[w].winfixwidth },
			}
			local cfg = vim.api.nvim_win_get_config(w)
			if cfg.split then
				opts.split = cfg.split
				opts.position = cfg.split == "vertical" and "right" or "bottom"
			end
			table.insert(terminal_layout, { count = t.count, win_opts = opts })
		end

		for i = #terminals, 1, -1 do
			Snacks.terminal.toggle(nil, { count = terminals[i].count })
		end
	end
end, { desc = "Toggle Terminal (Todos os Splits)" })

map("t", "<C-n>", function()
	local count = 2
	while Snacks.terminal.get(nil, { count = count, create = false }) do
		count = count + 1
	end
	Snacks.terminal.get(nil, {
		count = count,
		win = {
			position = "bottom",
			split = "vertical",
			wo = { winfixwidth = true },
		},
	})
end, { desc = "New Terminal Split" })

-- ============================================================
-- 💾 EDITOR
-- ============================================================
map({ "n", "i", "v", "x" }, "<C-s>", "<Esc><Cmd>update<CR>", { desc = "Save", silent = true })

map("n", "<C-x>", function()
	vim.api.nvim_buf_delete(0, { force = true })
end, { desc = "Close Buffer" })

-- ============================================================
-- 🔬 LSP
-- ============================================================

map({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "<C-CR>", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic Float" })

map("n", "<leader>cy", function()
	local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
	if #diags == 0 then
		return
	end
	vim.fn.setreg("+", diags[1].message)
	vim.notify("Copied: " .. diags[1].message)
end, { desc = "Copy Diagnostic" })

-- ============================================================
-- 🛠️ UTILITIES
-- ============================================================
map("n", "<leader>gx", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		local url = line:match("(https?:[%w%-%._~:/%?#%[%]@!$&'()*+,;=]+)")
		if url then
			vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			vim.notify("Opening: " .. url)
			return
		end
	end
	vim.notify("❌ No URL found", vim.log.levels.WARN)
end, { desc = "Open URL" })

map("n", "<leader>r", function()
	if vim.wo.number then
		vim.wo.number = false
		vim.wo.relativenumber = false
	else
		vim.wo.number = true
		vim.wo.relativenumber = true
	end
end, { desc = "Toggle Line Numbers" })
