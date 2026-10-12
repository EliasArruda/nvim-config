-- A failed metadata query must not be reported as an up-to-date package.
local registry, lazy = require("mason-registry"), require("lazy")
local checker = require("lazy.manage.checker")
local old = {
	update = registry.update,
	packages = registry.get_installed_packages,
	check = lazy.check,
	fast = checker.fast_check,
	system = vim.system,
	output = vim.env.NVIM_UPDATE_OUTPUT,
}
local output = vim.fn.tempname()
vim.fn.mkdir(output, "p")
vim.env.NVIM_UPDATE_OUTPUT = output
registry.update = function(callback)
	callback(true, {})
end
registry.get_installed_packages = function()
	return {
		{
			name = "unavailable-test-package",
			get_latest_version = function()
				error("metadata unavailable")
			end,
			get_installed_version = function()
				return "1.0.0"
			end,
		},
	}
end
lazy.check, checker.fast_check = function() end, function() end
vim.system = function(command)
	return {
		wait = function()
			return { code = 0, stdout = command[1] == "curl" and '{"versions":["1.0.0"]}' or "", stderr = "" }
		end,
	}
end
local ok, err = pcall(dofile, vim.fn.stdpath("config") .. "/scripts/update-plan.lua")
registry.update, registry.get_installed_packages = old.update, old.packages
lazy.check, checker.fast_check, vim.system = old.check, old.fast, old.system
vim.env.NVIM_UPDATE_OUTPUT = old.output
local report = vim.json.decode(table.concat(vim.fn.readfile(output .. "/plan.json"), "\n"))
vim.fn.delete(output, "rf")
assert(not ok and tostring(err):find("metadata unavailable", 1, true), "Failed audit returned success")
assert(#report.errors == 1, "Package metadata failure was not recorded")
assert(report.mason["unavailable-test-package"].update_available == vim.NIL, "Unknown update was reported as false")
print("PASS: update audit reports metadata errors and unknown availability")
