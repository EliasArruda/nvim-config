return {
  "mason-org/mason.nvim",
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ensure_installed = {
      "lua-language-server",
      "xmlformatter",
      "prettier",
      "stylua",
      "bicep-lsp",
      "html-lsp",
      "css-lsp",
      "eslint-lsp",
      "typescript-language-server",
      "json-lsp",
      "rust-analyzer",
      "roslyn",
      "netcoredbg",
      "emmet-language-server",
      "tailwindcss-language-server",
      "ruff",
      "pyright",
      "vue-language-server",
    },
  },
}
