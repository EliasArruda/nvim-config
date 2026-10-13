return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = { move = { set_jumps = true } },
	config = function(_, opts)
		require("nvim-treesitter-textobjects").setup(opts)
		local moves = {
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
		}
		for method, mappings in pairs(moves) do
			for key, capture in pairs(mappings) do
				vim.keymap.set({ "n", "x", "o" }, key, function()
					require("nvim-treesitter-textobjects.move")[method](capture, "textobjects")
				end, { desc = method .. " " .. capture })
			end
		end
	end,
}
