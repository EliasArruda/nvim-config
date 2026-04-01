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

  -- Override: bufferline (transparência)
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

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      -- ❌ Desliga animações fora da digitação
      smear_between_buffers = false,
      smear_between_neighbor_lines = false,
      scroll_buffer_space = false,

      legacy_computing_symbols_support = true,

      -- ✅ ESSENCIAL: só no insert
      smear_insert_mode = true,

      -- 🧠 Física: normal mode quase sem efeito
      stiffness = 0.95,
      trailing_stiffness = 0.95,
      damping = 1,

      -- 🔥 Física no INSERT (onde importa)
      stiffness_insert_mode = 0.6,
      trailing_stiffness_insert_mode = 0.6,
      damping_insert_mode = 0.9,

      distance_stop_animating = 0.3,
      time_interval = 5, -- mais responsivo ainda

      cursor_color = "#d3cdc3",

      -- ❌ Remove partículas (melhora input)
      particles_enabled = false,

      hide_target_hack = true,
      never_draw_over_target = true,
    },
  },
}
