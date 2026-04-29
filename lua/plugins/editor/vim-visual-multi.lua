return {
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			-- Configurações para evitar conflitos e definir atalhos intuitivos
			vim.g.VM_set_mappings = 1
			vim.g.VM_maps = {
				['Find Under'] = '<C-n>',
				['Find All'] = '<C-S-n>',
				['Remove Last'] = '<C-p>',
				['Select All'] = '<C-a>',
			}
		end,
	},
}
