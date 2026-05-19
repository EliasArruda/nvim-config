return {
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			vim.g.VM_set_mappings = 1
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",       -- Changed from <C-n> (conflict with blink.cmp)
				["Find All"] = "<C-S-d>",        -- Changed from <C-S-n>
				["Remove Last"] = "<C-u>",       -- Changed from <C-p> (conflict with blink.cmp)
				["Select All"] = "<C-a>",
			}
		end,
	},
}
