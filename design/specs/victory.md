# Spec — tela de vitória

## Objetivo

Celebrar a conclusão de uma fase, mostrar a pontuação de estrelas e recompensas, e oferecer continuação ou retorno ao início.

## Estrutura visual

1. Fundo de mata verde-escura, com folhas de enquadramento nos cantos e área central mais calma.
2. Placa de madeira central com três estrelas no topo; cordas alinhadas aos pontos de fixação da placa sobem até a borda superior.
3. Título `Você venceu!` e número da fase logo abaixo, em fonte arredondada e legível.
4. Cartão creme interno com seção `Suas recompensas` e os valores de moedas e cristais/itens.
5. Botão verde `Próxima fase` fica logo abaixo das recompensas; botão azul `Início` vem em seguida, com separação curta e clara.
6. Painel inferior menor, ligado por cordas, com quatro controles: som, música, ajuda e repetir.

## Conteúdo e dados

- Título: `Você venceu!`
- Linha secundária: fase, tema e estrelas recebidas (substituir pelos dados do resultado)
- Recompensas de referência: `500` moedas e `50` cristais; valores vêm do resultado real da fase.
- A primeira, segunda e terceira estrelas refletem o desempenho. Se o jogo não calcular estrelas, mostrar apenas as recebidas sem sugerir uma avaliação inexistente.

## Comportamento

- A vitória dispara confetes e brilhos nas estrelas; placa, recompensas, folhas, controles e botões têm animações curtas. Respeitar a preferência por movimento reduzido.
- Efeitos, notas de vitória e trilha ambiente são sintetizados pelo Web Audio localmente, sem dependência de arquivo externo. Música e efeitos usam controles independentes; volume de efeitos vem das configurações. O navegador inicia o áudio após interação quando a reprodução automática estiver bloqueada.
- `Próxima fase` inicia a próxima fase desbloqueada.
- `Início` retorna ao menu principal.
- A caixa de recompensas não pode encostar nem se sobrepor ao botão de próxima fase.
- Som e música alternam suas preferências; estado ligado/desligado deve ser evidente e acessível.
- Ao desligar som ou música, mostrar o controle vermelho correspondente e atualizar o rótulo acessível e visível para o estado desligado.
- Ajuda abre a explicação dos controles ou das regras da fase concluída.
- Repetir abre a fase atual novamente; o progresso da demonstração é salvo imediatamente no navegador.

## Layout adaptável

- Placa principal e painel inferior devem caber na altura disponível com espaçamento entre eles.
- Em alturas curtas, reduzir respiros e escala das placas antes de permitir sobreposição; os quatro controles inferiores podem rolar se necessário.
- Fundo: `assets/screens/victory-background.png`.
- Placa integrada, com cordas contínuas desde o topo: `assets/ui/victory-board-rope-v2.png`.
