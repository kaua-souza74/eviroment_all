# enviroment_all

Jogo educativo casual sobre boas práticas ambientais, com uma trilha de 15 fases e atividades interativas.

O protótipo HTML foi convertido para Flutter. O app tem estrutura Android e Web; a pasta `prototype/` continua disponível como referência visual e funcional.

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
- [Aplicativo Flutter](lib/main.dart)
- [Dados das fases](lib/game_data.dart)
- [Progresso, preferências e carteira](lib/game_store.dart)
- [Áudio persistente](lib/audio_service.dart)

## Premissas desta versão

- O nome provisório do jogo permanece `enviroment_all`.
- As telas seguem o formato de jogo mobile em retrato, com referência de layout em 390 × 844 px.
- As imagens enviadas orientam a composição e o estilo; o conteúdo textual das telas está em português brasileiro.
- Os fundos gerados são ilustrações sem textos ou controles, para que os elementos de interface possam ser localizados e adaptados no motor do jogo.
- O app abre com a animação da marca, segue para login/cadastro demonstrativo e então para o menu. O menu identifica o perfil ativo e permite sair da conta. O acesso não usa servidor nesta etapa.
- Cada novo login demonstrativo inicia uma sessão limpa: fases, XP, ouro, gemas, itens e recompensas de missão são zerados. As preferências de acessibilidade e áudio permanecem no dispositivo.
- Toda fase concluída concede ouro e gemas, inclusive ao repetir uma fase; o total varia conforme as estrelas obtidas.

## Áudio

As faixas MP3 do menu e das fases ficam em `assets/music/`; o efeito de clique está em `assets/audio/ui_click.wav`. Um player compartilhado mantém a música e sua posição durante a navegação. As fases usam a faixa correspondente ao tema; voltar ao menu inicial troca para a música do menu. Em navegadores, o primeiro toque pode ser necessário para liberar reprodução.

## Executar o app Flutter

Na raiz do projeto:

```powershell
flutter pub get
flutter run -d chrome
```

Para Android, abra o projeto no Android Studio ou use `flutter run` com um emulador/dispositivo conectado. Perfil demonstrativo, progresso, estrelas, carteira, compras e preferências ficam salvos localmente.

O ranking usa dados ilustrativos. Autenticação real e sincronização online ficam para uma etapa posterior.

## Abrir os protótipos

Os HTMLs da pasta `prototype/` permanecem como referência; a implementação ativa está em Flutter.
