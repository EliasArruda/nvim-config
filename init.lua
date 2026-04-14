if vim.g.vscode then
  require("vscode-nvim-config.init")
elseif vim.g.neovide then
  require("config.neovide")
else
  require("config.terminal")
end
