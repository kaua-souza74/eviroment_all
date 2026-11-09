# Spec — login

## Objetivo

Permitir que a pessoa entre ou inicie cadastro sem perder o clima lúdico e colorido do jogo.

## Estrutura visual

1. Fundo ilustrado de céu azul e vegetação, com desfoque suave e detalhes coloridos nas bordas.
2. Cartão principal centralizado, com moldura externa azul e interior claro, cantos bem arredondados e sombra curta.
3. Faixa laranja de madeira/tecido sobreposta ao topo do cartão, contendo o título **Entrar**.
4. Dentro do cartão: saudação, campos de usuário e senha, opção “Manter conectado” e dois botões com áreas de toque confortáveis.
5. Botão “Voltar” no canto superior esquerdo retorna ao menu.

## Conteúdo e ordem

- Título: `Entrar`
- Mensagem: `Boas-vindas!`
- Campo: `Usuário`
- Campo: `Senha`
- Opção: `Manter conectado`
- Ações: `Criar conta` (secundária) e `Entrar` (primária)

## Comportamento

- Focar o campo de usuário ao abrir, salvo quando o teclado virtual não puder ser exibido automaticamente.
- Campo senha mascarado, com ação para mostrar/ocultar senha.
- A opção “Manter conectado” inicia marcada apenas se a preferência anterior da pessoa for preservada.
- `Entrar` valida campos obrigatórios, mostra carregamento no próprio botão e apresenta erro junto ao campo correspondente.
- `Criar conta` abre o fluxo de cadastro, que fica fora desta primeira spec.
- Campos têm contraste reforçado, rótulos destacados e altura confortável; botões têm leve animação de flutuação.
- Botões verdes e azuis não usam uma moldura externa branca e mantêm o relevo brilhante.
- Remover a nota técnica de protótipo da composição visual.
- A marca aparece em tamanho destacado; o botão `Criar conta` não deve ter sublinhado.
- Folhas caem em baixa velocidade no cenário, com movimento desativado quando a preferência do sistema pede movimento reduzido.
- `Voltar` retorna ao menu principal.

## Estados

- Padrão, foco/teclado aberto, senha visível, enviando, erro de credenciais e campos obrigatórios ausentes.
- Mensagens de erro em texto, além de cor/ícone.
- Em telas estreitas ou com teclado aberto, permitir rolagem do cartão sem esconder a ação principal.

## Critérios de aceite visual

- O cartão permanece centralizado e não encosta nas bordas em 320 px de largura.
- A faixa do título não cobre a saudação nem os campos.
- Os dois botões têm área de toque mínima de 44 px e mantêm hierarquia clara.
- Fundo: `assets/screens/login-background.png`.
