# Runtime audit — 2026-11-03

## Confirmed failures and fixes

- **Paste commands were absent.** Pastify was declared as an Obsidian dependency without setup. Both `Pastify` commands disappeared after lazy loading, so the existing paste shortcuts could fail. The dependency now runs setup. Its Python provider (`pynvim`) was missing; a dedicated `python-provider` environment now supplies pynvim and Pillow without changing project interpreters. Bootstrap provisions the same environment for a new installation.
- **Notification shortcuts depended on a disabled plugin.** A GUI with external message widgets intentionally disables Noice. The Snacks notification shortcuts still executed `:Noice history` / `dismiss`, which can fail in that session. They now use native messages/redraw when Noice is not running. Shortcut keys are unchanged.
- **Diagnostics hid useful context.** `:NvimDoctor` now reports attached UI extensions, Noice state, Python provider, last Vim error, Go tools and log paths.
- **A C++ verification race produced a false failure.** The F5 test could evaluate a stale entry frame while DAP was loading the next stack trace. It now waits for a new frame object after continuing. The production debug configuration was unchanged. Four diagnostic standalone runs and the complete C++ suite subsequently passed.

## Verification

- Loaded all 58 configured plugins in an isolated process. No captured warnings/errors, and mapped Ex commands exist after loading.
- Confirmed executable resolution for the configured language servers and the Go security command.
- Tested Pastify image saving/link insertion and text paste through the real Python provider. Clipboard content was synthetic: OS clipboard capture was deliberately not exercised.
- General configuration suite passed: 163 regression, 19 architecture, 13 diagnostics, 16 icons, 29 terminal checks, real Alt terminal selection, 54 templates in each native/VSCode mode, seven Noice compatibility cases and Go command checks.
- Python suite passed real Pyright/Ruff, virtualenv switching, formatting, F5/debugpy, execution and unittest discovery.
- Rust suite passed Cargo tests, Clippy, rustfmt, rust-analyzer, TOML tooling, F5 breakpoint evaluation and normal run/test commands.
- C++ suite passed clangd, completion/navigation/diagnostics, formatting, templates, native debugging, all F5 launch modes, normal execution and compiler-error handling.
- Blazor local suite passed 41 regression checks and four actual Enter-editing cases.
- Full .NET suite passed solution build/unit test, real Razor LSP and typed Blink tag/attribute completion, formatting, rename, project/new-file loading and managed breakpoint checks. The EasyDotnet plugin printed `dotnet server exited with code 143` during teardown: its `on_exit` reports a SIGTERM shutdown as an error. This upstream teardown notification was retained, not globally filtered; the test artifacts confirm the functional checks passed.
- Installed highlighting queries compiled successfully. Local health checks for Blink, Telescope, Treesitter and Kulala reported no errors. Mason's cached health check reported optional missing Julia/LuaRocks; neither is required by the configured workflows. Its registry refresh was intentionally bypassed in the isolated health run.
- Shell syntax, changed Lua formatting and diff checks passed. Independent review found no actionable production regression. Existing keyboard definitions and user-owned `lazy-lock.json` edits were preserved.

## Limits

These are temporary test projects, not the user's applications. GUI rendering, actual Wayland/X11 clipboard capture, remote/container debugging and every framework-specific workflow were not validated. Historic log entries were preserved; a log line marked ERROR does not by itself establish a current configuration failure.

Run `bin/check-nvim` after plugin updates; it now includes the full lazy-plugin load and paste-runtime checks. Run language-specific checks for toolchain changes. Use `:NvimDoctor`, `:messages`, `:ConformInfo` and the reported log paths when a project-specific problem occurs.
