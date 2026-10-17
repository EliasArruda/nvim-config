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

Project roots recognize CMake, compilation databases, `.clangd`, Makefiles and Meson projects. The editor does not build or run project executables on startup. F5 explicitly triggers the build-and-debug workflow described below.

## Editing

Open `nvim` in the project and edit a `.cpp`, `.cc`, `.cxx`, `.hpp` or `.h` file. Headers retain Neovim's normal filetype detection; clangd uses compilation commands to interpret them.

- Completion uses Blink with clangd snippets and member information.
- `gd`, `gD`, `gr`, `gI`, `gy` and `K` keep their existing navigation/documentation actions.
- `<Space>ca` opens code actions; `<Space>cr` renames symbols.
- `<Space>cf` formats with clang-format, respecting the nearest `.clang-format`. Short functions and blocks always expand over multiple lines, overriding those two project style options while inheriting the remaining settings. Formatting on save follows the existing autoformat setting; `<Space>uf` toggles it.
- Native diagnostics and semantic highlighting use the existing UI. Inlay hints are enabled where the server supports them.
- Background indexing and clang-tidy diagnostics are enabled. Project `.clangd`, `.clang-tidy` and `.clang-format` settings remain authoritative.
- `:LspClangdSwitchSourceHeader` switches between implementation and header. `:LspClangdShowSymbolInfo` shows symbol details.

If headers or libraries appear missing, check `compile_commands.json` and the compiler command it contains. A language server cannot supply an SDK or library missing from the build environment. No wildcard compiler-execution permissions (`--query-driver`) are enabled globally.

## New file templates

New C/C++ files receive templates in native Neovim and the VSCode Neovim integration. `main.cpp`, `main.cc`, `main.cxx`, `main.C` and `main.c` get a console entry point. Headers (`.h`, `.hpp`, `.hh`, `.hxx`, `.H`) start with `#pragma once`. Other source files include their matching header from the same directory when it exists; otherwise they start with a standard include. They do not define another `main`.

Templates apply to new empty buffers and empty files modified within the last ten seconds, covering immediate creation/opening by the explorer. Existing content and older empty files are preserved. Generated content is not saved automatically. Other languages with configured automatic templates are C#, Vue, Go, and Razor; these are tested separately from the language servers.

## Debugging

Press **F5** in a C/C++ buffer to save the current file, build and launch the debugger. Set a breakpoint with `<Space>db` first if you want execution to pause. F5 continues execution when a debug session is already active.

- **CMake project:** configure `build/` in Debug mode, discover executable targets through CMake's file API, and build the chosen target. A single executable launches directly; projects with several executable targets show a target picker. Existing CMake cache/toolchain settings remain, but `CMAKE_BUILD_TYPE` is set to Debug. Multi-config generators build their Debug configuration.
- **Standalone source:** compile the current `.c` or C++ source with `cc`/`c++`, `-g` and `-O0`, placing the binary in Neovim's cache. This is for a self-contained source file; multi-file projects or custom include/link flags should use CMake or the manual configuration.
- **Build failure:** show compiler output in quickfix, preserve the full output in `:lua print(vim.fn.stdpath("state") .. "/cpp-build.log")`, and abort the debugger launch. No old binary is launched after a failed build.

F5 saves the current buffer, not every modified buffer. Save edits in other source/header buffers before building. Configuration and compilation run asynchronously. The working directory defaults to the project root. Projects that require CMake presets, a custom build directory or non-CMake build commands can use **Launch executable (C/C++)** through `:DapContinue` to pick an already-built binary. Automatic builds use the standard `build/` directory and do not resolve presets.

Use `F10`, `F11`, `F12` to step and `Ctrl+F5` to stop. The existing DAP UI supports variables, watches and evaluation. **Attach to process (C/C++)** uses the process picker; attaching may require additional OS permissions.

## Diagnostics and verification

Use `:NvimDoctor`, `:LspInfo`, `:LspLog` and `:ConformInfo` to inspect tool discovery, clangd attachment and formatter selection.

```bash
./bin/check-cpp
```

This creates a temporary CMake C++20 project, builds and runs it, then verifies clangd attachment/root, parsing, hover, header definition, STL completion, an intentional diagnostic, rename, buffer formatting, and a CodeLLDB breakpoint/evaluation. Artifacts are kept at the printed temporary path for diagnosis. Requires the compiler, CMake, Ninja, clangd, clang-format, C++ parser and CodeLLDB. It also drives the actual F5 mapping in fresh sessions for CMake, standalone code, multiple executable targets and a failed compilation. The test uses a native Linux executable; cross-compilation and remote debugging are not covered.
