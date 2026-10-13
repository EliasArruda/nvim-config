local M = {}
function M.setup()
	Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	Snacks.toggle.diagnostics():map("<leader>ud")
	Snacks.toggle.line_number():map("<leader>ul")
	Snacks.toggle
		.option("conceallevel", {
			off = 0,
			on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
			name = "Conceal Level",
		})
		:map("<leader>uc")
	Snacks.toggle
		.option("showtabline", {
			off = 0,
			on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
			name = "Tabline",
		})
		:map("<leader>uA")
	Snacks.toggle.treesitter():map("<leader>uT")
	Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
	Snacks.toggle.dim():map("<leader>uD")
	Snacks.toggle.animate():map("<leader>ua")
	Snacks.toggle.scroll():map("<leader>uS")
	Snacks.toggle.zoom():map("<leader>uZ")
	Snacks.toggle.zen():map("<leader>uz")

	if vim.lsp.inlay_hint then
		Snacks.toggle.inlay_hints():map("<leader>uh")
	end
	Snacks.toggle({
		name = "Autoformat",
		get = function()
			return vim.g.autoformat ~= false
		end,
		set = function(value)
			vim.g.autoformat = value
		end,
	}):map("<leader>uf")
end
return M
