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
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
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
		open("main" .. (existing and ".cc" or ".cpp"), content):find("int main()", 1, true),
		"C++ main template missing: " .. suffix
	)
	check(
		open((existing and "Disk/" or "") .. "main.c", content):find("int main(void)", 1, true),
		"C main template missing: " .. suffix
	)
	check(
		open("Widget" .. suffix .. ".hpp", content):find("#pragma once", 1, true),
		"C++ header template missing: " .. suffix
	)
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
vim.fn.writefile({ "#pragma once" }, root .. "/Shared.hpp")
check(open("Shared.cpp", nil):find('#include "Shared.hpp"', 1, true), "C++ source did not include matching header")
check(not open("Other.cpp", nil):find("int main", 1, true), "Non-main C++ source defined another entry point")
check(open("Old.cpp", {}, true) == "", "Old empty C++ changed")
check(open("Existing.cpp", { "// Keep C++" }) == "// Keep C++", "Existing C++ overwritten")
for name, expected in pairs({
	["Customer.cs"] = "public sealed class Customer",
	["OrdersController.cs"] = "ControllerBase",
	["OrderDto.cs"] = "public sealed record OrderDto",
	["OrderStatus.cs"] = "public enum OrderStatus",
	["StringExtensions.cs"] = "public static class StringExtensions",
	["OrderHandler.cs"] = "public void Handle()",
	["Counter.razor.cs"] = "public partial class Counter",
	["GlobalUsings.cs"] = "global using System;",
}) do
	check(open(name, nil):find(expected, 1, true), "C# variant missing: " .. name)
end
check(open("main.go", nil):find("package main", 1, true), "Go main package missing")
vim.fn.mkdir(root .. "/widgets", "p")
vim.fn.writefile({ "package widgets" }, root .. "/widgets/existing.go")
check(open("widgets/component.go", nil):find("package widgets", 1, true), "Go sibling package not reused")
for _, extension in ipairs({ "vue", "go", "razor", "c" }) do
	check(
		open("Existing." .. extension, { "// sentinel" }) == "// sentinel",
		"Existing content overwritten: " .. extension
	)
	check(open("Old." .. extension, {}, true) == "", "Old empty file changed: " .. extension)
end
local scratch = vim.api.nvim_create_buf(false, true)
check(
	not require("configs.templates.common").eligible({ buf = scratch, event = "BufNewFile" }),
	"Special buffer accepted"
)
vim.api.nvim_buf_delete(scratch, { force = true })
local readonly = vim.api.nvim_create_buf(false, false)
vim.bo[readonly].modifiable = false
check(
	not require("configs.templates.common").eligible({ buf = readonly, event = "BufNewFile" }),
	"Unmodifiable buffer accepted"
)
vim.api.nvim_buf_delete(readonly, { force = true })
check(open("main.rs", nil):find("fn main()", 1, true), "Rust main template missing")
check(open("lib.rs", nil):find("//! Library", 1, true), "Rust library template missing")
check(open("module.rs", {}):find("//! Module", 1, true), "Rust disk module template missing")
check(open("Old.rs", {}, true) == "", "Old Rust file changed")
check(open("Existing.rs", { "// keep" }) == "// keep", "Existing Rust changed")
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
