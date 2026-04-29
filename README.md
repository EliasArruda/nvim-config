# 🌙 Neovim Configuration

A professional, modular, and highly optimized Neovim configuration designed for modern software engineering. This setup balances a minimal aesthetic with powerful functionality, providing a seamless experience across different environments including Neovide and VSCode Neovim.

## ✨ Key Features

- **🚀 Performance:** Powered by `lazy.nvim` for fast startup and efficient plugin management.
- **🧠 Intelligent Completion:** Utilizing `blink-cmp` for blazing fast, asynchronous completions.
- **🛠️ LSP & Diagnostics:** Full LSP integration via `mason.nvim` and `nvim-lspconfig`.
- **🎨 Modern UI:** 
  - `noice.nvim` for a revamped command line and notifications.
  - `lualine.nvim` for a clean, informative status line.
  - `snacks.nvim` for a suite of high-performance utilities.
  - Custom `midnight` theme for reduced eye strain.
- **🔍 Navigation & Search:** `telescope.nvim` for fuzzy finding and `flash.nvim` for lightning-fast motion.
- **📝 Formatting & Linting:** `conform.nvim` for consistent code styling.
- **🔌 Versatility:** 
  - **Neovide:** Dedicated optimizations for the GPU-accelerated GUI.
  - **VSCode Neovim:** A specialized configuration layer for the VSCode Neovim extension.
  - **Obsidian:** Integrated support for Zettelkasten and knowledge management.

## 🌐 First-Class Language Support

This configuration is specifically tuned for the following ecosystems:

| Language | Plugin/Tooling | Key Capabilities |
| :--- | :--- | :--- |
| **Rust** | `rust-analyzer` / `rust-lang` | Full IDE features, Cargo integration, and refined diagnostics. |
| **C#** | `roslyn.nvim` | High-performance .NET development with official Roslyn support. |
| **Go** | `go-nvim` | Optimized Go tooling with seamless Gopls integration. |
| **Vue/TS** | `volar` / `tsserver` | Advanced TypeScript and Vue.js support for modern web dev. |

## 🛠️ Installation

### Prerequisites

Ensure you have the following installed:
- **Neovim 0.10+**
- **Ripgrep** (required for Telescope)
- **FD** (required for Telescope)
- **Nerd Fonts** (recommended for icons, e.g., JetBrainsMono Nerd Font)

### Setup

1. **Backup your current config:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/EliasArruda/nvim-config.git ~/.config/nvim
   ```

3. **Launch Neovim:**
   ```bash
   nvim
   ```
   *Lazy.nvim will automatically install all plugins on the first run.*

## ⌨️ Keybindings

**Leader key:** `<Space>`

### 🔍 Navigation & Search
| Key | Action |
| :--- | :--- |
| `<Space>ff` | Find Files (Telescope) |
| `<Space>fg` | Live Grep (Telescope) |
| `<Space>fb` | Find Buffers |
| `<Space>e` | File Explorer |
| `gd` | Go to Definition |
| `gr` | Go to References |
| `K` | Hover Documentation |

### 📝 Editing & Code
| Key | Action |
| :--- | :--- |
| `<Space>ca` | Code Actions |
| `<Space>rn` | Rename Symbol |
| `<Space>f` | Format Document (Conform) |
| `[d` / `]d` | Previous/Next Diagnostic |

### 🛠️ System & UI
| Key | Action |
| :--- | :--- |
| `<Space>l` | Lazy Plugin Manager |
| `<Space>m` | Mason Package Manager |
| `<Space>q` | Quit Neovim |

## 📂 Configuration Structure

The configuration is split into logical modules for maximum maintainability:

```text
nvim/
├── init.lua               # Entry point
└── lua/
    ├── core/              # Global options, keymaps, and autocmds
    ├── configs/           # Plugin-specific configurations and language settings
    ├── plugins/           # Plugin specifications (divided by category)
    │   ├── core/          # Essential plugins (LSP, Treesitter)
    │   ├── editor/        # Editing enhancements (Cmp, Flash, Autopairs)
    │   ├── lang/          # Language-specific plugin setups
    │   ├── ui/            # Visual enhancements and themes
    │   └── tools/         # External tool integrations (Obsidian, Kulala)
    └── vscode-nvim-config/ # Specialized config for VSCode Neovim extension
```

## ⚙️ Customization

To personalize this configuration without breaking the ability to pull updates:
1. Copy `lua/core/options.lua` or `lua/core/keymaps.lua` to a local file.
2. Add your custom logic to `lua/core/init.lua`.
3. For language-specific tweaks, explore the `lua/configs/langs/` directory.
