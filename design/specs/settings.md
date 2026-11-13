# Spec — configurações

## Objetivo

Guardar preferências permanentes de áudio, acessibilidade e idioma.

## Estrutura visual

- Fundo e marca compartilhados com o menu.
- Cartão creme organizado em seções: áudio, acessibilidade e idioma.
- Controles precisam mostrar seus valores e estados ligado/desligado.

## Diferença para opções

Configurações se aplicam ao jogo inteiro e permanecem entre partidas. A trilha determina tema e tipo de atividade; a preferência de dicas e acessibilidade vive nas configurações persistentes.

## Controles

- Som do jogo e música: chaves independentes.
- Efeitos sonoros: volume ajustável.
- Acessibilidade: reduzir animações e ampliar texto.
- Idioma: português, inglês e espanhol.
- A trilha e os efeitos da demonstração são sintetizados no navegador; música e efeitos podem ser desligados separadamente. A trilha começa após a primeira interação caso o navegador bloqueie reprodução automática.
- `Salvar` persiste as preferências; `Padrão` restaura os valores iniciais.

## Referência

A organização de áudio, gráficos, interface e entrada é comum em menus de jogo; neste protótipo, os controles gráficos e de entrada são omitidos por se tratar de uma experiência 2D simples.
