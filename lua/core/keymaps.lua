-- Rastreia quais terminais estão visíveis (por índice)
vim.keymap.set({ "n", "t", "i" }, "<C-t>", function()
	local t1 = Snacks.terminal.get(nil, { count = 1, create = false })
	local t2 = Snacks.terminal.get(nil, { count = 2, create = false })

	-- Verifica se o terminal está realmente ativo e visível
	local t1_active = t1 and t1.win and vim.api.nvim_win_is_valid(t1.win)
	local t2_active = t2 and t2.win and vim.api.nvim_win_is_valid(t2.win)

	if t1_active and t2_active then
		t1:hide()
		t2:hide()
	elseif not t1_active and not t2_active then
		local opts1 = { count = 1, win = { position = "bottom" }, interactive = false }
		Snacks.terminal.get(nil, opts1):show()
		vim.schedule(function()
			local opts2 = { count = 2, win = { position = "bottom" } }
			Snacks.terminal.get(nil, opts2):show()
		end)
	else
		-- Se apenas um está ativo, apenas focamos nele
		if t1_active then
			t1:show()
		elseif t2_active then
			t2:show()
		end
	end
end, { desc = "Toggle Terminais Inteligente" })


-- Alternar apenas um terminal
vim.keymap.set({ "n" }, "<leader>t", function()
	local t1 = Snacks.terminal.get(nil, { count = 1, create = false })
	local is_visible = t1 and t1.win and vim.api.nvim_win_is_valid(t1.win)
	if is_visible then t1:hide() else
		local opts = { count = 1, win = { position = "bottom" }, interactive = false }
		Snacks.terminal.get(nil, opts):show()
	end
end, { desc = "Toggle Terminal Único" })

-- Multi-Replace (SImulando multi-cursor para substituições globais)
vim.keymap.set("n", "<leader>mr", function()
	local word = vim.fn.expand("<cword>") or ""
	local replacement = ""
	if word ~= "" then
		replacement = vim.fn.input(string.format("(%s) -> ", word), "")
	end
	if replacement == "" then
		local old = vim.fn.input("Substituir: ")
		if old == "" then return end
		local new_w = vim.fn.input(string.format("(%s) -> ", old), "")
		if new_w == "" then return end
		word = old
		replacement = new_w
	end
	-- Sintaxe segura de substituição global no Vim
	-- Use a safer way to build the command to avoid Lua escape sequence errors
	local cmd = "%s/" .. "\\<" .. word .. "\\>" .. "/" .. replacement .. "/ge"
	vim.cmd(cmd)
	vim.notify("Substituído " .. word .. " por " .. replacement)
end, { desc = "Multi-Replace (Global)" })



-- SALVAR
vim.keymap.set({ "n", "i", "v", "x" }, "<C-s>", "<Esc><Cmd>update<CR>", { desc = "Salvar do insert", silent = true })

-- Code Actions
vim.keymap.set({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code Actions" })

-- Go to definition
vim.keymap.set("n", "<C-CR>", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Fechar buffer instantaneamente
vim.keymap.set("n", "<C-x>", function()
	vim.api.nvim_buf_delete(0, { force = true })
end, { desc = "Fechar buffer instantâneo" })

-- Copia o diagnostic da linha atual
vim.keymap.set("n", "<leader>cy", function()
	local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
	if #diags > 0 then
		vim.fn.setreg("+", diags[1].message)
		print("Copied diagnostic: " .. diags[1].message)
	end
end, { desc = "Copy diagnostic to clipboard" })

-- Diagnostic view
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float)

-- URL
vim.keymap.set("n", "<leader>gx", function()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, -100, -1, false)
	for _, line in ipairs(lines) do
		local url = line:match("(https?:[%w%-%._~:/%?#%[%]@!$&'()*+,;=]+)")
		if url then
			vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			print("Abrindo: " .. url)
			return
		end
	end
	print("Nenhuma URL encontrada (terminal)")
end)
