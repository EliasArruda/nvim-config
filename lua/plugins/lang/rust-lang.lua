return {
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		opts = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
						inlayHints = {
							chainingHints = { enable = true },
							typeHints = { enable = true },
							parameterHints = { enable = true },
						},
					},
				},
			},
		},
	},
}
