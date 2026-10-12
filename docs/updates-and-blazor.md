# Atualização e estabilidade Blazor

## Antes de atualizar

A atualização tem quatro camadas independentes: plugins Lazy, ferramentas Mason, parsers/queries Treesitter e ferramentas .NET externas. `Lazy update` não atualiza servidores Mason nem EasyDotnet; `MasonUpdate` atualiza somente os registros. `Lazy sync` também remove plugins considerados desnecessários, por isso este procedimento usa `Lazy update`.

Consulte as versões disponíveis sem substituir instalações:

```bash
~/.config/nvim/bin/check-nvim-updates
```

O comando faz fetch de referências Git, respeita as restrições de versão do Lazy e atualiza o catálogo Mason. Não faz checkout, instalação, compilação ou atualização de ferramentas .NET. Retorna o diretório do plano JSON e preserva logs completos. Falhas de rede/catálogo são informadas com código de saída diferente de zero. Uma ferramenta listada como diferente não foi necessariamente validada para este projeto.

Execute a validação de Blazor antes e depois de cada camada:

```bash
~/.config/nvim/bin/check-blazor
~/.config/nvim/bin/check-blazor --integration
```

Na configuração local que possui a suíte anterior, execute também:

```bash
~/.config/nvim/bin/check-nvim
~/.config/nvim/bin/check-dotnet
```

`check-blazor --integration` cria um projeto temporário Blazor .NET 10, faz build e valida o menu real. Requer acesso ao NuGet na primeira restauração e preserva os logs/projeto para diagnóstico. `check-blazor` não depende dessas duas suítes. Utiliza plugins e parsers já instalados; não instala ausências. Os testes headless não comprovam aparência gráfica em Neovide ou VSCode.

## Backup para rollback

Feche sessões Neovim antes de atualizar para evitar clientes e parsers antigos em memória. Preserve as alterações locais existentes antes de publicar qualquer atualização. No ambiente Linux padrão desta configuração:

```bash
update_backup="${XDG_STATE_HOME:-$HOME/.local/state}/nvim/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$update_backup"
cp -a "$HOME/.config/nvim" "$update_backup/config"
for update_dir in lazy mason site; do
  cp -a "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/$update_dir" "$update_backup/$update_dir"
done
dotnet tool list --global > "$update_backup/dotnet-tools.txt"
printf '%s\n' "$update_backup"
```

O conjunto instalado auditado ocupava cerca de 1,8 GB, além da configuração; confira espaço antes de copiar. Este snapshot inclui os parsers compilados e as instalações Mason. O lockfile sozinho não os restaura. Ferramentas .NET devem ser reinstaladas na versão registrada no inventário se forem alteradas.

## Atualizar por camadas

1. **Plugins**: abra Neovim sem uma solução carregada e execute `:Lazy update`. Ele respeita `version`/`branch` e atualiza o lockfile. Leia as alterações de EasyDotnet/Blink/Treesitter, feche o processo, abra outro e rode os checks. Não use `:Lazy reload` como substituto de reiniciar clientes e parsers.
2. **Parsers**: execute `:TSUpdate` depois de atualizar o plugin Treesitter; aguarde todas as instalações. Reinicie e rode `check-blazor`. Razor e HTML precisam ser compatíveis com as queries carregadas. Não remova a proteção de injeções combinadas desta configuração sem uma regressão de edição.
3. **Ferramentas Mason**: execute `:MasonUpdate`, depois `:Mason`. Confira a versão de cada pacote e use a ação de atualização do pacote. Priorize o grupo .NET/HTML antes das outras linguagens. Para versões específicas, use `:MasonInstall pacote@versão` conforme o catálogo. Não considere o sucesso de `MasonUpdate` como atualização dos binários.
4. **EasyDotnet e Roslyn**: atualize o EasyDotnet na versão escolhida, por exemplo `dotnet tool update --global EasyDotnet --version 3.4.30`, e reteste antes de atualizar Roslyn. A documentação recente migra Roslyn para o global tool oficial `roslyn-language-server`. Confira a versão/implementação efetivamente utilizada por EasyDotnet; não habilite um segundo cliente Roslyn/rzls/OmniSharp no buffer. `dotnet-easydotnet roslyn update` atualiza o tool oficial nas versões que implementam essa operação. O Roslyn instalado pelo Mason não substitui automaticamente esse tool.

A versão 3.4.30 foi consultada em 12/10/2026, mas não foi instalada ou certificada por estas correções. As mudanças de arquitetura do servidor exigem a suíte de integração. SDK .NET, runtime Node, Ruby e toolchain Rust ficam fora de uma atualização cega: respeite `global.json`, arquivos de toolchain e versões selecionadas pelo projeto.

Para rollback, feche o editor, mova a instalação que falhou para outra pasta e copie de volta `config`, `lazy`, `mason` e `site` do snapshot. Preserve ambos até testar. Se apenas plugins foram alterados, recuperar o lockfile anterior e executar `:Lazy restore` é suficiente para essa camada, mas não para parsers, Mason ou tools .NET.

## Correções de edição Razor

`lua/plugins/lang/blazor-stability.lua` acrescenta ajustes sem substituir as configurações anteriores:

- O contexto de atributos reconhece uma tag aberta nas 80 linhas anteriores, respeitando aspas/comentários e a árvore C#.
- Espaço em atributo HTML gera uma requisição Invoked somente nesse contexto. Espaço em C# e valores de atributos preserva o gatilho original.
- Preseleção e inserção automática do Blink ficam desabilitadas apenas em Razor. Use seleção explícita e Enter/Tab para aceitar. Navegar por sugestões não altera mais o markup.
- As injeções Razor usam árvores HTML independentes. Um `ERROR` de markup na raiz recebe uma injeção de recuperação restrita. Erros dentro de C# não recebem essa injeção.
- O parser HTML é carregado antes do highlighter Razor.

A gramática ainda não interpreta todo markup incompleto como markup válido. Com uma aspa aberta, pode deixar de reconhecer tags posteriores até a aspa ser fechada. A correção preserva tags já reconhecíveis e testa a recuperação após completar a edição; não colore texto arbitrariamente para mascarar o parser.

Reinicie completamente o Neovim após aplicar a configuração. Não basta reiniciar somente o LSP: queries e parsers permanecem no processo. Abra pela pasta da solução, espere Roslyn carregar e teste `<div ` e atributos de componentes em várias linhas. `Ctrl-Space` solicita sugestões manualmente.

## Teste com menu real

`tests/blazor/completion.lua` é um teste de integração adicional. Requer uma solução temporária chamada `BlazorSmoke`, com `Components/Pages/EditProbe.razor` e componente `AuditButton` em `BlazorSmoke.Components`. Recebe `NVIM_BLAZOR_PROJECT_ROOT` e `NVIM_BLAZOR_TEST_OUTPUT`, entra em Insert e observa o menu Blink em seis casos: tag HTML, atributo, atributo em várias linhas, componente, parâmetro de componente e C#.

O JSON registra os itens e o cliente que os produziu. Este teste não equivale a requisições LSP diretas nem depende de completar manualmente com Ctrl-Space. A suíte atual confirmou os seis casos usando EasyDotnet 3.4.26 e os commits instalados antes da atualização.

## Fontes consultadas

- [Lazy: comandos e semântica de update/sync/restore](https://lazy.folke.io/usage).
- [Lazy: lockfile e restauração](https://lazy.folke.io/usage/lockfile).
- [Mason: comandos e registros](https://github.com/mason-org/mason.nvim#commands).
- [Treesitter: instalação/atualização e branch main](https://github.com/nvim-treesitter/nvim-treesitter).
- [EasyDotnet: suporte Razor e servidor HTML](https://github.com/GustavEikaas/easy-dotnet.nvim#roslyn-lsp).
- [EasyDotnet: mudanças do servidor e Roslyn oficial](https://github.com/GustavEikaas/easy-dotnet.nvim/blob/main/news.md).
- [Gramática Razor: relato de invalid ranges em injeções combinadas](https://github.com/tris203/tree-sitter-razor/issues/28). Esse relato é do Helix; a reprodução no Neovim foi feita separadamente, sem assumir que os editores falham da mesma maneira.

## Emmet no Razor

Emmet já é fornecido pelo servidor `emmet_language_server`, com Razor mapeado para HTML. As sugestões recebem prioridade no markup; ficam fora de blocos C#, expressões Razor reais e comentários. Um `@` ausente na recuperação do parser não transforma uma abreviação HTML, como `div.container`, em código C#.

Digite `span` e pressione Tab para gerar `<span></span>`. O cursor fica entre as tags. Enter gera exatamente duas linhas, com o cursor no início da linha da tag de fechamento:

```html
<span>
</span>
```

`span.` inicia uma classe e gera `<span class=""></span>`, com o cursor no valor da classe. `div.container` gera uma div com essa classe; `ul>li*3` gera três itens. Os campos de snippets podem ser percorridos com Tab/Shift-Tab. Este comportamento usa Emmet real, sem substituição de texto inventada.

`check-blazor --integration` também testa quatro abreviações digitadas, aceitação por Tab e Enter. O Enter de Razor já produzia duas linhas no ambiente verificado; sua configuração de autopairs foi preservada. Outros filetypes continuam com suas regras de indentação existentes.
