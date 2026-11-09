# Spec — cadastro

## Objetivo

Permitir que uma pessoa crie um perfil para acompanhar suas fases e recompensas.

## Estrutura visual

- Fundo de natureza iluminado, igual ao login.
- Cartão azul e creme com faixa laranja superior e a marca do jogo acima do cartão.
- Campos em sequência, com rótulos contrastantes, campos mais altos e espaço para teclado virtual: nome, e-mail, senha e confirmação da senha.
- Botão verde alto e link secundário para voltar ao login, ambos contidos na área segura do cartão.
- Botão “Voltar” no canto superior esquerdo retorna ao login.

## Conteúdo e comportamento

- Título: `Criar conta`; mensagem: `Entre para a aventura!`.
- Validar campos obrigatórios, formato do e-mail, senha mínima de seis caracteres e correspondência entre senhas.
- Mensagens de erro devem indicar o campo a corrigir e mover o foco para ele.
- Após envio demonstrativo, confirmar o cadastro e seguir para o menu. Não criar conta real nesta etapa.
- Botão de cadastro tem uma animação curta de flutuação; folhas caem lentamente ao fundo e param com a preferência de movimento reduzido.
- “Entre para a aventura!” permanece em uma linha legível, afastada da faixa do título; o link para login tem respiro depois do botão principal.
- O botão usa brilho e contorno de madeira, sem halo branco ao redor.

## Adaptação

- Formulário pode rolar com o teclado aberto em telas pequenas.
- Alvos de toque mínimos de 44 × 44 px para ação principal e link.
- Fundo compartilhado com login: `assets/screens/login-background.png`.
