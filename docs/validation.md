# Verificação

Última execução local: 15/10/2026, Linux, Neovim 0.12.

- `bin/check-nvim`: 157 checks gerais, 16 de arquitetura, 13 de templates em cada modo (nativo e VSCode), 13 de diagnósticos, 16 de ícones e 29 de terminais; entrada real Alt+1/Alt+2 também verificada.
- `bin/check-blazor`: 41 regressões, quatro casos com Enter real entre tags e exclusão de strings C#.
- `bin/check-dotnet`: build e xUnit .NET 10, LSP Razor, formatação, rename, completion/resolve, ProjX, anexação de arquivo novo após salvar e breakpoint gerenciado.
- Os cinco arquivos centrais de atalhos permanecem byte a byte iguais ao início da reforma.

Os testes de templates cobrem criação pelo editor e leitura de arquivos vazios recém-criados no disco. Protegem conteúdo existente, arquivos vazios antigos, `_Imports.razor` e o buffer ativo durante callbacks diferidos. Os testes de templates rodam isolados, sem iniciar LSPs contra os projetos fictícios. Uma execução anterior durante a revisão registrou um crash Roslyn (exit 134); os cenários de integração em projeto .NET real passaram. O comportamento gráfico do explorador e da extensão VSCode não foi automatizado nesta etapa.

O teste .NET pode registrar `dotnet server exited with code 143` no encerramento do Neovim, após terminar os cenários; o código corresponde ao encerramento do processo por SIGTERM. Resultados dos cenários são conferidos separadamente.

Backups e instalações duplicadas usados na reforma foram removidos a pedido do usuário. Código, testes, lockfile, fontes instaladas e ferramentas ativas permanecem; versões publicadas podem ser recuperadas pelo Git. Artefatos de diagnóstico de uma execução .NET ficam na pasta temporária informada pelo comando.
