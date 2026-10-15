local root = vim.fn.tempname()
vim.fn.mkdir(root .. "/Pages", "p")
vim.fn.writefile(
	{ "<Project><PropertyGroup><RootNamespace>TemplateDemo</RootNamespace></PropertyGroup></Project>" },
	root .. "/Demo.csproj"
)
local checks = 0
local function open(name, content, old)
	vim.cmd("enew!")
	local path = root .. "/" .. name
	if content then
		vim.fn.writefile(content, path)
		if old then
			vim.uv.fs_utime(path, 1, 1)
		end
	end
	vim.cmd.edit(vim.fn.fnameescape(path))
	vim.wait(350)
	vim.cmd.stopinsert()
	return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
end
local function check(ok, message)
	assert(ok, message)
	checks = checks + 1
end
for _, existing in ipairs({ false, true }) do
	local suffix = existing and "Disk" or "Editor"
	local content = existing and {} or nil
	check(
		open("IService" .. suffix .. ".cs", content):find("public interface IService" .. suffix, 1, true),
		"C# interface template missing: " .. suffix
	)
	check(open("Card" .. suffix .. ".vue", content):find("<template>", 1, true), "Vue template missing: " .. suffix)
	check(open("component" .. suffix .. ".go", content):find("package ", 1, true), "Go template missing: " .. suffix)
	check(
		open("Pages/Details" .. suffix .. ".razor", content):find("@code {", 1, true),
		"Razor template missing: " .. suffix
	)
end
check(open("Existing.cs", { "// Keep my code" }) == "// Keep my code", "Existing content overwritten")
check(open("Old.cs", {}, true) == "", "Old empty file changed")
check(open("Old.vue", {}, true) == "", "Old empty Vue changed")
check(open("_Imports.razor", nil) == "", "Imports file populated as a component")
vim.cmd("enew!")
local other = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(other, 0, -1, false, { "sentinel" })
vim.cmd.edit(root .. "/Switch.vue")
vim.api.nvim_set_current_buf(other)
vim.wait(350)
check(vim.api.nvim_buf_get_lines(other, 0, -1, false)[1] == "sentinel", "Deferred template changed another buffer")
vim.cmd("enew!")
vim.fn.delete(root, "rf")
io.stdout:write(("PASS: %d template checks (%s)\n"):format(checks, vim.g.vscode and "vscode" or "native"))
