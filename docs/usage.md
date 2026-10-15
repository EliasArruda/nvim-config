# Guia de uso e dependências

Reformulação para Neovim 0.12, com atalhos preservados, Nightfly com fundo neutro e sintaxe Cyberdream, LSP nativo e Emmet independente para Razor. [Arquitetura, decisões e atualização](architecture.md).

## Instalação e manutenção

Requisitos: Neovim 0.12+, Git, rg/fd, Node, compilador C e tree-sitter CLI compatível com Treesitter main. Clone em `~/.config/nvim`, execute `bin/bootstrap-nvim`, abra o editor e rode `:NvimToolsInstall` e `:NvimParsersInstall`. A abertura normal não instala plugins ou ferramentas. Use `:NvimDoctor` para diagnóstico.

## Dependências

Instale Neovim 0.12+, Git, `rg`, `fd`, compilador C, make e tree-sitter CLI. Node.js/npm são necessários para os servidores web. Uma Nerd Font fornece os ícones. Os plugins são instalados pelo Lazy; as ferramentas declaradas em `lua/configs/langs/mason.lua`, pelo Mason. Preserve `lazy-lock.json` e use `:Lazy restore` para reproduzir os commits.

Instale apenas os SDKs das linguagens que utiliza:

- **C#/Blazor:** SDK .NET 10 para os testes desta configuração; SDKs adicionais conforme `global.json`/framework do projeto. Instale o servidor com `dotnet tool install --global EasyDotnet --version 3.4.30` (ou `update` se já instalado). Inclua `$HOME/.dotnet/tools` no PATH. O EasyDotnet gerencia Roslyn, Razor, a ponte HTML e netcoredbg. O CLI EasyDotnet inicia o servidor compatível com sua versão. Não habilite outro cliente Roslyn/OmniSharp/rzls simultaneamente.
- **Web:** instale as dependências com o gerenciador do projeto. JS/TS/CSS/JSON/GraphQL com `biome.json` usam Biome, que precisa estar instalado no projeto ou PATH; os demais usam Prettier. HTML/Vue/Svelte/Markdown usam Prettier. Execute `:ConformInfo` para conferir a resolução.
- **Go:** Go, ferramentas declaradas no Mason e `govulncheck` externo (`go install golang.org/x/vuln/cmd/govulncheck@latest`); inclua `$(go env GOPATH)/bin` no PATH. GoLint suporta golangci-lint v2 e envia SARIF ao quickfix.
- **Rust:** rustup, rust-analyzer e rustfmt para a toolchain do projeto.
- **Ruby/Rails:** mise, Ruby e Bundler. Execute `mise exec -- gem install ruby-lsp erb-formatter --no-document` para cada Ruby utilizado e `bundle install` no projeto. RuboCop/Standard devem fazer parte do bundle quando utilizados. Os wrappers em `bin/` selecionam a versão Ruby pelo mise.
- **Opcionais:** `fish_indent` vem do Fish; `caddy fmt` requer Caddy. Não estão instalados nesta máquina. `shfmt` está declarado no Mason. Ferramentas externas e SDKs não são fixados pelo lockfile do Lazy.

## C#, Razor e Blazor

Abra o Neovim na pasta da solução. Use `:Dotnet new` para criar projetos pelos templates instalados; `:Dotnet solution select` escolhe a solução, e `:Dotnet solution add` acrescenta projetos. Para começar pelo terminal:

```bash
mkdir MinhaSolucao && cd MinhaSolucao
dotnet new sln --name MinhaSolucao --format slnx
dotnet new blazor --name MinhaApp --interactivity Server
dotnet sln MinhaSolucao.slnx add MinhaApp
nvim MinhaApp/Components/Pages/Counter.razor
```

Aguarde o carregamento da solução antes da primeira completion. `.cs`, `.razor` e `.cshtml` usam o pipeline do EasyDotnet; abrir apenas `.csproj` também carrega o suporte ProjX. Arquivos novos passam a anexar o LSP após salvar. A formatação Razor é enviada ao Roslyn; C# usa CSharpier com fallback LSP. A indentação C# permanece a nativa do Neovim.

`<leader>` é Espaço:

| Atalho | Ação |
| --- | --- |
| `<Space>nn` / `nf` | Criar projeto/solução / arquivo |
| `<Space>ns` / `na` | Selecionar solução / adicionar projeto |
| `<Space>nR` / `nb` | Restore / build com quickfix |
| `<Space>nr` / `nw` | Executar / executar com watch |
| `<Space>nd` / `nt` | Depurar / abrir test runner |
| `<Space>nl` | Reiniciar Roslyn |
| `gd` / `K` | Definição / documentação |
| `<Space>ca` / `cr` / `cf` | Code actions / renomear / formatar |
| `<Space>db` / `F5` | Breakpoint / iniciar ou continuar |
| `F10` / `F11` / `F12` | Step over / into / out |
| `Ctrl-F5` | Encerrar a sessão de depuração |

Use `:checkhealth easy-dotnet`, `:lsp`, `:ConformInfo` e `:messages` para diagnóstico. O teste de depuração cobre C# no servidor; depuração de WebAssembly no navegador exige um fluxo próprio e não foi validada.

A query local em `queries/razor/injections.scm` corrige a perda persistente de cores após editar HTML aninhado. O Blink permite completion de atributos após espaço dentro de tags Razor e normaliza essa requisição para Roslyn/HTML. Reinicie o Neovim após atualizar essas configurações, pois parsers e queries já carregados permanecem em cache. Detalhes: [arquitetura e correções Razor](architecture.md).

A gramática Treesitter Razor atual ainda produz nós `ERROR` para DOCTYPE e texto solto na raiz em arquivos válidos do template oficial. Isso não é um diagnóstico Roslyn nem um erro de compilação. Os casos estão registrados no relatório; não foram escondidos nem classificados como corrigidos.

## Outros atalhos

| Atalho/comando | Ação |
| --- | --- |
| `<Space>ff` / `fg` / `sg` | Arquivos / arquivos Git / grep |
| `<Space>cf` / `uf` | Formatar / alternar formatação ao salvar |
| `<Space>rpd`, `rpb`, `rpt`, `rpl`, `rpc` | Scripts web dev, build, test, lint, check |
| `<Space>rt` / `rl` | Testes Ruby (atalhos preservados) |
| `<Space>mt` / `mT` | Teste Go da função / testes do pacote |
| `<Space>un` / `uX` | Histórico Noice / dispensar mensagens |
| `<Space>uN` | Alternar números das linhas |
| `<Space>qq` | Sair |
| `:Lazy` / `:Mason` | Gerenciar plugins / ferramentas |

Pressione Espaço e aguarde o which-key para consultar os demais atalhos.

## Verificação

```bash
./bin/check-nvim
./bin/check-dotnet
```

O primeiro testa a configuração usando os plugins já instalados. O segundo cria uma solução temporária .NET 10 com Blazor e xUnit, faz restore/build/test e verifica LSP Razor, completion C#/HTML, diagnóstico proposital, formatação, rename, ProjX e breakpoint C#. Requer os plugins/parsers/ferramentas previamente instalados e acesso ao NuGet na primeira execução. Não altera projetos existentes; informa a pasta temporária com as evidências. A abertura normal também não instala ferramentas/plugins. Os testes mantêm o lockfile e o estado isolados.

A configuração principal fica em `lua/core`, as ferramentas em `lua/configs/langs`, as specs em `lua/plugins` e o modo VSCode em `lua/vscode-nvim-config`. Neovide e VSCode possuem ajustes próprios; a integração gráfica não foi validada por testes headless.

## Ícones Symbols

[Symbols do VSCode](symbols.md): 348 desenhos originais e 1.479 associações, com fonte auxiliar colorida no Neovide e fallback Nerd Font em terminais. Integra explorador, abas, Telescope e autocomplete de caminhos. Use `:SymbolsIcons all` para o catálogo completo; `bin/install-symbols-font` reconstrói a fonte. Texto e atalhos permanecem iguais.

## Painel de terminais

[Sessões em um único painel](terminal-sessions.md): Ctrl+T mostra/oculta e Ctrl+N cria outra sessão no modo terminal. Com vários shells, a lista à direita permite trocar por clique ou Enter, mantendo os processos ativos.
