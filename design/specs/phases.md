# Spec — trilha de fases

## Objetivo

Transformar o avanço das fases em um mapa vertical de aventura: a pessoa percorre a trilha, conhece o tema de cada bioma e vê os próximos desafios conforme rola a página.

## Direção visual

- Mapa vertical cartunesco inspirado na leitura de trilha de jogos casuais: caminho sinuoso, nós circulares numerados, estrelas, cadeados e pequenas recompensas entre fases.
- Cinco placas de bioma usam cores e símbolos próprios e preservam a madeira, o brilho e as cores da identidade Enviroment All. Uma expedição bônus fecha a trilha.
- Cada bioma recebe uma fase introdutória e uma fase principal, além de um desafio bônus temático. As placas entram com movimento curto ao rolar a página; folhas, placas, itens e feedbacks têm animações sutis.
- O movimento respeita a opção de reduzir animações.

## Fases propostas

| Números | Tema | Desafio | Mecânica |
| --- | --- | --- | --- |
| 1–2 | Reciclagem | Preparar materiais; separar seis itens na esteira | Cenários com tentativas / arrastar materiais às cores |
| 3–4 | Poluição | Descobrir como a chuva leva poluentes; salvar a baía | Cenários / arrastar resíduos para uma rede |
| 5–6 | Os 3 Rs | Prioridade dos 3 Rs; oficina de novos usos | Cenários / ligar objetos a usos seguros |
| 7–8 | Plantio | Escolher espécie e local; ordenar os cuidados | Cenários / arrastar etapas para posições |
| 9–10 | Floresta | Impactos da perda da mata; decisões para restauração | Cenários com explicações e novas tentativas |
| 11 | Reciclagem bônus | Auditoria da cooperativa | Selecionar materiais que exigem cuidado ou destino próprio |
| 12 | Poluição bônus | Chuva na cidade | Ligar fontes de poluição a prevenções adequadas |
| 13 | Os 3 Rs bônus | Carrinho consciente | Montar um kit dentro do orçamento e evitar descartáveis |
| 14 | Plantio bônus | Muda resiliente | Ajustar controles de luz e água e observar a resposta |
| 15 | Floresta bônus | Corredor verde | Ligar ações de proteção a trechos do habitat |

## Minijogos

- Fases de descoberta oferecem distratores plausíveis. Uma resposta incorreta explica o raciocínio e deixa a pessoa tentar de novo sem revelar a escolha correta.
- Os minijogos aceitam arraste e soltar; no celular, tocar em um item e depois no destino oferece a mesma ação.
- A triagem mostra somente as cores nos coletores, sem escrever a associação material/cor na resposta. O conteúdo lembra que a aceitação varia por cidade.
- A limpeza envia os itens para uma rede animada e traz orientação para não recolher materiais perigosos na vida real.
- A auditoria, o carrinho com limite de recursos e os controles de cuidado da muda oferecem ritmos distintos. Os valores da muda são explicitamente fictícios e não substituem orientação de cultivo local.
- A fase de corredor associa decisões a partes diferentes de um habitat. As fases dão feedback explicativo e novas tentativas; erros afetam estrelas, mas não bloqueiam a conclusão.
- A conclusão abre a tela de vitória existente, com fase, tema e recompensa dinâmicos. O navegador registra XP, estrelas, desbloqueio e carteira; missões, conquistas, loja e ranking leem esse progresso local.

As afirmações educativas e seus limites estão documentados em [Pesquisa de conteúdo das fases](../phase-research.md).

## Estados do protótipo

- Fase 1 aparece disponível; concluir uma fase abre a próxima até a fase 15.
- As 15 fases aparecem no mapa divididas nos cinco biomas e na expedição bônus. Os nós refletem bloqueio, disponibilidade, conclusão e estrelas.
- Os cartões/biomas entram na tela progressivamente conforme a rolagem, preservando uma página longa de mapa.

## Navegação

Menu → Trilha de desafios → selecionar fase → minijogo temático → tela de vitória → próxima fase e atualização de missões, conquistas, ranking e carteira.
