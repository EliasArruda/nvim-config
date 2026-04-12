local disabled_plugins = {
  "folke/flash.nvim",
  "catppuccin/catppuccin",
  "folke/tokyonight.nvim", -- Adicionado o autor
}

local overrides = {}
for _, plugin in ipairs(disabled_plugins) do
  table.insert(overrides, { plugin, enabled = false })
end

-- ~/.config/nvim/lua/config/terminal/init.lua

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
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "midnight" } },

    -- Plugins organizados por categoria
    { import = "plugins.core" },
    { import = "plugins.editor" },
    { import = "plugins.ui" },
    { import = "plugins.tools" },
    { import = "plugins.lang" },

    -- Só no terminal
    { import = "plugins.terminal" },

    unpack(overrides),
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "tokyonight",
        "catppuccin",
        "flash.nvim",
      },
    },
  },
})

require("config")
