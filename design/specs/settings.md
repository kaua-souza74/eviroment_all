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
- A música do menu e das fases usa as faixas em assets/music; música e efeitos de clique podem ser desligados separadamente. A faixa e o ponto atual continuam entre páginas e fases, e retornar à tela inicial seleciona a música do menu. O navegador pode aguardar a primeira interação antes de iniciar a reprodução.
- `Salvar` persiste as preferências; `Padrão` restaura os valores iniciais.

## Referência

A organização de áudio, gráficos, interface e entrada é comum em menus de jogo; neste protótipo, os controles gráficos e de entrada são omitidos por se tratar de uma experiência 2D simples.
