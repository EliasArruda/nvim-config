# Symbols no Neovim

A configuração adapta a extensão [Symbols, de Miguel Solorio](https://github.com/miguelsolorio/vscode-symbols), instalada no VSCode como `miguelsolorio.symbols` 0.0.26. O snapshot usa o manifesto modificado declarado pela extensão, que é o tema ativo do usuário.

`data/symbols-icons.json` reúne 1.479 associações de extensão, nome de arquivo, linguagem e diretório, além das cores extraídas dos SVGs. Foram acrescentados aliases para pastas .NET capitalizadas e filetypes Razor/JSONC. Arquivos nomeados como package.json mantêm prioridade sobre a extensão JSON. As cores dos ícones são próprias da Symbols e persistem após trocar o colorscheme; o fundo Nightfly quase preto permanece igual.

`mini.icons` fornece os glifos e o adaptador nvim-web-devicons usado por Telescope e Bufferline. Snacks utiliza o mesmo provedor e pastas abertas/fechadas de fonte. `:SymbolsIcons` abre uma prévia. Nenhum atalho ou fonte foi alterado.

## Fidelidade

Neovide utiliza ícones de fonte, portanto os desenhos são aproximações com Nerd Fonts. Não são os SVGs originais nem uma execução da extensão VSCode. Logos com várias cores e detalhes internos de pastas não são reproduzidos integralmente. A cor dominante de cada SVG é preservada.

Plugins de SVG reais, como [real-icons.nvim](https://github.com/Mirsmog/real-icons.nvim), dependem de terminais com protocolo Kitty e usam fallback de fonte no Neovide. Por isso não foram adicionados para este fluxo.

## Atualizar o snapshot

Execute explicitamente, usando o diretório da versão instalada:

```bash
python3 ~/.config/nvim/scripts/import-symbols.py ~/.vscode/extensions/miguelsolorio.symbols-0.0.26
```

Depois reabra o editor. A abertura normal lê apenas o snapshot local; não consulta nem modifica o VSCode. A licença da Symbols acompanha os dados em `licenses/symbols-MIT.txt`.

## Verificação

Treze checks cobrem cores, Razor, Vue por languageId, nomes de arquivo, aliases de diretório, devicons, reload de colorscheme e fundo escuro. A fonte JetBrainsMono Nerd Font instalada contém todos os glifos usados. A UI embutida foi conferida no explorador do projeto Blazor e na prévia; a janela nativa Neovide não foi automatizada.
