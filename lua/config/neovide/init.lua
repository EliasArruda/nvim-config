vim.o.guifont = "JetBrainsMono Nerd Font:h16" -- mude o 14 pra 16, 18, 20, etc.
vim.opt.linespace = 0
vim.g.neovide_opacity = 0.95
vim.g.neovide_normal_opacity = 0.95
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 8.0
vim.g.neovide_floating_blur_amount_y = 8.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_corner_radius = 4.0
vim.g.neovide_scroll_animation_length = 0.25
vim.g.neovide_cursor_animation_length = 0.22
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_refresh_rate = 400
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_confirm_quit = true
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_vfx_particle_density = 4.0
vim.g.neovide_cursor_vfx_particle_speed = 10.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1
vim.g.neovide_no_idle = true

vim.opt.clipboard = "unnamedplus"
vim.keymap.set({ "i", "c" }, "<C-BS>", "<C-w>", { noremap = true, silent = true })
if vim.g.neovide then
  vim.keymap.set({ "n", "i", "c", "v" }, "<C-S-v>", "<C-r>+")
  vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pa')
end

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

-- Keymaps Neovide
local is_mac = vim.fn.has("mac") == 1
local cmd = is_mac and "<D-" or "<C-"

vim.keymap.set({ "n", "i", "v" }, cmd .. "s>", function()
  vim.cmd.write()
end, { desc = "Save file" })
vim.keymap.set("v", cmd .. "c>", '"+y', { desc = "Copy" })
vim.keymap.set({ "n", "i", "v" }, cmd .. "v>", '"+p', { desc = "Paste" })
vim.keymap.set("n", cmd .. "=>", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, { desc = "Zoom in" })
vim.keymap.set("n", cmd .. "->", function()
  vim.g.neovide_scale_factor = math.max(0.5, vim.g.neovide_scale_factor - 0.1)
end, { desc = "Zoom out" })
vim.keymap.set("n", cmd .. "0>", function()
  vim.g.neovide_scale_factor = 1.0
end, { desc = "Reset zoom" })
vim.keymap.set("n", cmd .. "f>", function()
  vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = "Toggle fullscreen" })

-- Autocmds
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.g.neovide_opacity = 0.98
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.g.neovide_opacity = 0.95
  end,
})
