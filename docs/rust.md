# Rust

Rust uses rustaceanvim with a single rust-analyzer client, Blink completion, native diagnostics/inlay hints, rustfmt through the language server, Treesitter and CodeLLDB. Cargo supplies package/workspace metadata. No extra Rust language server is enabled through lspconfig.

## Requirements

Install rustup and the components for each toolchain your projects use:

```bash
rustup component add rust-analyzer rust-src rustfmt clippy
```

CodeLLDB and Taplo are declared in Mason (`:NvimToolsInstall`). Rust and TOML parsers are declared for `:NvimParsersInstall`. This machine already has the Rust components and parser; Taplo was installed for the Cargo manifest integration.

The analyzer wrapper runs in the detected project root, so rustup selects the project's toolchain rather than the directory where Neovim was originally launched. Project `rust-toolchain.toml` overrides are respected; the required toolchain and components must be installed. This configuration does not upgrade your Rust toolchains.

## Editing and formatting

Open a Rust source inside a Cargo package or workspace. Wait for rust-analyzer to finish loading before running Cargo targets from the editor.

- Blink provides completion; `gd`, `gr`, `K`, `<Space>ca` and `<Space>cr` retain their navigation, documentation, code-action and rename behavior.
- `<Space>cf` and formatting on save use rust-analyzer's rustfmt integration, respecting the project edition and rustfmt configuration. There is no second formatter racing against it.
- Clippy runs on save with `--no-deps`. Cargo default features are respected; the editor no longer forces all optional features on at once. Project rust-analyzer settings can enable specific features when needed.
- Proc macros and native inlay hints are enabled. Standard-library source is available through rust-src.
- Taplo provides the TOML language server and formatter for `Cargo.toml` and other TOML files.

## Run, test and debug

| Action | Command or key |
| --- | --- |
| Run a Cargo target normally | `:CargoRun` |
| Run a Cargo test target | `:CargoTest` |
| Build and debug a Cargo executable/test | `F5` |
| Toggle a source breakpoint | `<Space>db` |
| Continue an active debug session | `F5` |
| Step over / into / out | `F10` / `F11` / `F12` |
| Stop debugging | `Ctrl+F5` |
| Toggle debug panels | `<Space>du` |

CargoRun and CargoTest save the current buffer and use rust-analyzer's runnable targets and a persistent bottom terminal, without a debugger. Multiple Cargo targets are selected through the existing picker. Normal input/output remain in the terminal after completion.

F5 uses rustaceanvim's Cargo build/debug integration and CodeLLDB, rather than guessing a binary path. An executable with a Rust main function pauses there via a temporary breakpoint; source breakpoints allow inspection of initialized variables. Debugging unit tests uses the test harness and source breakpoints. Existing debug sessions keep normal F5 continue behavior. The debugger includes Rust type visualizers and standard-library source mapping through rustaceanvim.

Additional operations remain available through `:RustLsp`, including hover actions, macro expansion, related tests, rebuild proc macros and workspace reloads. See `:help rustaceanvim` for the installed version's commands.

Cargo targets are built for debugging when you request it; opening a Rust file does not eagerly build every debug target. The new Cargo commands are separate from Neovim's native buffer-local `RustRun` and `RustTest`, which remain available. Save edits in other buffers before running, testing or debugging.

## New files

Native Neovim and VSCode Neovim templates cover `.rs`: `main.rs` gets a main function with a greeting, `lib.rs` gets crate documentation, and other module files get module documentation. Templates never overwrite existing Cargo-generated content or older empty files. Newly created empty files on disk use the existing ten-second eligibility window.

For standalone Rust files outside a Cargo project, Neovim's native `:RustRun` remains available. The F5 workflow configured here targets Cargo executables and tests.

## Verification

```bash
./bin/check-rust
./bin/check-nvim
```

The Rust script creates a dependency-free temporary Cargo project, runs offline unit tests, Clippy and rustfmt checks, and checks analyzer attachment, completion, definition, editor formatting, native debugging, Cargo manifest tooling and normal run/test terminals. It retains artifacts in the printed temporary directory. Validation targets native Linux; cross-compilation and remote debugging require project-specific configuration.
