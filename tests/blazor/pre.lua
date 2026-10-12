-- Use installed plugins, but never mutate plugin/tool installations in tests.
local root = vim.fn.stdpath("data") .. "/lazy/"
for _, name in ipairs({ "lazy.nvim", "mason.nvim", "nvim-treesitter" }) do
	vim.opt.rtp:prepend(root .. name)
end
require("mason-registry").refresh = function() end
require("nvim-treesitter").install = function()
	return { wait = function() end }
end
local lazy = require("lazy")
local setup = lazy.setup
lazy.setup = function(spec, opts)
	opts = opts or {}
	opts.install = { missing = false }
	opts.checker = { enabled = false }
	opts.change_detection = { enabled = false }
	opts.lockfile = vim.fn.stdpath("state") .. "/test-lock.json"
	return setup(spec, opts)
end
