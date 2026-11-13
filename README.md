# enviroment_all

Jogo casual de aprendizagem sobre boas práticas ambientais, incluindo reciclagem, descarte correto e impactos da poluição.

Este primeiro pacote registra a direção de marca, as specs das telas de login, vitória e menu, e os assets-base para prototipação.

## Conteúdo

- [Sistema visual](design/specs/design-system.md)
- [Logo](design/specs/brand-logo.md)
- [Login](design/specs/login.md)
- [Cadastro](design/specs/signup.md)
- [Vitória](design/specs/victory.md)
- [Configurações](design/specs/settings.md)
- [Conquistas](design/specs/achievements.md)
- [Ranking](design/specs/ranking.md)
- [Missões](design/specs/missions.md)
- [Loja](design/specs/shop.md)
- [Trilha de fases](design/specs/phases.md)
- [Pesquisa de conteúdo das fases](design/phase-research.md)
- [Menu](design/specs/menu.md)
- [Manifesto de assets](assets/README.md)
- [Protótipo de login](prototype/login.html)
- [Protótipo de cadastro](prototype/signup.html)
- [Protótipo do menu](prototype/menu.html)
- [Protótipo de vitória](prototype/victory.html)
- [Protótipo da trilha](prototype/phases.html)
- [Protótipo das fases interativas](prototype/phase-play.html)
- [Protótipo de missões](prototype/missions.html)
- [Protótipo da loja](prototype/shop.html)

## Premissas desta versão

- O nome provisório do jogo permanece `enviroment_all`.
- As telas seguem o formato de jogo mobile em retrato, com referência de layout em 390 × 844 px.
- As imagens enviadas orientam a composição e o estilo; o conteúdo textual das telas está em português brasileiro.
- Os fundos gerados são ilustrações sem textos ou controles, para que os elementos de interface possam ser localizados e adaptados no motor do jogo.
- Os arquivos em `prototype/` ilustram aparência e fluxo; as fases já têm minijogos locais jogáveis. A implementação final será feita em Flutter.

## Áudio do protótipo

Os efeitos sonoros e a música ambiente são sintetizados no navegador com Web Audio. Por restrições de reprodução automática, o navegador pode aguardar a primeira interação antes de tocar.

## Abrir os protótipos

Abra qualquer arquivo HTML da pasta `prototype/` no navegador. As quinze fases interativas e o progresso rodam localmente no navegador; autenticação, sincronização online e serviços de ranking ainda não estão conectados.
