return {
	"jbyuki/venn.nvim",
	config = function()
		-- Função para ativar/desativar keymaps do venn.nvim com mensagem
		function _G.Toggle_venn()
			local venn_enabled = vim.b.venn_enabled

			if not venn_enabled then
				-- Ativa o modo venn
				vim.b.venn_enabled = true
				print("Venn mode ativado!") -- mensagem ao ativar
				vim.cmd([[setlocal virtualedit=all]]) -- cursor livre

				-- Desenha linhas ao usar H/J/K/L
				vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = 0, noremap = true, silent = true })
				vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = 0, noremap = true, silent = true })
				vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = 0, noremap = true, silent = true })
				vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = 0, noremap = true, silent = true })

				-- Desenha uma box com seleção visual + tecla "f"
				vim.keymap.set("v", "f", ":VBox<CR>", { buffer = 0, noremap = true, silent = true })
				else
				-- Desativa o modo venn
				vim.b.venn_enabled = nil
				print("Venn mode desativado!")
				vim.cmd([[setlocal virtualedit=]])
				vim.keymap.del("n", "J", { buffer = 0 })
				vim.keymap.del("n", "K", { buffer = 0 })
				vim.keymap.del("n", "L", { buffer = 0 })
				vim.keymap.del("n", "H", { buffer = 0 })
				vim.keymap.del("v", "f", { buffer = 0 })
				end
		end

		-- Atalho global para ativar/desativar venn.nvim
		-- Pressione <leader>v no modo normal
		vim.keymap.set("n", "<leader>v", function() _G.Toggle_venn() end, { desc = "Toggle Venn Diagram" })
	end,
}
