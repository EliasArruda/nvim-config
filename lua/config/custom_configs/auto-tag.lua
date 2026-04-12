require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
  -- Adicione isso se não estiver funcionando
  ft = { "html", "razor", "cshtml", "javascriptreact", "typescriptreact" },
})
