return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	version = false,
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make", -- Simplificado para Arch Linux
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	},
	keys = {
		-- Buffers
		{ "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
		{
			"<leader>fb",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
			desc = "Buffers",
		},
		{ "<leader>fB", "<cmd>Telescope buffers<cr>", desc = "Buffers (all)" },

		-- Find Files
		{ "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
		{ "<leader>fF", "<cmd>Telescope find_files cwd=false<cr>", desc = "Find Files (cwd)" },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		{ "<leader>fR", "<cmd>Telescope oldfiles cwd=true<cr>", desc = "Recent (cwd)" },

		-- Grep / Search
		{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
		{ "<leader>sG", "<cmd>Telescope live_grep root=false<cr>", desc = "Grep (cwd)" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word (Root Dir)" },
		{ "<leader>sW", "<cmd>Telescope grep_string root=false<cr>", desc = "Word (cwd)" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = "x", desc = "Selection (Root Dir)" },
		{ "<leader>sW", "<cmd>Telescope grep_string root=false<cr>", mode = "x", desc = "Selection (cwd)" },

		-- Git
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
		{ "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
		{ "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },

		-- System/Misc
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		{ "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search History" },
		{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Lines" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
		{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
		{ "<leader>uC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },

		-- Symbols
		{
			"<leader>ss",
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
			desc = "Goto Symbol",
		},
		{
			"<leader>sS",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
			desc = "Goto Symbol (Workspace)",
		},
	},
	opts = function()
		local actions = require("telescope.actions")

		-- Função auxiliar para abrir com Trouble (se instalado)
		local open_with_trouble = function(...)
			local ok, trouble = pcall(require, "trouble.sources.telescope")
			if ok then
				return trouble.open(...)
			else
				print("Trouble.nvim não instalado")
			end
		end

		-- Função para detectar o melhor comando de busca disponível no sistema
		local function find_command()
			if vim.fn.executable("rg") == 1 then
				return { "rg", "--files", "--color", "never", "-g", "!.git" }
			elseif vim.fn.executable("fd") == 1 then
				return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
			elseif vim.fn.executable("fdfind") == 1 then
				return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
			elseif vim.fn.executable("find") == 1 and vim.fn.has("win32") == 0 then
				return { "find", ".", "-type", "f" }
			end
		end

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						["<c-t>"] = open_with_trouble,
						["<C-Down>"] = actions.cycle_history_next,
						["<C-Up>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_down,
						["<C-b>"] = actions.preview_scrolling_up,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = find_command,
					hidden = true,
				},
			},
		}
	end,
}
