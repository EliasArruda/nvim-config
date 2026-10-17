local web_formatters = function(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local root = require("core.project").root(bufnr)
	local biome_root = vim.fs.find({ "biome.json", "biome.jsonc" }, { path = vim.fs.dirname(filename), upward = true, stop = vim.fs.dirname(root) })[1]

	-- Biome and Prettier should never run in sequence: both print the whole file
	-- and projects commonly migrate between them. Prefer the project's choice.
	if biome_root then
		return { "biome" }
	end

	return { "prettier" }
end

return {
	default_format_opts = {
		timeout_ms = 3000,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		-- Generic
		lua = { "stylua" },
		fish = { "fish_indent" },
		sh = { "shfmt" },
		python = { "ruff_organize_imports", "ruff_format" },
		-- C / C++: clang-format discovers the project .clang-format.
		c = { "clang_format" },
		cpp = { "clang_format" },
		-- Web
		css = web_formatters,
		html = { "prettier" },
		vue = { "prettier" },
		svelte = { "prettier" },
		javascript = web_formatters,
		javascriptreact = web_formatters,
		typescript = web_formatters,
		typescriptreact = web_formatters,
		json = web_formatters,
		jsonc = web_formatters,
		graphql = web_formatters,
		markdown = { "prettier" },
		mdx = { "prettier" },
		-- dotnet
		cs = { "csharpier" },
		razor = { lsp_format = "prefer", name = "easy_dotnet" },
		csproj = { "xmlformat" },
		xml = { "xmlformat" },
		-- Caddy
		caddy = { "caddy" },
		-- Go
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Ruby / Rails
		-- Ruby LSP selects the formatter from the project bundle (RuboCop or
		-- Standard), so formatting never silently uses a global version.
		ruby = { lsp_format = "first" },
		eruby = { "erb_format" },
		sql = { lsp_format = "never" },
	},
	formatters = {
		injected = {
			options = { ignore_errors = true },
		},
		xmlformat = {
			command = "xmlformat",
		},
		caddy = {
			command = "caddy",
			args = { "fmt", "-" },
			stdin = true,
		},
		erb_format = {
			command = vim.fn.stdpath("config") .. "/bin/erb-format",
		},
	},
}
