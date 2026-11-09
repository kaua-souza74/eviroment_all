# Spec — loja da floresta

## Objetivo

Dar um lugar lúdico para gastar recompensas internas e preparar o personagem para a aventura.

## Conteúdo e hierarquia

- Placa Loja da floresta, carteira de moedas/cristais, filtros Tudo/Aventura/Plantio e grade ilustrada de itens.
- Itens iniciais: garrafa reutilizável, kit de sementes, mochila exploradora, luvas de plantio, botas de trilha e chapéu guardião.
- Cada cartão mostra arte, utilidade, preço, moeda aceita e estado Comprar/Adquirido.

## Interações

- Moedas começam em 500 e cristais em 50 nesta demonstração.
- Compras e itens adquiridos são gravados apenas em `localStorage` do navegador.
- Saldo insuficiente recebe mensagem de orientação; não há cobrança externa.
- Cartões revelam-se ao rolar, com movimento de placa pendurada; folhas decorativas respeitam a preferência de movimento reduzido.

## Economia a definir antes da versão Flutter

Definir como cada fase recompensa o jogador, quais itens são cosméticos ou funcionais, preços, limites de progressão e sincronização da carteira. Evitar vender vantagem de resposta em um jogo educativo.
