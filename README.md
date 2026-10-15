<div align="center">
  <h1>Neovim</h1>
  <p><strong>Seu projeto. Seus atalhos. Menos distrações.</strong></p>
  <p>Configuração pessoal para desenvolvimento com C#, Blazor e web.<br />Fundo escuro, sintaxe Cyberdream e ícones Symbols no Neovide.</p>
  <p>
    <img src="https://img.shields.io/badge/Neovim-0.12%2B-5eff6c" alt="Neovim 0.12 ou superior" />
    <img src="https://img.shields.io/badge/config-Lua-5ea1ff" alt="Configuração Lua" />
    <img src="https://img.shields.io/badge/validado-Linux-ffbd5e" alt="Validado no Linux" />
  </p>
  <p><a href="#o-que-você-encontra">Recursos</a> · <a href="#comece-a-usar">Instalação</a> · <a href="#arquivos-novos-com-templates">Templates</a> · <a href="#bom-saber">Bom saber</a></p>
</div>

## O que você encontra

- **C# e Blazor no mesmo fluxo.** Roslyn e Razor pelo EasyDotnet, completion de componentes e atributos, Emmet, formatação, testes e depuração C#.
- **Arquivos novos com uma base pronta.** Templates automáticos para C#, Vue, Go e componentes Razor, inclusive quando o explorador cria o arquivo antes de abri-lo.
- **Seu projeto como ponto de partida.** Busca e ferramentas resolvem a raiz mais próxima pelo projeto ou pacote.
- **Código com mais cor.** Sintaxe Cyberdream sobre uma interface Nightfly com fundo neutro. Abas, menus e painéis mantêm a mesma identidade.
- **Ícones Symbols.** 348 desenhos e 1.479 associações de arquivos e pastas; fonte auxiliar colorida no Neovide e fallback Nerd Font no terminal.
- **Vários shells, um painel.** Lista de sessões à direita, troca por Alt+1…9 e processos preservados ao ocultar. `exit` fecha somente a sessão atual.
- **Instalação explícita.** Plugins fixados no lockfile; ferramentas, parsers e atualizações são operações manuais.

## Comece a usar

Requisitos: Neovim **0.12+**, Git, `ripgrep`, `fd`, Node.js/npm, compilador C, make e tree-sitter CLI compatível com nvim-treesitter. Use uma Nerd Font. Neovide é opcional.

1. Com o editor fechado, coloque este repositório em `~/.config/nvim`. Se essa pasta já existe, mova sua configuração atual para um local escolhido por você antes de clonar.

   ```bash
   git clone https://github.com/EliasArruda/nvim-config.git ~/.config/nvim
   cd ~/.config/nvim
   ./bin/bootstrap-nvim
   ```

2. Abra `nvim` e execute `:NvimToolsInstall` e `:NvimParsersInstall`. A abertura normal não baixa plugins nem ferramentas.
3. Instale os SDKs das linguagens que utiliza. Para C#/Blazor, consulte o [guia de dependências](docs/usage.md#dependências); o SDK .NET e o CLI EasyDotnet são externos ao Mason.
4. Para ícones coloridos no Neovide, execute `./bin/install-symbols-font` e reinicie o Neovide. Veja os [requisitos da fonte Symbols](docs/symbols.md).
5. Abra o editor na pasta do projeto. Use `:NvimDoctor` para conferir raiz, ferramentas e LSPs.

## Arquivos novos com templates

Crie e abra o arquivo pelo explorador ou use `:edit caminho/Arquivo.cs`. O conteúdo aparece no buffer e só vai ao disco quando você salvar.

| Arquivo | Conteúdo inicial |
| --- | --- |
| `Customer.cs`, `IService.cs` | Classe ou interface com namespace derivado do `.csproj` e das pastas |
| `OrderDto.cs`, `OrdersController.cs`, `OrderStatus.cs` | Record, controller ou enum conforme o nome |
| `Counter.razor.cs` | Classe parcial para o code-behind do componente |
| `Card.vue` | Bloco `<template>` pronto para editar |
| `main.go`, outros `.go` | Declaração de pacote, reutilizando o pacote dos arquivos vizinhos |
| `Card.razor` | Título do componente e bloco `@code` |

Arquivos com conteúdo e arquivos vazios antigos ficam intactos. Arquivos vazios já criados no disco são elegíveis por até **10 segundos** após a modificação. `_Imports.razor` e outros `.razor` iniciados por `_` ficam vazios. Um template Razor de componente não acrescenta rota automaticamente.

## Atalhos essenciais

O líder é **Espaço**. Pressione-o e aguarde para consultar o which-key.

| Atalho | Ação |
| --- | --- |
| `<Space>ff` / `<Space>fg` / `<Space>sg` | Arquivos / arquivos Git / busca por texto |
| `gd` / `K` | Definição / documentação |
| `<Space>ca` / `<Space>cr` / `<Space>cf` | Ações de código / renomear / formatar |
| `<Space>nn` / `<Space>nf` | Criar projeto .NET / arquivo .NET |
| `<Space>nb` / `<Space>nr` / `<Space>nt` | Build / executar / testes .NET |
| `Ctrl+T` | Mostrar ou ocultar terminais |
| `Ctrl+N` no terminal | Criar outra sessão |
| `Alt+1`…`Alt+9` no painel | Selecionar sessão |
| `<Space>qq` | Sair |

[Guia completo](docs/usage.md) · [Painel de terminais](docs/terminal-sessions.md)

## Bom saber

Esta é uma configuração pessoal, validada no Linux. Neovide e a extensão VSCode Neovim possuem ajustes próprios. SDKs, ferramentas externas e fontes não fazem parte do lockfile do Lazy.

Em Razor, aguarde a solução carregar para obter completion completa. Emmet funciona independentemente do Roslyn: `span` pode expandir para `<span></span>`, e Enter entre as tags cria a linha interna indentada. Arquivos novos recebem o LSP após salvar. A gramática Razor ainda tem limites conhecidos; detalhes em [arquitetura](docs/architecture.md).

Use `:Lazy restore` para restaurar os commits fixados, `:ConformInfo` para conferir formatadores e `:NvimDoctor` para diagnóstico. A instalação, validação e manutenção estão documentadas separadamente:

- [Dependências e uso por linguagem](docs/usage.md)
- [Arquitetura e decisões](docs/architecture.md)
- [Atualização e diagnóstico Blazor](docs/updates-and-blazor.md)
- [Ícones e fonte Symbols](docs/symbols.md)

## Verificação

```bash
./bin/check-nvim
./bin/check-blazor
./bin/check-dotnet
```

`check-nvim` cobre configuração, templates, diagnósticos, ícones e terminais com plugins já instalados. `check-blazor` verifica Razor e Emmet localmente. `check-dotnet` cria uma solução temporária .NET 10 e verifica build, testes e integração LSP/debugger; requer SDK, ferramentas e acesso ao NuGet. Consulte o [guia de verificação](docs/usage.md#verificação).

[Resultados e limites da última verificação](docs/validation.md).

## Créditos

Interface [Nightfly](https://github.com/bluz71/vim-nightfly-colors), paleta de sintaxe [Cyberdream](https://github.com/scottmckendry/cyberdream.nvim) e ícones [Symbols](https://github.com/miguelsolorio/symbols). Licenças dos recursos redistribuídos ficam em [`licenses/`](licenses/).
