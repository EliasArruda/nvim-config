<div align="center">
  <h1>Neovim</h1>
  <p><strong>Your project. Your shortcuts. Fewer distractions.</strong></p>
  <p>A personal configuration for C#, Blazor, and web development.<br />A dark workspace, Cyberdream syntax colors, and Symbols icons in Neovide.</p>
  <p>
    <img src="https://img.shields.io/badge/Neovim-0.12%2B-5eff6c" alt="Neovim 0.12 or newer" />
    <img src="https://img.shields.io/badge/config-Lua-5ea1ff" alt="Lua configuration" />
    <img src="https://img.shields.io/badge/tested-Linux-ffbd5e" alt="Tested on Linux" />
  </p>
  <p><a href="#what-you-get">Features</a> · <a href="#getting-started">Installation</a> · <a href="#new-file-templates">Templates</a> · <a href="#good-to-know">Good to know</a></p>
</div>

## What you get

- **C# and Blazor in one workflow.** Roslyn and Razor through EasyDotnet, component and attribute completion, Emmet, formatting, tests, and C# debugging.
- **C++ with project-aware tooling.** Clangd completion, diagnostics, navigation, refactoring and inlay hints; clang-format, Treesitter highlighting, and CodeLLDB debugging. See the [C++ guide](docs/cpp.md).
- **A starting point for new files.** Automatic templates for C/C++, C#, Vue, Go, and Razor components, including files created on disk by the explorer before opening.
- **Search within your project.** Search and tools resolve the nearest project or package root.
- **More color in your code.** Cyberdream syntax colors over a neutral, dark Nightfly interface. Tabs, menus, and panels keep a consistent appearance.
- **Symbols icons.** 348 designs and 1,479 file and folder associations, with a color companion font in Neovide and a Nerd Font fallback in terminals.
- **Multiple shells, one panel.** A session list on the right, Alt+1…9 switching, and processes that stay alive when hidden. `exit` closes only the current session.
- **Explicit installation.** Plugins are pinned in the lockfile; tools, parsers, and updates are managed manually.

## Getting started

Requirements: Neovim **0.12+**, Git, `ripgrep`, `fd`, Node.js/npm, a C compiler, make, and a tree-sitter CLI compatible with nvim-treesitter. Use a Nerd Font. Neovide is optional.

1. Close the editor and place this repository at `~/.config/nvim`. If that directory already exists, move your current configuration somewhere you choose before cloning.

   ```bash
   git clone https://github.com/EliasArruda/nvim-config.git ~/.config/nvim
   cd ~/.config/nvim
   ./bin/bootstrap-nvim
   ```

2. Open `nvim` and run `:NvimToolsInstall` and `:NvimParsersInstall`. Normal startup does not download plugins or tools.
3. Install the SDKs for the languages you use. For C#/Blazor, see the [dependency guide](docs/usage.md#dependências); the .NET SDK and EasyDotnet CLI are installed separately from Mason.
4. For color icons in Neovide, run `./bin/install-symbols-font` and restart Neovide. See the [Symbols font requirements](docs/symbols.md).
5. Open the editor in your project directory. Use `:NvimDoctor` to check the root, tools, and language servers.

## New file templates

Create and open a file through the explorer, or use `:edit path/File.cs`. The template appears in the buffer and is written to disk only when you save.

| File | Initial content |
| --- | --- |
| `main.cpp`, `main.cc`, `main.c` | A console entry point with the appropriate standard include |
| Other C/C++ sources | Matching header include when it exists; otherwise a standard include, without another `main` |
| `.h`, `.hpp`, `.hh`, `.hxx`, `.H` | `#pragma once` and an empty editing area |
| `Customer.cs`, `IService.cs` | A class or interface with a namespace derived from the `.csproj` and directory structure |
| `OrderDto.cs`, `OrdersController.cs`, `OrderStatus.cs` | A record, controller, or enum based on the filename |
| `Counter.razor.cs` | A partial class for the component's code-behind |
| `Card.vue` | A `<template>` block ready to edit |
| `main.go`, other `.go` files | A package declaration, reusing the package from neighboring files |
| `Card.razor` | A component heading and an `@code` block |

Files with content and older empty files are left untouched. Empty files already created on disk are eligible for **10 seconds** after modification. `_Imports.razor` and other `.razor` files starting with `_` stay empty. Razor component templates do not add routes automatically. Automatic file templates currently cover C/C++, C#, Vue, Go, and Razor; language-server support for another language does not imply an automatic file template.

## Essential shortcuts

The leader key is **Space**. Press it and wait to browse which-key.

| Shortcut | Action |
| --- | --- |
| `<Space>ff` / `<Space>fg` / `<Space>sg` | Files / Git files / text search |
| `gd` / `K` | Definition / documentation |
| `<Space>ca` / `<Space>cr` / `<Space>cf` | Code actions / rename / format |
| `<Space>nn` / `<Space>nf` | Create a .NET project / .NET file |
| `<Space>nb` / `<Space>nr` / `<Space>nt` | Build / run / .NET tests |
| `Ctrl+T` | Show or hide terminals |
| `Ctrl+N` in a terminal | Create another session |
| `Alt+1`…`Alt+9` in the panel | Select a session |
| `<Space>qq` | Quit |

[Full guide](docs/usage.md) · [Terminal panel](docs/terminal-sessions.md)

## Good to know

This is a personal configuration tested on Linux. Neovide and the VSCode Neovim extension have their own settings. SDKs, external tools, and fonts are not covered by the Lazy lockfile.

In Razor, wait for the solution to load for full completion. Emmet works independently of Roslyn: `span` can expand to `<span></span>`, and Enter between the tags creates an indented inner line. New files attach to the language server after saving. The Razor grammar still has known limitations; see [architecture](docs/architecture.md).

Use `:Lazy restore` to restore pinned commits, `:ConformInfo` to inspect formatters, and `:NvimDoctor` for diagnostics. Installation, validation, and maintenance details are documented separately in Portuguese:

- [Dependencies and language workflows](docs/usage.md)
- [Architecture and decisions](docs/architecture.md)
- [Updates and Blazor diagnostics](docs/updates-and-blazor.md)
- [Symbols icons and font](docs/symbols.md)

## Verification

```bash
./bin/check-nvim
./bin/check-blazor
./bin/check-dotnet
./bin/check-cpp
```

`check-nvim` covers configuration, templates, diagnostics, icons, and terminals using installed plugins. `check-blazor` checks Razor and Emmet locally. `check-dotnet` creates a temporary .NET 10 solution and checks builds, tests, and LSP/debugger integration; it requires the SDK, tools, and NuGet access. See the [verification guide](docs/usage.md#verificação).

[Latest verification results and limitations](docs/validation.md).
