vim.o.guifont = "JetBrainsMono Nerd Font:h16"
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

-- ==========================================
-- CORREÇÃO DEFINITIVA: <C-Backspace> Inteligente (Insert, Cmd e Terminal)
-- ==========================================
local function smart_ctrl_backspace()
  local bt = vim.bo.buftype
  local ft = vim.bo.filetype

  local key = vim.api.nvim_replace_termcodes("<C-w>", true, false, true)

  if bt == "prompt" or ft:match("snacks") or ft:match("neo%-tree") then
    vim.api.nvim_feedkeys(key, "m", false)
  else
    vim.api.nvim_feedkeys(key, "n", false)
  end
end

-- Mapeamentos para o modo de Inserção (i)
vim.keymap.set("i", "<C-BS>", smart_ctrl_backspace, { noremap = true })
vim.keymap.set("i", "<C-h>", smart_ctrl_backspace, { noremap = true })

-- Mapeamentos para o modo de Comando (c)
vim.keymap.set("c", "<C-BS>", "<C-w>", { noremap = true })
vim.keymap.set("c", "<C-h>", "<C-w>", { noremap = true })

-- NOVIDADE: Mapeamento exclusivo para o modo Terminal (t)
vim.keymap.set("t", "<C-BS>", function()
  local term_id = vim.b.terminal_job_id
  if term_id then
    -- Envia o código ASCII do Ctrl+W (\23) direto para o Bash/Zsh/PowerShell
    vim.api.nvim_chan_send(term_id, "\23")
  end
end, { noremap = true })
-- ==========================================
--
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
    { import = "plugins.core" },
    { import = "plugins.editor" },
    { import = "plugins.ui" },
    { import = "plugins.tools" },
    { import = "plugins.lang" },
    { import = "plugins.terminal-stub" },
    { import = "plugins.neovide" },
  },
  defaults = { lazy = false, version = false },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})

require("config")

-- Keymaps Neovide (Copy, Paste, Save, Zoom)
if vim.g.neovide then
  local is_mac = vim.fn.has("mac") == 1

  if is_mac then
    vim.keymap.set({ "n", "i", "v" }, "<D-s>", function()
      vim.cmd.write()
    end, { desc = "Save file" })
    vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy" })
    vim.keymap.set({ "n", "v" }, "<D-v>", '"+p', { desc = "Paste" })
    vim.keymap.set({ "i", "c" }, "<D-v>", "<C-r>+", { desc = "Paste in insert/cmd" })
    vim.keymap.set("t", "<D-v>", '<C-\\><C-n>"+pi', { desc = "Paste in terminal" })

    vim.keymap.set("n", "<D-=>", function()
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end, { desc = "Zoom in" })
    vim.keymap.set("n", "<D-->", function()
      vim.g.neovide_scale_factor = math.max(0.5, vim.g.neovide_scale_factor - 0.1)
    end, { desc = "Zoom out" })
    vim.keymap.set("n", "<D-0>", function()
      vim.g.neovide_scale_factor = 1.0
    end, { desc = "Reset zoom" })
    vim.keymap.set("n", "<D-f>", function()
      vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, { desc = "Toggle fullscreen" })
  else
    vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
      vim.cmd.write()
    end, { desc = "Save file" })

    vim.keymap.set("v", "<C-S-c>", '"+y', { desc = "Copy" })

    vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+p', { desc = "Paste in normal/visual" })
    vim.keymap.set({ "i", "c" }, "<C-S-v>", "<C-r>+", { desc = "Paste in insert/cmd" })
    vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+pi', { desc = "Paste in terminal" })

    vim.keymap.set("n", "<C-=>", function()
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end, { desc = "Zoom in" })
    vim.keymap.set("n", "<C-->", function()
      vim.g.neovide_scale_factor = math.max(0.5, vim.g.neovide_scale_factor - 0.1)
    end, { desc = "Zoom out" })
    vim.keymap.set("n", "<C-0>", function()
      vim.g.neovide_scale_factor = 1.0
    end, { desc = "Reset zoom" })
    vim.keymap.set("n", "<C-f>", function()
      vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, { desc = "Toggle fullscreen" })
  end
end

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
