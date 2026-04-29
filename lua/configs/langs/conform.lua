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
		-- Web
		css = { "prettier" },
		html = { "prettier" },
		-- dotnet
		cs = { "csharpier" },
		csproj = { "xmlformat" },
		xml = { "xmlformat" },
		-- Caddy
		caddy = { "caddy" },
		sql = { lsp_format = "never" },
	},
	formatters = {
		injected = {
			options = { ignore_errors = true },
		},
		csharpier = {
			command = "csharpier",
			args = { "format", "--write-stdout" },
			to_stdin = true,
		},
		xmlformat = {
			command = "xmlformat",
		},
		caddy = {
			command = "caddy",
			args = { "fmt", "-" },
			to_stdin = true,
		},
	},
}
