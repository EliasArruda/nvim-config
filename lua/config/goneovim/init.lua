-- Configs específicas do Goneovim
vim.opt.linespace = 0
vim.g.goneovim_transparency = 0.95
vim.g.goneovim_hide_mouse_when_typing = true
vim.g.goneovim_confirm_quit = true

-- Zoom e fullscreen (mesma lógica do Neovide)
vim.keymap.set("n", "<C-=>", function()
  vim.g.goneovim_scale_factor = (vim.g.goneovim_scale_factor or 1) + 0.1
end)
vim.keymap.set("n", "<C-->", function()
  vim.g.goneovim_scale_factor = math.max(0.5, (vim.g.goneovim_scale_factor or 1) - 0.1)
end)
vim.keymap.set("n", "<C-0>", function()
  vim.g.goneovim_scale_factor = 1.0
end)
vim.keymap.set("n", "<C-f>", function()
  vim.g.goneovim_fullscreen = not vim.g.goneovim_fullscreen
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Plugins organizados por categoria
    { import = "plugins.core" },
    { import = "plugins.editor" },
    { import = "plugins.ui" },
    { import = "plugins.tools" },
    { import = "plugins.lang" },

    { import = "plugins.terminal-stub" },
    { import = "plugins.neovide" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("config")
