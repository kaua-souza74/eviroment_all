# Referências de UI de jogos

Pesquisa consultada para Configurações, Conquistas e Ranking:

- [Stumble Guys — configurações no mobile](https://stumbleguys.helpshift.com/hc/en/4-stumble-guys/faq/74-what-are-the-available-settings-on-mobile/): organiza preferências em categorias como áudio, interface, idioma e entrada. Para Enviroment ALL, mantivemos áudio, idioma e acessibilidade; gráficos avançados e controles foram omitidos por não se aplicarem ao protótipo 2D.
- [Apple Game Center — painel e conquistas](https://developer.apple.com/documentation/gamekit/displaying-the-game-center-dashboard?changes=_7_1&language=objc): usa estados distintos de conquista e filtros de classificação por grupo e período. Isso orientou os estados completa, em progresso e bloqueada, além das abas do ranking.
- [PlayTruffle — rankings em jogos casuais](https://playtruffle.com/insights/mobile-game-design-why-casual-games-pit-you-against-others/): descreve rankings por pontuação e duração limitada. Isso motivou a classificação semanal como visualização inicial.
- A loja e as missões seguem convenções comuns de jogos casuais: cartões por coleção/categoria, recompensas internas, progresso curto e filtros visíveis. A economia aqui é somente ilustrativa; preços e recompensas precisam ser equilibrados com as fases reais antes do Flutter.

## Organização atual das preferências

Configurações continuam sendo preferências persistentes (áudio, acessibilidade e idioma). A escolha temática pertence ao mapa/fase, por isso a tela separada de Opções foi removida para evitar repetir a seleção do bioma.
