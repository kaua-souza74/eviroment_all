# Manifesto de assets

## Incluídos

| Arquivo | Papel | Fundo | Referência |
| --- | --- | --- | --- |
| `brand/enviroment-all-logo.png` | Wordmark do jogo | Transparente | Lettering de “Cat Tatica” |
| `screens/login-background.png` | Cenário-base do login | Ilustrado | Céu colorido e interface amigável |
| `screens/victory-background.png` | Cenário-base da vitória | Ilustrado | Mata escura e folhas de enquadramento |
| `screens/menu-background.png` | Cenário-base do menu | Ilustrado | Céu, cipós e vegetação na base |
| `ui/login-card.png` | Moldura do cartão de login | Transparente | Referência de login |
| `ui/menu-plank.png` | Placa reutilizável do menu | Transparente | Referência de menu |
| `ui/button-green.png` | Botão primário (versão anterior) | Transparente | Mantido como rascunho, não usado pelos HTMLs |
| `ui/button-blue.png` | Botão secundário (versão anterior) | Transparente | Mantido como rascunho, não usado pelos HTMLs |
| `ui/button-green-v2.png` | Botão primário sem halo claro | Transparente | Revisão do cadastro/login |
| `ui/button-blue-v2.png` | Botão secundário sem halo claro | Transparente | Revisão do cadastro/login |
| `ui/victory-board.png` | Placa de vitória com estrelas | Transparente | Referência de vitória |
| `ui/victory-board-rope-v2.png` | Nova placa de vitória com cordas contínuas desde o topo do canvas | Transparente | Revisão da tela de vitória |
| `ui/victory-controls.png` | Controles de som, música, ajuda e repetir | Transparente | Referência de vitória |
| `ui/reward-icons.png` | Moeda de folha e cristal azul | Transparente | Referência de recompensas |
| `ui/falling-leaf.png` | Folha individual usada nas animações de cenário | Transparente | Cenários de menu, login, cadastro e vitória |
| `ui/sound-off-red.png` | Estado vermelho de som desligado | Transparente | Controle de áudio da vitória |
| `ui/music-off-red.png` | Estado vermelho de música desligada | Transparente | Controle de áudio da vitória |
| `ui/sound-off-red-v2.png` | Botão de som desligado vermelho cobrindo toda a área circular | Transparente | Controle de áudio da vitória |
| `ui/music-off-red-v2.png` | Botão de música desligada vermelho cobrindo toda a área circular | Transparente | Controle de áudio da vitória |
| `ui/victory-rope-extension.png` | Trecho de corda para completar a suspensão até o topo | Transparente | Ajuste da tela de vitória |
| `ui/environment-mission-badges.png` | Sprite sheet 3×2 de emblemas ambientais para as trilhas | Transparente | Reciclagem, poluição, 3 Rs, plantio, recuperação florestal |
| `ui/eco-shop-items.png` | Sprite sheet 3×2 de itens cartunescos para a loja | Transparente | Garrafa, sementes, mochila, luvas, botas e chapéu |

## Notas de integração

- Fundos foram pensados para retrato mobile e deixam espaço de composição para controles feitos no motor do jogo.
- Usar os PNGs sem redesenhar ou esticar; preencher a tela com `cover` e conferir o corte nos extremos da faixa de largura descrita na spec.
- Madeira, botões, textos, estrelas, recompensas e ícones funcionais devem ser componentes separados para suportar animação, toque e localização.
- O logo é uma imagem pronta para esta etapa. A fonte exata não está incluída porque o anexo é uma imagem e não um arquivo tipográfico.
- As duas folhas de sprites usam células em grade 3×2; os nomes `sprite-1` até `sprite-6` identificam a leitura da esquerda para a direita, de cima para baixo.
