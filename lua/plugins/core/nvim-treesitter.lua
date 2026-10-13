return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = function()
		local ts = require("nvim-treesitter")
		local available = ts.get_available()
		local langs = vim.tbl_filter(function(lang) return vim.tbl_contains(available, lang) end, require("configs.langs.treesitter"))
		ts.update(langs):wait(300000)
	end,
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },

	opts = function()
		local ok, langs = pcall(require, "configs.langs.treesitter")

		return { ensure_installed = (ok and type(langs) == "table") and langs or {} }
	end,

	config = function(_, opts)
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		-- Installation is explicit through :NvimParsersInstall or :TSUpdate.

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
			callback = function(event)
				if require("config.runtime").is_large(event.buf) then return end
				-- The main branch exposes highlighting through Neovim itself.
				-- Razor injects its markup into the HTML parser. Neovim does not
				-- reliably load that injected language before the Razor highlighter,
				-- leaving tag names without captures until HTML is opened elsewhere.
				if event.match == "razor" then
					pcall(vim.treesitter.language.add, "html")
				end
				local lang = vim.treesitter.language.get_lang(event.match)
				if not lang then
					return
				end
				local loaded, available = pcall(vim.treesitter.language.add, lang)
				if not loaded or not available then
					return
				end
				local ok, err = pcall(vim.treesitter.start, event.buf)
				if not ok then
					vim.notify_once("Treesitter " .. lang .. ": " .. tostring(err), vim.log.levels.ERROR)
					return
				end
				if event.match == "razor" then
					local ok_parser, parser = pcall(vim.treesitter.get_parser, event.buf, "razor")
					if ok_parser then
						parser:parse(true)
					end
				end
			end,
		})
	end,
}
