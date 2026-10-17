# C and C++

C++ uses the existing LSP, Blink completion, Conform formatting, Treesitter highlighting, and DAP interface. No shortcuts are replaced. C uses the same clangd, formatter, and debugger integration.

## Tools

Install a compiler (`clang++` or `g++`), CMake and Ninja for the workflow below. `clangd` and `clang-format` must be available on PATH; both are declared in Mason for reproducible installation with `:NvimToolsInstall`. CodeLLDB is also declared in Mason. Run `:NvimParsersInstall` to install the C/C++ parsers on another machine.

On this machine, clangd and clang-format were already installed. The C++ parser was installed as part of this setup. Compiler and build tools are external system dependencies; Mason does not install them.

## Configure a project

For CMake projects, configure a debug build and generate the compilation database:

```bash
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
```

Clangd normally discovers a compilation database in the project root or the `build` subdirectory. For another build directory, tell clangd where to find it using a project `.clangd`:

```yaml
CompileFlags:
  CompilationDatabase: build-debug
```

Alternatively, expose the database in the project root with a symlink to the generated file. Do not overwrite a database that your project already maintains. CMake's compilation database export supports Makefile and Ninja generators.

Set the language standard, include paths and macros in your build system, rather than hardcoding global editor flags. For example:

```cmake
target_compile_features(my_app PRIVATE cxx_std_20)
target_include_directories(my_app PRIVATE include)
```

Clangd reads the resulting flags, including per-file differences. Standalone files work with its fallback flags, but do not describe complex dependencies. For small projects without a build system, a `compile_flags.txt` can specify one compiler flag per line. See [clangd project setup](https://clangd.llvm.org/installation#project-setup).

Project roots recognize CMake, compilation databases, `.clangd`, Makefiles and Meson projects. The editor does not automatically configure or build your project, and does not run project executables on startup.

## Editing

Open `nvim` in the project and edit a `.cpp`, `.cc`, `.cxx`, `.hpp` or `.h` file. Headers retain Neovim's normal filetype detection; clangd uses compilation commands to interpret them.

- Completion uses Blink with clangd snippets and member information.
- `gd`, `gD`, `gr`, `gI`, `gy` and `K` keep their existing navigation/documentation actions.
- `<Space>ca` opens code actions; `<Space>cr` renames symbols.
- `<Space>cf` formats with clang-format, respecting the nearest `.clang-format`. Formatting on save follows the existing autoformat setting; `<Space>uf` toggles it.
- Native diagnostics and semantic highlighting use the existing UI. Inlay hints are enabled where the server supports them.
- Background indexing and clang-tidy diagnostics are enabled. Project `.clangd`, `.clang-tidy` and `.clang-format` settings remain authoritative.
- `:LspClangdSwitchSourceHeader` switches between implementation and header. `:LspClangdShowSymbolInfo` shows symbol details.

If headers or libraries appear missing, check `compile_commands.json` and the compiler command it contains. A language server cannot supply an SDK or library missing from the build environment. No wildcard compiler-execution permissions (`--query-driver`) are enabled globally.

## New file templates

New C/C++ files receive templates in native Neovim and the VSCode Neovim integration. `main.cpp`, `main.cc`, `main.cxx`, `main.C` and `main.c` get a console entry point. Headers (`.h`, `.hpp`, `.hh`, `.hxx`, `.H`) start with `#pragma once`. Other source files include their matching header from the same directory when it exists; otherwise they start with a standard include. They do not define another `main`.

Templates apply to new empty buffers and empty files modified within the last ten seconds, covering immediate creation/opening by the explorer. Existing content and older empty files are preserved. Generated content is not saved automatically. Other languages with configured automatic templates are C#, Vue, Go, and Razor; these are tested separately from the language servers.

## Debugging

Build with debug symbols, then set a breakpoint with `<Space>db` and press `F5`. Select **Launch executable (C/C++)** and enter the compiled executable path. The working directory defaults to the current project root. This launches the existing binary; rebuild after changing source files.

Use `F10`, `F11`, `F12` to step and `Ctrl+F5` to stop. The existing DAP UI supports variables, watches and evaluation. **Attach to process (C/C++)** uses the process picker; attaching may require additional OS permissions.

## Diagnostics and verification

Use `:NvimDoctor`, `:LspInfo`, `:LspLog` and `:ConformInfo` to inspect tool discovery, clangd attachment and formatter selection.

```bash
./bin/check-cpp
```

This creates a temporary CMake C++20 project, builds and runs it, then verifies clangd attachment/root, parsing, hover, header definition, STL completion, an intentional diagnostic, rename, buffer formatting, and a CodeLLDB breakpoint/evaluation. Artifacts are kept at the printed temporary path for diagnosis. Requires the compiler, CMake, Ninja, clangd, clang-format, C++ parser and CodeLLDB. The test uses a native Linux executable; cross-compilation and remote debugging are not covered.
