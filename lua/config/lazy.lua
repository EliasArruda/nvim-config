local M = {}
function M.setup()
	local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	assert(vim.uv.fs_stat(path), "lazy.nvim missing: run ~/.config/nvim/bin/bootstrap-nvim")
	vim.opt.rtp:prepend(path)
	require("lazy").setup("plugins", {
		concurrency = 4,
		lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
		checker = { enabled = false },
		change_detection = { notify = false },
		rocks = { enabled = false },
		install = { missing = false, colorscheme = { "tokyonight", "habamax" } },
		ui = { border = "rounded" },
		performance = { rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } } },
	})
end
return M
