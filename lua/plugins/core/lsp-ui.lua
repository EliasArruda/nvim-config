return {
  -- 2. CONFIGURAÇÃO DO NOICE (Janelas flutuantes de hover)
  {
    "folke/noice.nvim",
    optional = true,
    opts = function(_, opts)
      opts.views = opts.views or {}
      opts.views.hover = opts.views.hover or {}

      opts.views.hover.scrollbar = false

      opts.views.hover.size = {
        width = 60, -- Fixa a largura em um tamanho médio (60 colunas)
        max_height = 12, -- Limita a altura para não cobrir muita tela
      }

      opts.views.hover.border = { style = "rounded" }
      opts.views.hover.position = { row = 2, col = 2 }
    end,
  },

  -- 3. CONFIGURAÇÃO DO LSPCONFIG (Garantia extra para o Hover manual)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Configura o Hover (Shift + K)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        width = 60,
        max_width = 60,
        max_height = 12,
        focusable = false,
      })
      -- Configura Signature Help
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        width = 60,
        max_width = 60,
        max_height = 12,
      })
    end,
  },
}
