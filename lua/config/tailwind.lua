require("lspconfig").tailwindcss.setup({
  filetypes = {
    "html",
    "css",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "razor",
    "cshtml",
  },
  -- ISSO É CRUCIAL PARA O RAZOR:
  init_options = {
    userLanguages = {
      razor = "html",
      cshtml = "html",
    },
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        razor = "html",
        cshtml = "html",
      },
      experimental = {
        classRegex = {
          -- NOTA: O padrão `class="..."` já é reconhecido nativamente
          -- porque mapeamos razor para html. Adicionar regex para isso
          -- às vezes buga o parser padrão do Tailwind.
          -- Deixe apenas os seus customizados (CVA, cn, etc):
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },

          -- Se você usa uma função C# específica no Razor, tipo @Css.Class("..."):
          -- '@Css\\.Class\\("([^"]*)"\\)',
        },
      },
    },
  },
})
