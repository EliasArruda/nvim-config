local M = {}
function M.report()
	local buf = vim.api.nvim_get_current_buf()
	local root = require("core.project").root(buf)
	local lines = {
		"Neovim environment",
		"",
		"Version: " .. tostring(vim.version()),
		"Config: " .. vim.fn.stdpath("config"),
		"Project: " .. root,
		"Buffer: " .. vim.api.nvim_buf_get_name(buf),
		"Filetype: " .. vim.bo[buf].filetype,
		"Large file: " .. tostring(require("config.runtime").is_large(buf)),
		"",
		"Language clients:",
	}
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		lines[#lines + 1] = ("  %s: ready=%s root=%s"):format(
			c.name,
			tostring(c.initialized),
			c.config.root_dir or "none"
		)
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = "Insert Tab mapping:"
	local map = vim.fn.maparg("<Tab>", "i", false, true)
	lines[#lines + 1] = "  " .. (map.desc or map.rhs or "native indentation")
	lines[#lines + 1] = ""
	for _, tool in ipairs({
		"git",
		"rg",
		"fd",
		"node",
		"tree-sitter",
		"rustup",
		"cargo",
		"rustc",
		"rust-analyzer",
		"rustfmt",
		"taplo",
		"clangd",
		"clang-format",
		"codelldb",
		"clang++",
		"cmake",
		"ninja",
		"emmet-language-server",
		"vscode-html-language-server",
		"dotnet-easydotnet",
	}) do
		lines[#lines + 1] = tool .. ": " .. (vim.fn.executable(tool) == 1 and vim.fn.exepath(tool) or "MISSING")
	end
	return lines
end
function M.setup()
	vim.api.nvim_create_user_command("NvimDoctor", function()
		local lines = M.report()
		vim.cmd("botright new")
		vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile = "nofile", "wipe", false
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
		vim.bo.modifiable = false
	end, { desc = "Inspect project, completion, LSP and external tools", force = true })
end
return M
