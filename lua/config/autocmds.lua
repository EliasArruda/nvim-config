vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    -- Impede que plugins de autoformat mexam neste buffer
    vim.b.autoformat = false

    -- Configurações de tab específicas
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 0
    vim.opt_local.tabstop = 2
  end,
})
