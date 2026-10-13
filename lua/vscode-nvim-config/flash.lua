local flash_path = vim.fn.stdpath("data") .. "/lazy/flash.nvim"

if vim.uv.fs_stat(flash_path) then
	vim.opt.runtimepath:prepend(flash_path)

	local ok, flash = pcall(require, "flash")
	if ok then
		flash.setup({})

		vim.keymap.set({ "n", "x", "o" }, "s", function()
			flash.jump()
		end, { desc = "Flash" })

		vim.keymap.set({ "n", "x", "o" }, "S", function()
			flash.treesitter()
		end, { desc = "Flash Treesitter" })

		vim.keymap.set("o", "r", function()
			flash.remote()
		end, { desc = "Remote Flash" })

		vim.keymap.set({ "o", "x" }, "R", function()
			flash.treesitter_search()
		end, { desc = "Flash Treesitter Search" })
	end
end
