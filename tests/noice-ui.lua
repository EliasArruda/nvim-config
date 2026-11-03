local spec = dofile(vim.env.NVIM_TEST_ROOT .. "/lua/plugins/ui/noice.lua")
local list = vim.api.nvim_list_uis
local ok, err = xpcall(function()
	for _, case in ipairs({
		{ {}, true },
		{ { { chan = 0 } }, true },
		{ { { chan = 1, ext_messages = false } }, true },
		{ { { chan = 1, ext_messages = true } }, false },
		{ { { chan = 1, ext_cmdline = true } }, false },
		{ { { chan = 1, ext_popupmenu = true } }, false },
		{ { { chan = 0 }, { chan = 2, ext_messages = true } }, false },
	}) do
		vim.api.nvim_list_uis = function()
			return case[1]
		end
		assert(spec.cond() == case[2], "Incorrect Noice UI compatibility: " .. vim.inspect(case[1]))
	end
end, debug.traceback)
vim.api.nvim_list_uis = list
assert(ok, err)
print("PASS: 7 Noice UI compatibility checks")
