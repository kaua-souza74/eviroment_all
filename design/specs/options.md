# Spec — opções da partida

## Objetivo

Definir o formato da próxima rodada antes de começar.

## Estrutura visual

- Mesmo céu, vegetação, marca e placas de madeira do menu.
- Cartão creme com três grupos: modo, tema ambiental e nível de desafio.
- Dicas da fase podem ser ligadas ou desligadas nesta partida.

## Diferença para configurações

Opções alteram a sessão que será iniciada: aventura ou desafio rápido, tema e dificuldade. As escolhas são guardadas como parâmetros da próxima partida.

## Comportamento

- Uma escolha por grupo; a seleção ativa fica visualmente marcada e acessível por estado pressionado.
- `Salvar escolhas` persiste as opções locais da demonstração.
- `Começar` usa essas escolhas e inicia a próxima fase disponível.

## Conteúdo inicial

- Modos: `Aventura` e `Desafio rápido`.
- Temas: `Reciclagem`, `Poluição`, `Os 3 Rs`, `Plantio` e `Desmatamento`.
- Missões podem abrir esta página com o tema correspondente já selecionado.
- Dificuldades: `Trilha` e `Guardião`.
