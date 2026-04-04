return {
  {
    "karb94/neoscroll.nvim",
    opts = {
      duration_multiplier = 0.6,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local bg = "NONE"
      opts.options.theme = {
        normal = {
          a = { bg = "#1a1a1a", fg = "#ffffff", gui = "bold" },
          b = { bg = bg, fg = "#aaaaaa" },
          c = { bg = bg, fg = "#888888" },
        },
        insert = {
          a = { bg = "#2d4a22", fg = "#ffffff", gui = "bold" },
          b = { bg = bg, fg = "#aaaaaa" },
          c = { bg = bg, fg = "#888888" },
        },
        visual = {
          a = { bg = "#4a2d4a", fg = "#ffffff", gui = "bold" },
          b = { bg = bg, fg = "#aaaaaa" },
          c = { bg = bg, fg = "#888888" },
        },
        replace = {
          a = { bg = "#4a2d2d", fg = "#ffffff", gui = "bold" },
          b = { bg = bg, fg = "#aaaaaa" },
          c = { bg = bg, fg = "#888888" },
        },
        inactive = {
          a = { bg = bg, fg = "#666666" },
          b = { bg = bg, fg = "#666666" },
          c = { bg = bg, fg = "#666666" },
        },
      }
      return opts
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.highlights = opts.highlights or {}
      opts.highlights.fill = { bg = "NONE" }
      opts.highlights.background = { bg = "NONE" }
      opts.highlights.buffer_selected = { bg = "NONE", fg = "#FFA500", sp = "#ff5555", bold = true }
      opts.highlights.buffer_visible = { bg = "NONE" }
      return opts
    end,
  },

  -- Override: which-key
  {
    "folke/which-key.nvim",
    opts = {
      win = {
        border = "rounded",
        wo = {
          winblend = 10,
        },
      },
    },
  },
}
