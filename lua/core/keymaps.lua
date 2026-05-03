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

map({ "n", "t", "i" }, "<C-t>", function()
	Snacks.terminal.toggle(nil, {
		count = 1,
		win = {
			position = "bottom",
			height = 0.35,
		},
	})
end, { desc = "Toggle Terminal" })

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
			vim.notify("🌐 Opening: " .. url)
			return
		end
	end
	vim.notify("❌ No URL found", vim.log.levels.WARN)
end, { desc = "Open URL" })

map("n", "<leader>mr", function()
	local word = vim.fn.expand("<cword>")
	local new_word

	if word ~= "" then
		new_word = vim.fn.input(string.format("(%s) -> ", word))
	else
		word = vim.fn.input("Replace: ")
		if word == "" then
			return
		end
		new_word = vim.fn.input(string.format("(%s) -> ", word))
	end

	if new_word == "" then
		return
	end

	local s = vim.fn.searchpairpos("{", "", "}", "bnW")[1]
	local e = vim.fn.searchpairpos("{", "", "}", "nW")[1]
	local range = (s == 0 or e == 0) and "%" or (s .. "," .. e)

	if range == "%" then
		vim.notify("⚠️ Outside block {}, replacing in entire file", vim.log.levels.WARN)
	end

	vim.cmd(range .. "s/\\<" .. word .. "\\>/" .. new_word .. "/ge")
	vim.notify("✅ Replaced: " .. word .. " → " .. new_word)
end, { desc = "Multi-Replace (Block {})" })
