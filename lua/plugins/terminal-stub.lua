if vim.g.neovide or vim.g.goneovim then
  return {
    { "mrcjkb/hererocks", lazy = true, cond = false },
    { "vhyrro/luarocks.nvim", lazy = true, cond = false },
    { "3rd/image.nvim", lazy = true, cond = false },
    { "sphamba/smear-cursor.nvim", lazy = true, cond = false },
  }
else
  return {}
end
