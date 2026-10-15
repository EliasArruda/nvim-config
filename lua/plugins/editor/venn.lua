return {
	"jbyuki/venn.nvim",
	config = function()
		-- Função para ativar/desativar keymaps do venn.nvim com mensagem
		function _G.Toggle_venn()
			local venn_enabled = vim.b.venn_enabled

			if not venn_enabled then
				-- Ativa o modo venn
				vim.b.venn_enabled = true
				vim.b.venn_saved_virtualedit = vim.wo.virtualedit
				local saved = {}
				for _, key in ipairs({ "J", "K", "L", "H" }) do
					saved[key] = vim.fn.maparg(key, "n", false, true)
				end
				saved.f = vim.fn.maparg("f", "v", false, true)
				vim.b.venn_saved_maps = saved
				print("Venn mode ativado!") -- mensagem ao ativar
				vim.opt_local.virtualedit = "all" -- cursor livre

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
				vim.opt_local.virtualedit = vim.b.venn_saved_virtualedit or ""
				vim.keymap.del("n", "J", { buffer = 0 })
				vim.keymap.del("n", "K", { buffer = 0 })
				vim.keymap.del("n", "L", { buffer = 0 })
				vim.keymap.del("n", "H", { buffer = 0 })
				vim.keymap.del("v", "f", { buffer = 0 })
				for key, mapping in pairs(vim.b.venn_saved_maps or {}) do
					if mapping.buffer == 1 then
						vim.fn.mapset(key == "f" and "v" or "n", false, mapping)
					end
				end
				vim.b.venn_saved_maps = nil
			end
		end

		-- Atalho global para ativar/desativar venn.nvim
		-- Pressione <leader>v no modo normal
		vim.keymap.set("n", "<leader>v", function()
			_G.Toggle_venn()
		end, { desc = "Toggle Venn Diagram" })
	end,
}
