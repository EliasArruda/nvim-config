return {
  {
    "NvChad/nvim-colorizer.lua", -- Recomendo este fork para suporte real a Tailwind
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          tailwind = true, -- Agora dentro de user_default_options
        },
      })
    end,
  },
}
