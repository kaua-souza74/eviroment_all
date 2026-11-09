# Sistema visual — enviroment_all

## Direção

Jogo casual educativo com linguagem de aventura natural. A interface deve parecer tátil e acolhedora: placas de madeira, cordas, folhas, molduras arredondadas, botões brilhantes e ilustração saturada. A direção combina o menu de placas suspensas, o painel de vitória em madeira e o cartão de login colorido das referências.

## Plataforma e composição

- Base de especificação: mobile em retrato, 390 × 844 px.
- Faixa inicial de adaptação: 320–430 px de largura; manter proporções e respeitar safe areas do dispositivo.
- Compor o conteúdo dentro de uma área segura de 24 px nas laterais e no topo; controles próximos à borda inferior devem considerar a área de gesto.
- Fundo pode sangrar até as bordas. Painéis e controles permanecem dentro da área segura.
- Textos e controles são componentes de interface; fundos ilustrados não devem conter rótulos, botões ou marcas.

## Paleta inicial

Valores de partida para a implementação, ajustáveis após integração com o motor do jogo.

| Token | Cor | Uso |
| --- | --- | --- |
| `forest-900` | `#18331D` | Fundo escuro da tela de vitória |
| `forest-700` | `#315A27` | Folhagem e sombras verdes |
| `leaf-500` | `#72BE35` | Folhas e estados positivos |
| `lime-500` | `#74D92B` | Ação principal positiva |
| `sky-400` | `#70C8EE` | Fundo do menu e detalhes azuis |
| `ocean-500` | `#159ED3` | Ação secundária e contornos |
| `sand-300` | `#EAC779` | Madeira clara e detalhes quentes |
| `cream-100` | `#FFF0C6` | Cartões e painéis |
| `wood-700` | `#8A4E2D` | Contorno, texto e madeira escura |
| `orange-500` | `#F29A34` | Faixas de destaque e recompensa |
| `pink-500` | `#E45F8B` | Mensagem de boas-vindas e feedback |

## Tipografia

- Marca: lettering em caixa alta, volumoso, arredondado e com duas cores, inspirado visualmente pelo título “Cat Tatica” da referência.
- Interface: sans serif arredondada e pesada para títulos/botões; sans serif simples para campos, ajuda e contadores.
- Usar contorno/sombra apenas onde ajude a separar o texto do cenário. Não depender só de cor para comunicar estado.
- O anexo é uma imagem de lettering, não um arquivo de fonte. Para reproduzir a fonte exata, será necessário adicionar o arquivo tipográfico licenciado ao projeto.

## Componentes compartilhados

- **Placa de madeira:** volume ilustrado, borda escura, highlight superior, sombra curta. Usada em ações do menu e títulos de painéis.
- **Botão primário:** forma arredondada, cor verde viva, highlight no topo, borda castanha fina; rótulo branco com peso alto e sombra legível.
- **Botão secundário:** mesmo volume, em azul/ciano.
- **Painel:** interior creme, moldura colorida ou madeira, cantos grandes e contraste suficiente.
- **Ícones de estado:** formas simples, área de toque mínima de 44 × 44 px.

## Acessibilidade e localização

- Rótulos de interface em português brasileiro; o identificador técnico continua `enviroment_all`.
- Alvo de toque mínimo de 44 × 44 px, mesmo quando o desenho do ícone for menor.
- Contraste alto entre rótulo e botão. Não comunicar erro, seleção ou progresso apenas pela cor.
- Campos devem ter rótulos persistentes; placeholders não substituem o nome do campo.
- Prever foco/seleção visível e suporte a teclado virtual nos campos de login.
