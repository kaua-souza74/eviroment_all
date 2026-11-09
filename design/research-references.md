# Referências de UI de jogos

Pesquisa consultada para as páginas de Opções, Configurações, Conquistas e Ranking:

- [Stumble Guys — configurações no mobile](https://stumbleguys.helpshift.com/hc/en/4-stumble-guys/faq/74-what-are-the-available-settings-on-mobile/): organiza preferências em categorias como áudio, interface, idioma e entrada. Para Enviroment ALL, mantivemos áudio, idioma e acessibilidade; gráficos avançados e controles foram omitidos por não se aplicarem ao protótipo 2D.
- [Apple Game Center — painel e conquistas](https://developer.apple.com/documentation/gamekit/displaying-the-game-center-dashboard?changes=_7_1&language=objc): usa estados distintos de conquista e filtros de classificação por grupo e período. Isso orientou os estados completa, em progresso e bloqueada, além das abas do ranking.
- [PlayTruffle — rankings em jogos casuais](https://playtruffle.com/insights/mobile-game-design-why-casual-games-pit-you-against-others/): descreve rankings por pontuação e duração limitada. Isso motivou a classificação semanal como visualização inicial.
- A loja e as missões seguem convenções comuns de jogos casuais: cartões por coleção/categoria, recompensas internas, progresso curto e filtros visíveis. A economia aqui é somente ilustrativa; preços e recompensas precisam ser equilibrados com as fases reais antes do Flutter.

## Decisão para Opções e Configurações

Os termos podem se sobrepor em jogos diferentes. Neste protótipo, **Opções** escolhe os parâmetros da próxima sessão (modo, tema, dificuldade e dicas), enquanto **Configurações** controla preferências que permanecem entre sessões (áudio, acessibilidade e idioma).
