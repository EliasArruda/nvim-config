return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local bg = "#0a0a0a"

    opts.options.theme = {
      normal = {
        a = { bg = bg, fg = "#ffffff" },
        b = { bg = bg, fg = "#aaaaaa" },
        c = { bg = bg, fg = "#888888" },
      },
      insert = {
        a = { bg = bg, fg = "#ffffff" },
        b = { bg = bg, fg = "#aaaaaa" },
        c = { bg = bg, fg = "#888888" },
      },
      visual = {
        a = { bg = bg, fg = "#ffffff" },
        b = { bg = bg, fg = "#aaaaaa" },
        c = { bg = bg, fg = "#888888" },
      },
      replace = {
        a = { bg = bg, fg = "#ffffff" },
      },
      inactive = {
        a = { bg = bg, fg = "#666666" },
        b = { bg = bg, fg = "#666666" },
        c = { bg = bg, fg = "#666666" },
      },
    }

    return opts
  end,
}
