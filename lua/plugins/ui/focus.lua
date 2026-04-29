return {
	"beauwilliams/focus.nvim",
	event = "VeryLazy",
	config = function()
		require("focus").setup({
			enable = true,
			autoresize = {
				enable = true,
				width = 0, -- Foca expandindo a janela ativa
			},
			ui = {
				cursorline = false, -- Desativado aqui para não criar "barras" em janelas pequenas
				signcolumn = false,
			},
		})

		-- Lógica para o Focus ignorar janelas flutuantes e componentes do Snacks
		local ignore_filetypes = { "snacks_terminal", "snacks_explorer", "snacks_dashboard", "snacks_input" }
		local augroup = vim.api.nvim_create_augroup("FocusSettings", { clear = true })

		vim.api.nvim_create_autocmd("WinEnter", {
			group = augroup,
			callback = function()
				-- Se for uma janela flutuante (como o Input do Snacks), desativa o Focus
				if vim.api.nvim_win_get_config(0).relative ~= "" then
					vim.b.focus_disable = true
					return
				end
				-- Se for um dos tipos de arquivo na lista, desativa o Focus
				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
					vim.b.focus_disable = true
				end
			end,
		})
	end,
}
