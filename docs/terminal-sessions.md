# Terminais em um painel

Ctrl+T continua mostrando/ocultando os terminais. Ctrl+N, no modo terminal, cria outra sessão de shell. As sessões ocupam um único painel inferior; com duas ou mais, uma lista aparece à direita, indicando a ativa. A API `new_split` foi mantida para preservar a definição original dos atalhos.

Alt+1 até Alt+9 selecionam o número correspondente da lista quando o foco está em um terminal ou na lista lateral. Funcionam no modo terminal e no modo normal do buffer de terminal; números inexistentes não alteram a seleção. Os atalhos Alt+n das abas de arquivos continuam iguais fora desse painel.

Clique no nome para trocar e voltar ao shell, ou navegue na lista com os movimentos normais e pressione Enter. `q` na lista oculta o painel. Essas ações são locais aos buffers do painel; os mapas globais e os cinco arquivos centrais de atalhos permanecem iguais.

Ocultar ou trocar sessão não encerra o shell: processos e histórico permanecem no buffer original. Ctrl+T restaura a última sessão selecionada e conserva a altura do painel. Ao terminar a sessão ativa com `exit`, outra sessão disponível assume seu lugar; a lista desaparece quando sobra um único shell.

Terminais de comandos externos continuam com suas próprias janelas. Ctrl+T preserva a ocultação/restauração dessas janelas, sem misturá-las à lista de shells. A integração também reconhece shells abertos pelos atalhos existentes do Snacks. Fechamentos de popups alheios não recriam a lista nem roubam seu foco.

`tests/terminals.lua` cobre criação, troca, processos vivos, hide/restore, encerramento, comandos externos e foco. A UI foi conferida no Neovide em compositor Wayland isolado, incluindo primeiro clique na lista, Ctrl+T e Ctrl+N reais.
