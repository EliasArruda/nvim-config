local vscode = require("vscode")

local function save_and_close()
	vscode.action("workbench.action.files.save")
	vscode.action("workbench.action.closeActiveEditor")
	vscode.action("workbench.action.closePanel")
	vscode.action("workbench.action.closeAuxiliaryBar")
end

-- Save in normal mode.
vim.keymap.set("n", "<C-s>", function()
	vscode.action("workbench.action.files.save")
end, { desc = "Save File" })

-- Match the regular Neovim behavior: leave insert/visual mode, then save.
vim.keymap.set({ "i", "v", "x" }, "<C-s>", function()
	vscode.action("vscode-neovim.escape")
	vscode.action("workbench.action.files.save")
end, { desc = "Normal Mode and Save File" })

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

-- LSP navigation must be handled by Neovim so the `g` prefix remains
-- available to operator-pending commands such as `dgg`.
vim.keymap.set("n", "gd", function()
	vscode.action("editor.action.revealDefinition")
end, { desc = "Go to Definition" })

vim.keymap.set("n", "gD", function()
	vscode.action("editor.action.revealDeclaration")
end, { desc = "Go to Declaration" })

vim.keymap.set("n", "gy", function()
	vscode.action("editor.action.goToTypeDefinition")
end, { desc = "Go to Type Definition" })

vim.keymap.set("n", "gi", function()
	vscode.action("editor.action.goToImplementation")
end, { desc = "Go to Implementation" })

vim.keymap.set("n", "gr", function()
	vscode.action("references-view.findReferences")
end, { desc = "Find References" })

local function show_hover()
	vscode.action("editor.action.showHover")
end

vim.keymap.set("n", "<leader>cd", show_hover, { desc = "Hover" })
vim.keymap.set("n", "K", show_hover, { desc = "Hover" })

vim.keymap.set("n", "<leader>cy", function()
	vscode.action("sukespinho.copyDiagnostic")
end, { desc = "Copy Diagnostic" })

-- Window Navigation
vim.keymap.set("n", "<C-h>", function() vscode.action("workbench.action.navigateLeft") end, { desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", function() vscode.action("workbench.action.terminal.focus") end, { desc = "Focus Terminal Below" })
vim.keymap.set("n", "<C-k>", function() vscode.action("workbench.action.navigateUp") end, { desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", function() vscode.action("workbench.action.navigateRight") end, { desc = "Navigate Right" })
