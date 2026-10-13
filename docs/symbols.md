# Symbols no Neovim

A configuração adapta a [Symbols de Miguel Solorio](https://github.com/miguelsolorio/vscode-symbols) 0.0.26 instalada no VSCode. O snapshot vem do manifesto modificado declarado pela extensão, que é o tema ativo do usuário.

## Cobertura

- Todos os 348 desenhos SVG do catálogo, incluindo logos, variantes de cor e pastas com badges.
- 1.479 associações: 427 extensões, 783 nomes de arquivo, 106 linguagens e 163 diretórios.
- Aliases .NET capitalizados, Razor/JSONC e prioridade para arquivos nomeados, como package.json.
- Explorador Snacks, pastas abertas/fechadas e raiz, Telescope, Bufferline e autocomplete de caminhos no Blink.
- Normalização de extensão/filetype para o lookup do mini.icons. O manifesto instalado referencia dois ícones inexistentes: less usa code-blue e yml usa yaml.

O tema escuro, a fonte de texto JetBrainsMono Nerd Font h16 e os atalhos permanecem iguais. A Symbols fornece ícones de arquivos/pastas; os ícones semânticos de métodos, classes e propriedades continuam com seus desenhos próprios.

## Desenhos originais no Neovide

`Neovim Symbols` é uma fonte auxiliar local gerada de `data/symbols-svg/*.svg`, com rasterização resvg e nove resoluções coloridas no formato sbix. Mantém múltiplas cores, contornos, máscaras, transparências e detalhes das pastas. A fonte entra como fallback na opção guifont; não substitui letras, números nem ícones Nerd Font existentes. A renderização foi conferida no Neovide real em uma sessão Wayland isolada.

Os ícones são rasterizações dos SVGs em tamanhos predefinidos, não SVGs escaláveis ao vivo. O antialiasing pode diferir do VSCode. A configuração usa a fonte apenas no Neovide quando o snapshot e a assinatura instalada correspondem. Sem a fonte, com snapshot atualizado sem rebuild ou em terminais, volta à adaptação Nerd Font. Renderizadores sem suporte a sbix têm contornos monocromáticos na fonte.

Os desenhos ocupam 1 em na fonte auxiliar, 25% maiores que a adaptação inicial de 0,8 em. O centro horizontal usa o espaço de duas células reservado pelos componentes; o centro vertical acompanha a altura das maiúsculas da JetBrainsMono. Os offsets coloridos e os contornos monocromáticos usam a mesma referência, sem aumentar texto, linhas ou atalhos. Os testes verificam a centralização nas nove resoluções, com tolerância de meio pixel para arredondamento.

## Prévia

- `:SymbolsIcons`: exemplos de arquivos e pastas.
- `:SymbolsIcons all`: os 348 desenhos, em ordem alfabética.
- `:SymbolsIcons directory`: todas as associações de pastas.
- `:SymbolsIcons file`, `extension` ou `filetype`: associações dessas categorias.

Nenhum atalho foi acrescentado. As janelas de prévia usam os comandos e movimentos existentes do Neovim.

## Instalação e atualização

A fonte está instalada neste computador. Para reconstruir em outra instalação Linux com Python 3 e Fontconfig:

```bash
~/.config/nvim/bin/install-symbols-font
```

O comando cria um venv fora do repositório, instala dependências com versões fixadas, gera a fonte em `${XDG_DATA_HOME:-~/.local/share}/fonts/nvim-symbols` e atualiza o cache Fontconfig. O binário não é versionado; os SVGs, importador, gerador e licença MIT são versionados.

Para importar uma versão instalada da Symbols e reconstruir a fonte:

```bash
python3 ~/.config/nvim/scripts/import-symbols.py ~/.vscode/extensions/miguelsolorio.symbols-0.0.26
~/.config/nvim/bin/install-symbols-font
```

Depois reabra o Neovide. Não há rede, instalação nem consulta ao VSCode durante a abertura normal. Para desativar a fonte auxiliar antes de carregar os plugins, defina `vim.g.symbols_icons_font = false`.

## Verificação

`bin/check-nvim` cobre o fallback terminal, cores, precedência de nomes, reload, fundo escuro, catálogos e autocomplete. O teste explícito `tests/symbols-font.lua` verifica todas as 1.479 associações contra os caracteres da fonte e a largura usada pelo Neovim. `tests/symbols-font.py` valida o cmap, as imagens coloridas, contornos e a separação da fonte de texto.

Os testes visuais usam o Neovide em um compositor Wayland independente, sem depender da janela ou do foco da sessão do usuário.
