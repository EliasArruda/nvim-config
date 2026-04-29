require("core")
require("configs")

if vim.g.vscode then
	require("vscode-nvim-config.init")
elseif vim.g.neovide then
	require("configs.neovide")
end
