# Spec — menu principal

## Objetivo

Ser o ponto de entrada do jogo e deixar o início da aventura ambiental óbvio.

## Estrutura visual

1. Fundo azul de céu aberto, com nuvens leves, cipós laterais e vegetação densa na base.
2. Marca centralizada acima de duas placas principais de madeira: `Jogar` e `Entrar / Criar conta`.
3. Grade em duas colunas para as ações de exploração: missões, conquistas, opções, configurações, ranking e loja.
4. Ação `Sair` ocupa uma placa própria na base do grupo; todas mantêm o acabamento de madeira e o relevo do jogo.

## Ações e ordem

1. `Jogar`
2. `Entrar / Criar conta`
3. `Missões`
4. `Conquistas`
5. `Opções`
6. `Configurações`
7. `Ranking`
8. `Loja`
9. `Sair`

## Comportamento

- `Jogar` abre a seleção/continuação de fase. Para pessoa sem progresso, iniciar a primeira fase disponível.
- `Entrar / Criar conta` abre a tela de login, de onde é possível seguir para o cadastro.
- `Missões` abre a trilha educativa de reciclagem, poluição, 3 Rs, plantio e desmatamento.
- `Conquistas` resume os marcos alcançados em fases e boas práticas.
- `Opções` abre escolhas rápidas do jogo, se disponíveis; caso contrário, pode encaminhar para configurações.
- `Configurações` controla áudio, idioma e preferências de acessibilidade.
- `Ranking` mostra pontuações do próprio jogo; conectividade e classificações globais não são pressupostas nesta versão.
- `Loja` apresenta itens e recompensas internas do jogo; no protótipo, compras e saldo ficam no armazenamento local do navegador.
- `Sair` encerra o jogo em plataformas que permitem encerrar; em outras, volta à tela anterior ou fica oculto.
- Estados pressionado e foco devem alterar relevo/sombra, sem deslocar o rótulo.
- As placas entram em sequência com um breve movimento de subida e balanço; folhas atravessam o cenário em ciclos lentos.

## Layout adaptável

- Dar prioridade visual às ações principais e agrupar as seis ações secundárias em duas colunas.
- Marca do jogo em tamanho destacado acima das ações.
- Reorganizar o grupo em telas baixas sem reduzir alvos de toque abaixo de 44 px.
- O fundo concentra folhas nas bordas e mantém área central limpa para os botões.
- Fundo: `assets/screens/menu-background.png`.
