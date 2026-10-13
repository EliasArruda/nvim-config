# Registro da reformulação

Data: 12/10/2026. Implementação aplicada após validação em configuração, dados e estado XDG isolados. Tema padrão TokyoNight Night; organização descrita em [architecture.md](architecture.md).

Verificação: 150 checks gerais, 16 de arquitetura, 41 regressões Blazor, seis cenários reais de completion e quatro abreviações Emmet. Build/xUnit e testes LSP/format/rename/ProjX/debugger passaram com EasyDotnet 3.4.30. UI embutida confirmou menu automático, Tab/Enter e raiz do projeto real.

Compatibilidade: 132 atalhos de plugins e 510 mapas globais preservados; IDs internos Vimscript foram normalizados na comparação. Arquivos centrais de keymaps/toggles/Neovide/VSCode conservados byte a byte desde o início desta reforma. Alterações anteriores locais integram a base reproduzível do PR.

Atualizações: oito plugins existentes e dois novos (TokyoNight/SchemaStore). Mason: StyLua 2.6.0, Bicep 0.48.1, YAML LS 1.25.0, Ruff 0.17.0, goimports 0.52.0. O candidato Roslyn 5.13.0-1.26509.1 estava indisponível; manteve-se 5.13.0-1.26502.3. Rust recebeu o componente rust-analyzer da toolchain instalada. SDKs de projetos foram preservados.

Próximo passo operacional: reabrir Neovim/Neovide para descarregar os módulos/parsers antigos. `:NvimDoctor` permite conferir a raiz, clientes e Tab. Backups completos e script de restauração estão nos entregáveis locais da conversa. A janela nativa Neovide não foi automatizada.
