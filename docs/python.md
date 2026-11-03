# Python

Python uses Pyright for completion, navigation, hover and basic type checking, with Ruff's native language server for lint and code actions. Conform organizes imports and formats with Ruff on save. Ruff discovers project `pyproject.toml`, `ruff.toml` and `.ruff.toml`; Pyright reads `pyrightconfig.json` or its section in `pyproject.toml`. No strict type-checking or preview lint rules are imposed globally.

## Environments

Create a project environment with `python3 -m venv .venv`, or use your existing uv/Poetry environment. The configuration resolves project `.venv`, `venv` or `env`, then an inherited `VIRTUAL_ENV`/`CONDA_PREFIX`, then `python3`. Pyright, normal execution and debugging share this interpreter. Use the existing `,v` shortcut (`:VenvSelect`) for an external environment; the selector restarts the project's language server with that interpreter and caches the selection.

Install your project's dependencies in its environment, not in Neovim's Mason environment. Mason supplies Pyright, Ruff and debugpy; debugpy's separate adapter can debug your project interpreter without installing debugpy into every project.

## Commands

| Action | Command |
| --- | --- |
| Debug the current file, pause on entry | `F5` |
| Continue, step, breakpoints, watches | Existing DAP shortcuts |
| Run the current file with input/output | `:PythonRun` |
| Discover standard-library unit tests | `:PythonTest` or `:PythonTest unittest` |
| Run pytest (install it in the project environment first) | `:PythonTest pytest` |
| Debug a module such as pytest | `:DapContinue`, choose **Python: module** when no session is active |
| Choose environment | `,v` / `:VenvSelect` |
| Inspect formatter / configuration | `:ConformInfo` / `:NvimDoctor` |

Run, test and F5 save the current Python file first. Other unsaved buffers are not written automatically. Run and test use a persistent bottom terminal and do not start a debugger. Module debugging uses the project root as the working directory; application-specific arguments still require a DAP configuration. F5 deliberately selects the current-file configuration.

## Templates

New `main.py` and `__main__.py` files receive a guarded `main()` entry point. Other modules receive a docstring. `__init__.py` remains empty. Existing content and older empty files are preserved. Templates work in native Neovim and VSCode-Neovim.

## Validation and scope

Run `bin/check-python` with installed plugins/tools. It creates disposable virtual environments and checks real Pyright/Ruff attachment, type diagnostics, completion, formatting, interpreter selection, F5/debugpy breakpoint evaluation, execution and unittest discovery. By default it does not install project dependencies. `PYTHON_CHECK_PYTEST=1 bin/check-python` additionally installs pytest only in the disposable environment and verifies the pytest command; this optional mode requires package-index access.

This is native Linux Python support. Jupyter notebooks, remote/container debugging, Windows interpreter paths, framework-specific launch arguments and GUI rendering require separate project validation.

## References

- [Ruff editor setup](https://docs.astral.sh/ruff/editors/setup/)
- [Ruff settings](https://docs.astral.sh/ruff/editors/settings/)
- [Pyright settings](https://github.com/microsoft/pyright/blob/main/docs/settings.md)
- [debugpy launch settings](https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings)
- [Venv Selector](https://github.com/linux-cultist/venv-selector.nvim)
