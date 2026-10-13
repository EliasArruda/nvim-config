-- ==========================================
-- <C-Backspace> (Insert, Cmd e Terminal)
-- ==========================================
local function smart_ctrl_backspace()
	local bt = vim.bo.buftype
	local ft = vim.bo.filetype

	local key = vim.api.nvim_replace_termcodes("<C-w>", true, false, true)
	if bt == "prompt" or ft:match("snacks") or ft:match("neo%-tree") then
		vim.api.nvim_feedkeys(key, "m", false)
	else
		vim.api.nvim_feedkeys(key, "n", false)
	end
end

-- Mapeamentos para o modo de Inserção (i)
vim.keymap.set("i", "<C-BS>", smart_ctrl_backspace, { noremap = true })

-- Mapeamentos para o modo de Comando (c)
vim.keymap.set("c", "<C-BS>", "<C-w>", { noremap = true })

-- Mapeamento exclusivo para o modo Terminal (t)
vim.keymap.set("t", "<C-BS>", function()
	local term_id = vim.b.terminal_job_id
	if term_id then
		-- Envia o código ASCII do Ctrl+W (\23) direto para o Bash/Zsh/PowerShell
		vim.api.nvim_chan_send(term_id, "\23")
	end
end, { noremap = true })

-- Mode-specific clipboard: use the native paste API for terminal input.
vim.keymap.set("n", "<C-S-c>", '"+yy', { desc = "Copy line" })
vim.keymap.set("x", "<C-S-c>", '"+y', { desc = "Copy selection" })
vim.keymap.set("i", "<C-S-c>", '<C-o>"+yy', { desc = "Copy line" })
vim.keymap.set("t", "<C-S-v>", function()
	vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end, { desc = "Paste in terminal" })
