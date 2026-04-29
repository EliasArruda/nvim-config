return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },

  opts = {
    move = {
      enable = true,
      set_jumps = true, -- define saltos na jumplist
      -- Mapeamentos de teclas para navegação
      keys = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
    },
  },

  config = function(_, opts)
    local TS = require("nvim-treesitter-textobjects")
    
    -- Setup inicial do plugin
    TS.setup(opts)

    -- Função para aplicar os keymaps ao buffer
    local function attach(buf)
      -- Verifica se o 'move' está habilitado nas opções
      if not (opts.move and opts.move.enable) then
        return
      end

      local moves = opts.move.keys or {}

      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          -- Lógica para criar a descrição legível (ex: "@function.outer" -> "Function")
          local queries = type(query) == "table" and query or { query }
          local parts = {}
          for _, q in ipairs(queries) do
            local part = q:gsub("@", ""):gsub("%..*", "")
            part = part:sub(1, 1):upper() .. part:sub(2)
            table.insert(parts, part)
          end
          
          local desc = table.concat(parts, " or ")
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")

          -- Define o atalho de teclado
          vim.keymap.set({ "n", "x", "o" }, key, function()
            -- Se estiver em modo diff e for um salto de classe, mantém o comportamento original do vim
            if vim.wo.diff and key:find("[cC]") then
              return vim.cmd("normal! " .. key)
            end
            require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
          end, {
            buffer = buf,
            desc = desc,
            silent = true,
          })
        end
      end
    end

    -- Cria o autocmd para anexar os atalhos sempre que um arquivo for aberto
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("custom_ts_textobjects", { clear = true }),
      callback = function(ev)
        attach(ev.buf)
      end,
    })

    -- Aplica aos buffers que já estão abertos no momento do carregamento
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        attach(buf)
      end
    end
  end,
}
