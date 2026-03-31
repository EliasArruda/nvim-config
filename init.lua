if vim.g.neovide then
  require("config.neovide")
elseif vim.g.goneovim then
  require("config.goneovim")
else
  require("config.terminal")
end
