local lspconfig = require("lspconfig")

lspconfig.emmet_language_server.setup({
  filetypes = { "html", "razor", "cshtml", "css", "javascript", "javascriptreact", "scss", "typescriptreact" },
  init_options = {
    -- ADICIONE O CSHTML NA LINHA ABAIXO
    includeLanguages = { razor = "html", cshtml = "html" },
    showAbbreviationSuggestions = true,
    showExpandedAbbreviation = "always",
    showSuggestionsAsSnippets = true, -- Lembre-se de manter isso como true!
  },
})
