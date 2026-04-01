local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 2. Configura como os diagnósticos aparecem
vim.diagnostic.config({
  signs = true, -- Ativa os ícones na lateral
  underline = true, -- Sublinha o código com erro
  update_in_insert = false, -- Só atualiza ao sair do modo de inserção (evita distrações)
  virtual_text = {
    prefix = "●", -- Círculo pequeno no final da linha
    spacing = 4,
  },
  severity_sort = true,
  float = {
    border = "rounded", -- Janela de erro arredondada
    source = "always",
  },
})
