return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- 🎨 Breakpoint Design (Sinais do Vimspector)
			vim.fn.sign_define('DapBreakpoint', { text = '⚪', texthl = 'DapBreakpointSymbol', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
			vim.fn.sign_define('DapStopped', { text = '🔴', texthl = 'yellow', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
			vim.fn.sign_define('DapBreakpointRejected', { text = '⭕', texthl = 'DapStoppedSymbol', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

			-- 🛠️ Balanced UI Setup (Full Layout)
			dapui.setup({
				expand_lines = true,
				controls = { enabled = false },
				floating = { border = "rounded" },
				render = { max_type_length = 60, max_value_lines = 200 },
			})

			-- 🚀 Auto-open/close
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

			-- ⌨️ Ergonomic Keymaps (Modo Normal apenas para evitar conflitos com Terminal)
			vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
			vim.keymap.set("n", "<C-F5>", function() dap.close() end, { desc = "DAP Stop" })
			vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
			vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
			vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
			vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Toggle DAP UI" })
			vim.keymap.set({ "n", "v" }, "<leader>dw", function() dapui.eval(nil, { enter = true }) end, { desc = "Add to Watches" })
			
			-- Special Eval
			vim.keymap.set({ "n", "v" }, "Q", function() dapui.eval() end, { desc = "Eval value (Hover)" })

			-- Load Language Configurations
			require("configs.langs.dap").setup()
		end,
	},
}
