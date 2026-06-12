return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		build = '<cmd>lua require("go.install").update_all()<cr>',
		config = function()
			require("go").setup({
				lsp_cfg = false,
				lsp_keymaps = false,
				gofmt = "gofumpt",
				goimport = "gopls",
				test_runner = "go",
				verbose = false,
				notify = false,
			})

			local function run_and_quickfix(cmd, name)
				local dir = vim.fn.getcwd()
				if vim.bo.filetype == "go" then
					dir = vim.fn.expand("%:p:h")
				end
				vim.fn.jobstart(cmd, {
					cwd = dir,
					on_stdout = function(_, data)
						if not data then return end
						local items = vim.tbl_filter(function(l) return l ~= "" end, data)
						if #items > 0 then
							vim.fn.setqflist({}, " ", { lines = items, efm = "%f:%l:%c: %m" })
							vim.schedule(function() vim.cmd("copen") end)
						end
					end,
					on_stderr = function(_, data)
						if not data then return end
						for _, line in ipairs(data) do
							if line ~= "" then vim.notify(name .. ": " .. line, vim.log.levels.WARN) end
						end
					end,
					on_exit = function(_, code)
						if code == 0 then vim.notify(name .. ": no issues found", vim.log.levels.INFO) end
					end,
				})
			end

			vim.api.nvim_create_user_command("GoLint", function()
				run_and_quickfix({ "golangci-lint", "run", "--fast", "--out-format", "line-number", "./..." }, "golangci-lint")
			end, {})

			vim.api.nvim_create_user_command("GoVulncheck", function()
				run_and_quickfix({ "govulncheck", "-json", "./..." }, "govulncheck")
			end, {})
		end,
		keys = {
			{ "<leader>ma", "<cmd>GoAddTag<CR>", desc = "Add struct tags" },
			{ "<leader>mr", "<cmd>GoRemoveTag<CR>", desc = "Remove struct tags" },
			{ "<leader>mi", "<cmd>GoImpl<CR>", desc = "Implement interface" },
			{ "<leader>mt", "<cmd>GoTest<CR>", desc = "Run test at cursor" },
			{ "<leader>mT", "<cmd>GoTestFunc<CR>", desc = "Run test function" },
			{ "<leader>ml", "<cmd>GoLint<CR>", desc = "golangci-lint" },
			{ "<leader>mv", "<cmd>GoVulncheck<CR>", desc = "govulncheck" },
		},
	},
}
