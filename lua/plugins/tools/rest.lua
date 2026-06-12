return {
  "mistweaverco/kulala.nvim",
  commit = "b92e6e962fc84a0e6b82d4c8e25c1f460f08289f",
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
