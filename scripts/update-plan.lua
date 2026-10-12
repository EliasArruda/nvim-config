-- Read-only installed-version audit. Fetches Git refs and refreshes registries;
-- never checks out plugins, installs packages, rebuilds parsers or updates tools.
local output = assert(vim.env.NVIM_UPDATE_OUTPUT)
local report = { plugins = {}, mason = {}, errors = {}, queried_at = os.date("!%Y-%m-%dT%H:%M:%SZ") }
require("lazy").check({ wait = true, show = false })
require("lazy.manage.checker").fast_check({ report = false })
for name, plugin in pairs(require("lazy.core.config").plugins) do
	local info = require("lazy.manage.git").info(plugin.dir)
	local update = plugin._.updates
	report.plugins[name] = {
		installed = info and info.commit,
		target = update and update.to.commit,
		version_constraint = plugin.version,
		update_available = update ~= nil,
	}
	for _, task in ipairs(plugin._.tasks or {}) do
		if task:has_errors() then
			report.errors[#report.errors + 1] = name .. ": " .. task.name
		end
	end
end
local registry = require("mason-registry")
local done, refreshed = false, false
registry.update(function(ok, err)
	refreshed, done = ok, true
	if not ok then
		report.errors[#report.errors + 1] = "Mason registry: " .. vim.inspect(err)
	end
end)
if not vim.wait(60000, function()
	return done
end, 100) then
	report.errors[#report.errors + 1] = "Mason registry refresh timed out; installed packages were not updated"
end
report.registry_refreshed = refreshed
for _, pkg in ipairs(registry.get_installed_packages()) do
	local ok, latest = pcall(pkg.get_latest_version, pkg)
	local installed = pkg:get_installed_version()
	if not ok then
		report.errors[#report.errors + 1] = pkg.name .. ": version query failed: " .. tostring(latest)
	end
	local available = vim.NIL
	if ok then
		available = installed ~= latest
	end
	report.mason[pkg.name] = {
		installed = installed,
		latest_in_registry = ok and latest or nil,
		update_available = available,
	}
end
local tools = vim.system({ "dotnet", "tool", "list", "--global" }, { text = true }):wait(30000)
vim.fn.writefile(vim.split(tools.stdout or "", "\n"), output .. "/dotnet-tools.txt")
if tools.code ~= 0 then
	report.errors[#report.errors + 1] = "dotnet tool list failed: " .. (tools.stderr or "")
end
local query = vim.system({
	"curl",
	"--fail",
	"--silent",
	"--show-error",
	"--max-time",
	"20",
	"https://api.nuget.org/v3-flatcontainer/easydotnet/index.json",
}, { text = true }):wait(25000)
local ok, versions = pcall(vim.json.decode, query.stdout or "")
if query.code == 0 and ok then
	for _, version in ipairs(versions.versions or {}) do
		if not version:find("-", 1, true) then
			report.easydotnet_latest_stable = version
		end
	end
else
	report.errors[#report.errors + 1] = "EasyDotnet NuGet version query failed: " .. (query.stderr or "")
end
vim.fn.writefile({ vim.json.encode(report) }, output .. "/plan.json")
local plugins, tools_count = 0, 0
for _, value in pairs(report.plugins) do
	if value.update_available == true then
		plugins = plugins + 1
	end
end
for _, value in pairs(report.mason) do
	if value.update_available == true then
		tools_count = tools_count + 1
	end
end
print(
	("Update plan: %d plugins, %d Mason packages; EasyDotnet latest stable: %s"):format(
		plugins,
		tools_count,
		report.easydotnet_latest_stable or "unavailable"
	)
)
print("Versions saved in " .. output .. "/plan.json; no installed versions changed")
assert(#report.errors == 0, table.concat(report.errors, "\n"))
