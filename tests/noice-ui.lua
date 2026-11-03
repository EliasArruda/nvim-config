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
local neovide = vim.g.neovide
local noice, ui = package.loaded.noice, package.loaded["config.ui"]
local calls, redraws, capturing = 0, 0, true
local delayed_ok, delayed_err = xpcall(function()
	vim.g.neovide = true
	vim.api.nvim_list_uis = function()
		return { { chan = 1, ext_messages = capturing, ext_cmdline = capturing } }
	end
	package.loaded.noice = {
		setup = function()
			calls = calls + 1
		end,
	}
	package.loaded["config.ui"] = {
		apply = function()
			redraws = redraws + 1
		end,
	}
	assert(spec.cond(), "Neovide temporary capture permanently disabled Noice")
	spec.config(nil, {})
	assert(calls == 0, "Noice started before GUI released message capture")
	capturing = false
	assert(
		vim.wait(500, function()
			return calls == 1
		end, 10),
		"Noice did not start after capture ended"
	)
	vim.wait(100)
	assert(calls == 1 and redraws == 1, "Noice initialized more than once")
end, debug.traceback)
vim.api.nvim_list_uis = list
vim.g.neovide = neovide
package.loaded.noice, package.loaded["config.ui"] = noice, ui
assert(delayed_ok, delayed_err)
print("PASS: 7 Noice UI compatibility cases and Neovide deferred-start lifecycle")
