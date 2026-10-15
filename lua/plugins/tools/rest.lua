return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },

  keys = {
    {
      "<leader>rr",
      function()
        require("kulala").run()
      end,
      desc = "Run HTTP request",
    },
  },

  opts = {
    default_env = "dev",
    halt_on_error = true,

    lsp = {
      formatter = false,
    },

    -- Formata resposta JSON com jq
    contenttypes = {
      ["application/json"] = {
        formatter = { "jq", "." },
      },
    },

    ui = {
      display_mode = "float",
      default_view = "headers_body",
      winbar = true,
      default_winbar_panes = {
        "body",
        "headers",
        "headers_body",
        "verbose",
        "stats",
        "help",
      },
      show_request_summary = true,
    },

    global_keymaps = false,
  },
}
