return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	event = { "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },

	opts = function()
		local ok, langs = pcall(require, "configs.langs.treesitter")

		return {
			ensure_installed = (ok and type(langs) == "table") and langs or {},

			highlight = { enable = true },
			indent = { enable = true },
			folds = { enable = true },
		}
	end,

	config = function(_, opts)
		local TS = require("nvim-treesitter")

		if not TS.get_installed then
			vim.notify("Reinicie o Neovim e rode :TSUpdate", vim.log.levels.ERROR)
			return
		end

		if type(opts.ensure_installed) ~= "table" then
			vim.notify("`ensure_installed` deve ser uma tabela", vim.log.levels.ERROR)
			return
		end

		-- Setup
		TS.setup(opts)

		-- Instala parsers faltando
		local installed = TS.get_installed()
		local installed_set = {}
		for _, lang in ipairs(installed) do
			installed_set[lang] = true
		end

		local missing = vim.tbl_filter(function(lang)
			return not installed_set[lang]
		end, opts.ensure_installed or {})

		if #missing > 0 then
			TS.install(missing, { summary = true })
		end

		-- Ativa highlight/indent/folds por filetype (igual ao LazyVim)
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
			callback = function(ev)
				local ft = ev.match
				local lang = vim.treesitter.language.get_lang(ft)

				-- Verifica se o parser está disponível
				local has_parser = pcall(vim.treesitter.get_parser, ev.buf, lang)
				if not has_parser then
					return
				end

				local function feat_enabled(feat)
					local f = opts[feat] or {}
					return f.enable ~= false and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
				end

				-- Highlighting
				if feat_enabled("highlight") then
					pcall(vim.treesitter.start, ev.buf)
				end

				-- Indentação
				if feat_enabled("indent") then
					if vim.bo[ev.buf].indentexpr == "" then
						vim.bo[ev.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
					end
				end

				-- Folds
				if feat_enabled("folds") then
					local win = vim.api.nvim_get_current_win()
					if vim.wo[win].foldmethod ~= "expr" then
						vim.wo[win].foldmethod = "expr"
						vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.wo[win].foldenable = false
					end
				end
			end,
		})
	end,
}
