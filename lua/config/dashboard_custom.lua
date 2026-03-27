local has_alpha, alpha = pcall(require, "alpha")
if not has_alpha then
  return
end

local dashboard = require("alpha.themes.dashboard")

-- 🖊️ Header customizado
dashboard.section.header.val = {
  "Bem-vindo ao Neovim!",
  "Aqui é seu LazyVim customizado",
}

-- 🖱️ Botões customizados
dashboard.section.buttons.val = {
  dashboard.button("e", "📄 New file", ":ene <BAR> startinsert<CR>"),
  dashboard.button("r", "🕑 Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("q", "❌ Quit", ":qa<CR>"),
}

-- 🏁 Setup final
alpha.setup(dashboard.config)
