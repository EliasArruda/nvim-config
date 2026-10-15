local template_group = vim.api.nvim_create_augroup("FileTemplates", { clear = true })

local function to_pascal_case(str)
	str = str:gsub("%.razor%.cs$", ""):gsub("%.cs$", ""):gsub("[^%w_]", "_")
	if str:match("^%d") then
		str = "_" .. str
	end
	str = str:gsub("_(%l)", function(c)
		return c:upper()
	end)
	str = str:gsub("^%l", string.upper)
	return str
end

local function get_dotnet_namespace(directory)
	local current_dir = directory
	local sub_namespaces = {}
	local project_name = nil

	while true do
		local search_path = vim.fn.fnameescape(current_dir) .. "/*.csproj"
		local csproj_files = vim.fn.glob(search_path, true, true)

		if #csproj_files > 0 then
			project_name = vim.fn.fnamemodify(csproj_files[1], ":t:r")
			local content = table.concat(vim.fn.readfile(csproj_files[1]), "\n")
			local root_namespace = content:match("<RootNamespace>%s*([%w_.]+)%s*</RootNamespace>")
			project_name = root_namespace or project_name
			break
		end

		local folder_name = vim.fn.fnamemodify(current_dir, ":t")
		table.insert(sub_namespaces, 1, folder_name)

		local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
		if parent_dir == current_dir then
			break
		end
		current_dir = parent_dir
	end

	if project_name then
		local full_namespace = project_name
		if #sub_namespaces > 0 then
			full_namespace = full_namespace .. "." .. table.concat(sub_namespaces, ".")
		end
		return full_namespace:gsub("[^%w%.]", "_")
	end

	local fallback = directory:match("[/\\]src[/\\](.+)$") or directory:match("src[/\\](.+)$") or "App"
	return fallback:gsub("[/\\]", "."):gsub("[^%w%.]", "_")
end

local function apply_template(event)
	local line_count = vim.api.nvim_buf_line_count(0)
	local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
	if line_count > 1 or first_line ~= "" then
		return
	end
	if
		not vim.bo.modifiable
		or (vim.bo.buftype ~= "" and not (vim.g.vscode and vim.bo.buftype == "acwrite" and vim.b.vscode_controlled))
	then
		return
	end

	local filename = vim.fn.expand("%:t")
	local filepath = vim.fn.expand("%:p:h")
	local classname = to_pascal_case(filename)

	-- DETECÇÕES INTELIGENTES
	local is_interface = classname:match("^I%u") ~= nil
	local is_controller = classname:match("Controller$") ~= nil
	local is_exception = classname:match("Exception$") ~= nil
	local is_test = classname:match("Tests?$") ~= nil
	local is_enum = classname:match("Enum$")
		or classname:match("Kind$")
		or classname:match("Status$")
		or classname:match("Type$")
	local is_static = classname:match("Extensions$")
		or classname:match("Helper$")
		or classname:match("Helpers$")
		or classname:match("Utils$")
		or classname:match("Constants$")
	local is_handler = classname:match("Handler$") ~= nil
	local is_record = classname:match("Dto$")
		or classname:match("Command$")
		or classname:match("Query$")
		or classname:match("Event$")
		or classname:match("Request$")
		or classname:match("Response$")

	local namespace = get_dotnet_namespace(filepath)

	local template
	local cursor_line
	local cursor_col = 4

	-- ── GlobalUsings ──────────────────────────────────────────────────
	if classname == "GlobalUsings" then
		template = {
			"global using System;",
			"global using System.Collections.Generic;",
			"global using System.Linq;",
			"global using System.Threading;",
			"global using System.Threading.Tasks;",
			"",
		}
		cursor_line = 6
		cursor_col = 0

	-- ── Controller ────────────────────────────────────────────────────
	elseif is_controller then
		template = {
			"using Microsoft.AspNetCore.Mvc;",
			"",
			"namespace " .. namespace .. ";",
			"",
			"[ApiController]",
			'[Route("api/[controller]")]',
			"public sealed class " .. classname .. " : ControllerBase",
			"{",
			"    ",
			"}",
		}
		cursor_line = 9

	-- ── Test ──────────────────────────────────────────────────────────
	elseif is_test then
		template = {
			"// Add your test framework and assertions here.",
			"",
			"namespace " .. namespace .. ";",
			"",
			"public class " .. classname,
			"{",
			"",
			"    public void Should_()",
			"    {",
			"        // Arrange",
			"        ",
			"        // Act",
			"        ",
			"        // Assert",
			"        ",
			"    }",
			"}",
		}
		cursor_line = 9
		cursor_col = 23

	-- ── Exception ─────────────────────────────────────────────────────
	elseif is_exception then
		template = {
			"namespace " .. namespace .. ";",
			"",
			"public sealed class " .. classname .. " : Exception",
			"{",
			"    public " .. classname .. "(string message) : base(message) { }",
			"",
			"    public " .. classname .. "(string message, Exception inner) : base(message, inner) { }",
			"}",
		}
		cursor_line = 8
		cursor_col = 1

	-- ── Enum ──────────────────────────────────────────────────────────
	elseif is_enum then
		template = {
			"namespace " .. namespace .. ";",
			"",
			"public enum " .. classname,
			"{",
			"    ",
			"}",
		}
		cursor_line = 5

	-- ── Static class (Extensions / Helper / Utils / Constants) ────────
	elseif is_static then
		template = {
			"namespace " .. namespace .. ";",
			"",
			"public static class " .. classname,
			"{",
			"    ",
			"}",
		}
		cursor_line = 5

	-- ── Handler (CQRS) ────────────────────────────────────────────────
	elseif is_handler then
		template = {
			"namespace " .. namespace .. ";",
			"",
			"public sealed class " .. classname,
			"{",
			"    public void Handle()",
			"    {",
			"        ",
			"    }",
			"}",
		}
		cursor_line = 7

	-- ── Record (Dto / Command / Query / Event / Request / Response) ───
	elseif is_record then
		template = {
			"namespace " .. namespace .. ";",
			"",
			"public sealed record " .. classname .. "(",
			"    ",
			");",
		}
		cursor_line = 4

	-- ── Interface / Class ─────────────────────────────────────────────
	else
		local type_keyword = filename:match("%.razor%.cs$") and "partial class"
			or (is_interface and "interface" or "sealed class")
		template = {
			"namespace " .. namespace .. ";",
			"",
			"public " .. type_keyword .. " " .. classname,
			"{",
			"    ",
			"}",
		}
		cursor_line = 5
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
	vim.b[event.buf].csharp_template_applied = true

	vim.schedule(function()
		if not vim.api.nvim_buf_is_valid(event.buf) or vim.api.nvim_get_current_buf() ~= event.buf then
			return
		end
		vim.api.nvim_win_set_cursor(0, { cursor_line, cursor_col })
		vim.cmd("startinsert")
	end)
end

local events = { "BufNewFile", "BufReadPost", "BufEnter" }
vim.api.nvim_create_autocmd(events, {
	pattern = "*.cs",
	group = template_group,
	callback = function(event)
		local buf = event.buf
		if vim.b[buf].csharp_template_applied then
			return
		end
		if not require("configs.templates.common").eligible(event) then
			return
		end
		local function run()
			if
				not vim.api.nvim_buf_is_valid(buf)
				or vim.api.nvim_get_current_buf() ~= buf
				or vim.b[buf].csharp_template_applied
			then
				return
			end
			apply_template(event)
		end
		if vim.g.vscode then
			vim.defer_fn(run, 200)
		else
			run()
		end
	end,
})
