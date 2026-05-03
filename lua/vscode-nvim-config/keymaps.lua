local vscode = require("vscode")

local function save_and_close()
	vscode.action("workbench.action.files.save")
	vscode.action("workbench.action.closeActiveEditor")
	vscode.action("workbench.action.closePanel")
	vscode.action("workbench.action.closeAuxiliaryBar")
end

-- Save (Normal mode)
vim.keymap.set("n", "<C-s>", function()
	vscode.action("workbench.action.files.save")
end, { desc = "Save File" })

-- Explorer Toggle
vim.keymap.set("n", "<leader>e", function()
	vscode.action("workbench.action.toggleSidebarVisibility")
end, { desc = "Toggle Explorer" })

vim.keymap.set("n", "<leader>en", function()
	vscode.action("workbench.action.focusActiveEditorGroup")
end, { desc = "Focus Editor" })

-- Terminal
vim.keymap.set("n", "<C-t>", function()
	vscode.action("workbench.action.terminal.toggleTerminal")
end, { desc = "Toggle Terminal" })

-- Save and Close
vim.keymap.set("n", "<C-x>", save_and_close, { desc = "Save and Close Tab" })

-- Hover and Copy
vim.keymap.set("n", "<leader>d", function()
	vscode.action("multiCommand.openHoverAndCopy")
end, { desc = "Hover and Copy" })

-- Reveal Definition
vim.keymap.set("n", "<C-CR>", function()
	vscode.action("editor.action.revealDefinition")
end, { desc = "Reveal Definition" })

-- Window Navigation
vim.keymap.set("n", "<C-h>", function() vscode.action("workbench.action.focusLeftGroup") end, { desc = "Focus Left Group" })
vim.keymap.set("n", "<C-j>", function() vscode.action("workbench.action.focusBelowGroup") end, { desc = "Focus Below Group" })
vim.keymap.set("n", "<C-k>", function() vscode.action("workbench.action.focusAboveGroup") end, { desc = "Focus Above Group" })
vim.keymap.set("n", "<C-l>", function() vscode.action("workbench.action.focusRightGroup") end, { desc = "Focus Right Group" })
