# Design QA — protótipos HTML revisados

**Findings**

- [P2] Comparação visual no navegador permanece bloqueada.
  Location: as quatro páginas HTML em `prototype/`.
  Evidence: a política do navegador integrado bloqueou URLs locais `file://`, e o servidor HTTP local não ficou acessível no ambiente. As revisões de layout e os assets foram feitas no código, mas não há captura renderizada desta atualização para comparar com os anexos recentes.
  Impact: o encaixe final dos botões sem halo, a proporção das placas, a tipografia de vitória e a tela de cadastro ainda precisam de conferência visual no navegador.
  Fix: abrir as quatro páginas em navegador local e revisar login, cadastro, menu e vitória no viewport mobile.

**Open Questions**

- Nenhuma decisão visual pendente; a conferência de renderização está bloqueada pela política de acesso local do navegador integrado.

**Implementation Checklist**

- [x] Criar quatro arquivos HTML independentes para login, cadastro, menu e vitória.
- [x] Validar a sintaxe JavaScript embutida e a existência dos assets referenciados.
- [x] Usar assets PNG dedicados para painéis, placas, botões e ícones.
- [ ] Conferir visualmente as quatro telas em navegador.
- [ ] Comparar as telas com os anexos na mesma escala e estado.

**Evidence**

- Source visual truth: anexos recentes `codex-clipboard-c4650d7e-1ff6-40c1-a740-03c62d6e38c4.png` (botões do login), `codex-clipboard-9601285f-974c-4e2a-9b1f-d85e5d99a8e7.png` (menu atual), `codex-clipboard-5452604f-5df6-4d38-a4a7-391ab71e1748.png` (referência de vitória) e `codex-clipboard-d701ca59-3998-449a-80e1-35a1ff6212ea.png` (vitória atual).
- Implementation screenshot: não capturado; a política do navegador bloqueou as URLs locais.
- Viewport pretendido: 390 × 844 CSS px. Densidade e dimensões renderizadas: indisponíveis sem captura.
- State pretendido: login e cadastro vazios, menu inicial e vitória na fase 15.
- Full-view and focused-region comparison: não realizado porque não houve captura renderizada desta revisão.

**Static checks**

- Quatro scripts JavaScript passaram em `node --check`.
- Os quatro documentos foram processados pelo parser HTML da biblioteca padrão do Python.
- Todos os caminhos locais de imagem referenciados foram encontrados.

**Follow-up Polish**

- Revisar alinhamento, altura das placas, área de toque e animações em 390 × 844 px e em altura reduzida.

final result: blocked

## Novas telas

- Criadas páginas para opções da partida, configurações permanentes, conquistas e ranking, com navegação pelo menu.
- Atualizados os controles de som e música desligados para cobrir o círculo verde com um botão vermelho maior.
- Checagens visuais e funcionais desta revisão não foram executadas a pedido do usuário; devem ser feitas manualmente.

## Missões, loja e acabamento cartunesco

- Adicionadas páginas de missões e loja da floresta, sprites próprios, animação de placas ao entrar na área visível e navegação pelo menu.
- As cinco missões apontam para o bioma correspondente na trilha; a loja usa saldo e compras locais de demonstração.
- Atualizadas as opções da partida para os cinco temas centrais: reciclagem, poluição, 3 Rs, plantio e desmatamento.
- Esta revisão não foi executada nem conferida visualmente; o usuário fará as checagens.

## Trilha de fases e remoção de Opções

- O bioma e o número da fase vêm da trilha.
- Menu/Jogar agora abre o mapa vertical com cinco biomas e dez fases numeradas, em pares de introdução e interação.
- Fase 1 está disponível no protótipo; as demais aparecem bloqueadas até existir gameplay e salvamento de progresso.
- Controles de som/música desligados agora usam o mesmo tamanho circular dos demais; botões azuis/verdes das páginas compartilhadas usam brilho e contorno CSS sem cápsula branca externa.
- Esta atualização não foi executada nem conferida visualmente; as checagens ficam com o usuário.

## Fases educativas interativas

- Criados dez desafios com cinco temas e uma fase introdutória mais uma interativa por tema.
- Conclusões desbloqueiam o próximo número da trilha e atualizam XP, moedas/cristais, missões, conquistas e a pontuação local do ranking.
- Opções foi removida do menu e do protótipo; o tema agora decorre da fase selecionada.
- Cabeçalhos das telas compartilhadas trocam as cordas curtas por rebites ornamentais e acomodam títulos longos sem quebra estranha.
- Esta revisão não foi executada nem conferida visualmente; as checagens ficam com o usuário.
