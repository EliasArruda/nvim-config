# Arquitetura e manutenção — 12/10/2026

A configuração é personalizada para Neovim 0.12, com Lazy como gerenciador. A reforma conserva os atalhos locais existentes e organiza os serviços em `lua/config/`.

## Responsabilidades

- `config/init.lua`: inicialização e integração VSCode/Neovide.
- `config/settings.lua`: escolhas visuais e limites compartilhados.
- `config/lazy.lua`: carregamento e versões fixadas em `lazy-lock.json`, sem downloads na abertura.
- `config/lsp.lua`: lifecycle nativo, capabilities, diagnósticos, inlay hints e CodeLens. Os atalhos continuam declarados nos mesmos lugares.
- `core/project.lua`: raiz mais próxima pelo SDK/package; `.git` é fallback local. Nunca usa markers do HOME para um projeto filho. Os atalhos que explicitamente usam cwd preservam esse comportamento.
- `config/runtime.lua`: opções comuns e proteção de arquivos grandes.
- `config/ui.lua`: paleta e grupos de destaque compartilhados.
- `config/sources/emmet.lua`: completion Emmet independente em Razor.
- `config/health.lua`: `:NvimDoctor`, com projeto, Tab, clientes e ferramentas.
- `config/tools.lua`: instalação explícita de ferramentas/parsers.
- `plugins/`: declarações por domínio, dependências e integrações.
- `configs/langs/`: escolhas específicas de cada linguagem.
- `core/keymaps.lua`, `core/toggles.lua`, keymaps Neovide e VSCode: preservados byte a byte em relação ao início da reforma.

## Completion e Razor

Blink permanece na versão estável 1.x; migrar para 2.x exige outro contrato de dependências. Em Razor, o Emmet consulta somente seu servidor e pode mostrar o menu sem esperar Roslyn/Tailwind. A fonte LSP remove entradas Emmet duplicadas. C#/comentários não recebem abreviações HTML. O HTML delegado pelo EasyDotnet continua responsável por atributos e os componentes/parâmetros usam Roslyn.

`span` aparece automaticamente no menu. Tab aceita `<span></span>`. Enter entre as tags mantém duas linhas, com o cursor no início da segunda. `span.` produz uma classe editável. Tab continua indentando quando não existe completion/snippet ativo: o atalho foi preservado.

As queries Razor corrigem regiões HTML combinadas e recuperam tags incompletas. Parsers continuam tendo limites em documentos inválidos; não há promessa de equivalência integral com VSCode. Novos arquivos Razor recebem Roslyn após salvar, conforme o pipeline upstream.

## Visual e desempenho

TokyoNight Night é o padrão: cores consistentes, popups opacos e bordas discretas. O fundo quase preto é personalizado para o gosto do usuário; Midnight foi removido da configuração. Neovide conserva fonte/tamanho, com menos movimento e sem partículas. Lualine mostra projeto, arquivo, diagnósticos e clientes em telas largas. Telescope preserva atalhos e usa a raiz corrigida. Snacks fornece indentação, explorer e proteção de arquivos grandes. Diagnósticos nativos aparecem em linhas virtuais na linha atual; tiny-inline-diagnostic e hlchunk ficam desativados para evitar sobreposição de responsabilidades.

Arquivos acima de 1 MiB evitam completion, formatação automática e Treesitter. Os servidores comuns também evitam esses buffers. Plugins especializados, como EasyDotnet/Rustacean, podem administrar seus próprios clientes. Tailwind só inicia quando o projeto contém configuração ou dependência Tailwind; não varre o HOME por engano.

## Linguagens e ferramentas

Preservados .NET/Blazor, Vue/Svelte/JS/TS, Go, Rust, Python, Ruby/Rails, Elixir, SQL, Bicep, HTML/CSS, JSON/YAML e ferramentas existentes. JSON/YAML recebem SchemaStore. Bicep tem comando explícito. VTSLS usa `experimental` dentro de `settings.vtsls`. Vue usa o caminho público do Mason. Rust seleciona rust-analyzer da toolchain ativa via rustup; instale o componente nessa toolchain. Python usa Ruff para imports e formato. Go não cria outro proprietário de CodeLens/inlay hints.

## Atualização controlada

1. Faça backup da configuração, `lazy`, `mason`, `site` e inventário `dotnet tool list -g`.
2. Execute `bin/check-nvim-updates` para consultar versões sem instalá-las.
3. Atualize primeiro numa cópia com XDG_CONFIG_HOME/XDG_DATA_HOME/XDG_STATE_HOME isolados.
4. `:Lazy update` atualiza plugins; `:Lazy restore` reproduz o lockfile. `:MasonUpdate` atualiza o catálogo, não os binários. Atualize binários explicitamente pela interface Mason.
5. `:NvimToolsInstall` instala ferramentas declaradas ausentes. `:NvimParsersInstall` instala os parsers declarados. Atualizações Treesitter devem considerar somente os parsers suportados pelo gerenciador; Kulala administra seu parser externo.
6. Atualize EasyDotnet explicitamente com `dotnet tool update -g easydotnet --version VERSAO_VALIDADA`. SDKs de projetos não são atualizados junto.
7. Execute checks, compare atalhos, confira a UI e só então aplique. Reinicie o editor: processos antigos conservam módulos, queries e parsers em memória.

O catálogo Mason anunciou Roslyn `5.13.0-1.26509.1`, mas o instalador retornou `Version ... is not available`. A versão anterior foi mantida e validada. Nunca trate esse catálogo como garantia de um artefato disponível.

## Evidências e fontes

Validação: suíte geral, regressão Razor, build/xUnit, LSP, format/rename, ProjX, debugger, digitação Insert real com Blink e UI embutida. A UI embutida testa a grade real do Neovim; não constitui teste da janela nativa Neovide.

Fontes primárias consultadas:

- [Neovim LSP](https://neovim.io/doc/user/lsp/) e [mudanças 0.12](https://neovim.io/doc/user/news-0.12/).
- [Lazy](https://github.com/folke/lazy.nvim) e [referência LazyVim](https://www.lazyvim.org/plugins).
- [Blink releases](https://github.com/saghen/blink.cmp/releases) e [migração 2.x](https://github.com/saghen/blink.cmp/blob/main/UPGRADE.md).
- [Treesitter main](https://github.com/nvim-treesitter/nvim-treesitter).
- [EasyDotnet](https://github.com/GustavEikaas/easy-dotnet.nvim) e [notícias/migrações](https://github.com/GustavEikaas/easy-dotnet.nvim/blob/main/news.md).
- [TokyoNight](https://github.com/folke/tokyonight.nvim), [Snacks](https://github.com/folke/snacks.nvim), [SchemaStore](https://github.com/b0o/SchemaStore.nvim).

Decisões refletem versões disponíveis em 12/10/2026, não versões futuras de novembro/dezembro.
