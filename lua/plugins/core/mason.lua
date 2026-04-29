return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})

			local ok, cfg = pcall(require, "configs.langs.mason")
			local tools = (ok and type(cfg) == "table") and cfg or { ensure_installed = {} }

			local registry = require("mason-registry")

			local function install_ensured()
				for _, tool in ipairs(tools.ensure_installed) do
					local ok_pkg, pkg = pcall(registry.get_package, tool)
					if ok_pkg then
						if not pkg:is_installed() then
							pkg:install()
						end
					end
				end
			end

			if registry.refresh then
				registry.refresh(install_ensured)
			else
				install_ensured()
			end
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
		end,
	},
}
