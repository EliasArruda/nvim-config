<div align="center">

# Neovim Config ⚡

**Configuração pessoal do Neovim — modular, performática e pronta para produção.**

[![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-5.4-blue?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/EliasArruda/nvim-config?style=for-the-badge&logo=github)](https://github.com/EliasArruda/nvim-config/stargazers)

![Status](https://img.shields.io/badge/Status-Ativo-brightgreen?style=flat-square)
![Plugins](https://img.shields.io/badge/Plugins-40+-9465F2?style=flat-square)
![Startup](https://img.shields.io/badge/Startup-~40ms-00B4D8?style=flat-square)

</div>

---

## Por que essa configuração?

Esta não é mais uma configuração genérica de Neovim. Ela foi construída com **arquitetura modular** que se adapta automaticamente à GUI utilizada, carregando apenas o necessário — o que significa **menos overhead e mais velocidade**.

| Princípio | Descrição |
|-----------|-----------|
| **Modularidade** | Cada funcionalidade vive em seu próprio módulo. Fácil de entender, fácil de remover. |
| **Performance** | Lazy-loading agressivo com Lazy.nvim. Plugins só carregam quando precisam. |
| **Adaptabilidade** | Detecta Neovide, Goneovim ou Terminal e ajusta a experiência automaticamente. |

---

## 🚀 Instalação

### Pré-requisitos

| Dependência | Versão mínima | Verificação |
|-------------|:-------------:|-------------|
| [Neovim](https://neovim.io/) | `0.12+` | `nvim --version` |
| [Git](https://git-scm.com/) | `2.30+` | `git --version` |
| [Node.js](https://nodejs.org/) | `18+` | `node --version` |
| [Ripgrep](https://github.com/BurntSushi/ripgrep) | qualquer | `rg --version` |
| [Lazygit](https://github.com/jesseduffield/lazygit) | qualquer | `lazygit --version` |

### Passo a passo

```shell
mv ~/.config/nvim ~/.config/nvim.bak # Backup
git clone https://github.com/EliasArruda/nvim-config.git ~/.config/nvim
nvim
```

> O **Lazy.nvim** instalará automaticamente todos os plugins na primeira execução. Aguarde a conclusão e reinicie o Neovim.

---

## 📂 Estrutura

```txt
nvim/
├── init.lua                    # Ponto de entrada
├── lua/
│   ├── config/
│   │   ├── options.lua         # Opções globais (vim.opt)
│   │   ├── keymaps.lua         # Atalhos personalizados
│   │   ├── autocmds.lua        # Autocomandos
│   │   ├── neovide.lua         # Configurações específicas do Neovide
│   │   ├── goneovim.lua        # Configurações específicas do Goneovim
│   │   ├── dap.lua             # Debug Adapter Protocol
│   │   └── terminal.lua        # Terminal integrado
│   └── plugins/
│       ├── core/               # LSP, Mason, Treesitter
│       │   ├── lsp.lua
│       │   ├── mason.lua
│       │   └── treesitter.lua
│       ├── editor/             # Produtividade e edição
│       │   ├── telescope.lua
│       │   ├── copilot.lua
│       │   └── surround.lua
│       ├── lang/               # Suporte por linguagem
│       │   ├── python.lua
│       │   ├── typescript.lua
│       │   └── rust.lua
│       ├── tools/              # Integrações externas
│       │   ├── obsidian.lua
│       │   ├── code-runner.lua
│       │   └── git.lua
│       └── ui/                 # Interface visual
│           ├── lualine.lua
│           ├── bufferline.lua
│           ├── neoscroll.lua
│           └── indent-blankline.lua
```

---

## 🧩 Plugins

### Interface & UI

| Plugin | Função |
|--------|--------|
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Barra de status informativa e customizável |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Abas de buffers estilo editor moderno |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Guias de indentação visuais |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | Rolagem suave com easing |
| [noice.nvim](https://github.com/folke/noice.nvim) | Interface de mensagens redesenhada |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Menu de atalhos em tempo real |

### LSP & Desenvolvimento

| Plugin | Função |
|--------|--------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Configuração nativa de Language Servers |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Instalador de LSPs, DAPs, linters e formatters |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting e parsing avançado |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletar com múltiplas fontes |

### Ferramentas & Produtividade

| Plugin | Função |
|--------|--------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder universal |
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Integração com Obsidian vault |
| [code-runner.nvim](https://github.com/CRAG666/code_runner.nvim) | Execução rápida de código |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Indicadores de Git no gutter |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Interface Git completa dentro do Neovim |

### Específicos de GUI

| Plugin | Requer | Função |
|--------|--------|--------|
| [hererocks](https://github.com/luarocks/hererocks) | Neovide/Goneovim | Ambiente Lua isolado |
| [luarocks.nvim](https://github.com/vhyrro/luarocks.nvim) | Neovide/Goneovim | Gerenciador de pacotes Lua |
| [image.nvim](https://github.com/3rd/image.nvim) | Neovide/Goneovim | Renderização de imagens inline |
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | Neovide/Goneovim | Efeito de cursor animado |

---

## ⌨️ Atalhos Principais

> O prefixo padrão é `<Space>`. Use `which-key` para descobrir todos os atalhos disponíveis.

| Atalho | Ação |
|--------|------|
| `<Space>ff` | Buscar arquivos (Telescope) |
| `<Space>fg` | Buscar texto no projeto (Live Grep) |
| `<Space>fb` | Listar buffers abertos |
| `<Space>e` | Abrir explorador de arquivos |
| `<Space>la` | Code Actions |
| `<Space>lr` | Rename (LSP) |
| `<Space>ld` | Diagnósticos (LSP) |
| `<Space>gg` | Abrir Lazygit |
| `<Space>rr` | Executar código atual |

---

## 🎨 Temas & Customização

A configuração vem com temas e transparência totalmente configuráveis:

```lua
-- lua/config/options.lua
vim.opt.termguicolors = true   -- Cores true color
vim.opt.winblend = 10          -- Transparência de janelas
vim.opt.pumblend = 10          -- Transparência do popup menu
```

Para trocar de tema, edite `lua/plugins/ui/theme.lua` e altere a importação do plugin desejado.

---

## 🖥️ Suporte a GUIs

A configuração detecta automaticamente a GUI em uso:

```lua
-- Carregamento condicional
if vim.g.neovide then
  require("config.neovide")
elseif vim.g.goneovim then
  require("config.goneovim")
end
```

---
