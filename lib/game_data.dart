enum ActivityType { quiz, sorting, cleanup, reuse, sequence, audit, runoff, basket, garden, habitat }

class QuestionData {
  const QuestionData(this.icon, this.prompt, this.answers);
  final String icon;
  final String prompt;
  final List<AnswerData> answers;
}

class AnswerData {
  const AnswerData(this.text, this.explanation, {this.correct = false});
  final String text;
  final String explanation;
  final bool correct;
}

class PairData {
  const PairData(this.icon, this.name, this.target, this.reason);
  final String icon;
  final String name;
  final String target;
  final String reason;
}

class TargetData {
  const TargetData(this.id, this.label, this.icon);
  final String id;
  final String label;
  final String icon;
}

class PhaseData {
  const PhaseData({
    required this.id,
    required this.theme,
    required this.themeId,
    required this.world,
    required this.icon,
    required this.creature,
    required this.title,
    required this.goal,
    required this.lesson,
    required this.type,
    this.questions = const [],
    this.pairs = const [],
    this.targets = const [],
    this.sequence = const [],
    this.cleanupItems = const [],
    this.auditItems = const [],
    this.budgetGroups = const [],
    this.budget = 0,
    this.lightRange = const [5, 7],
    this.waterRange = const [3, 5],
  });
  final int id;
  final String theme;
  final String themeId;
  final String world;
  final String icon;
  final String creature;
  final String title;
  final String goal;
  final String lesson;
  final ActivityType type;
  final List<QuestionData> questions;
  final List<PairData> pairs;
  final List<TargetData> targets;
  final List<String> sequence;
  final List<PairData> cleanupItems;
  final List<PairData> auditItems;
  final List<List<BudgetOption>> budgetGroups;
  final int budget;
  final List<int> lightRange;
  final List<int> waterRange;
}

class BudgetOption {
  const BudgetOption(this.icon, this.label, this.cost, this.good);
  final String icon;
  final String label;
  final int cost;
  final bool good;
}

class ThemeDataGame {
  const ThemeDataGame(this.id, this.title, this.icon, this.world, this.firstLevel, this.lastLevel, this.spriteIndex, this.blurb);
  final String id;
  final String title;
  final String icon;
  final String world;
  final int firstLevel;
  final int lastLevel;
  final int spriteIndex;
  final String blurb;
}

const gameThemes = <ThemeDataGame>[
  ThemeDataGame('recycling', 'Reciclagem', '♻️', 'Vale da Reciclagem', 1, 2, 0, 'Prepare materiais e descubra como a triagem funciona.'),
  ThemeDataGame('pollution', 'Água sem poluição', '💧', 'Baía das Águas Claras', 3, 4, 1, 'Investigue o caminho dos resíduos até os rios.'),
  ThemeDataGame('three-rs', 'Os 3 Rs', '🔁', 'Montanhas dos 3 Rs', 5, 6, 2, 'Repense escolhas, reduza descartes e encontre novos usos.'),
  ThemeDataGame('planting', 'Plantio', '🌱', 'Jardins da Esperança', 7, 8, 3, 'Escolha o local certo e cuide de cada muda.'),
  ThemeDataGame('forest', 'Florestas vivas', '🌳', 'Floresta dos Guardiões', 9, 10, 5, 'Conheça impactos e caminhos para restaurar habitats.'),
  ThemeDataGame('bonus', 'Expedição bônus', '🧭', 'Trilha dos Guardiões', 11, 15, 4, 'Desafios extras misturam tudo o que você aprendeu.'),
];

const phases = <PhaseData>[
  PhaseData(id: 1, theme: 'Reciclagem', themeId: 'recycling', world: 'Vale da Reciclagem', icon: '♻️', creature: '🐸', title: 'Primeiros passos', goal: 'Uma cooperativa recebe materiais variados. Leia o cenário antes de decidir o que fazer.', lesson: 'Símbolos ajudam a identificar materiais, mas não garantem que a coleta local aceite cada embalagem. A limpeza e as regras da cidade também contam.', type: ActivityType.quiz, questions: [
    QuestionData('📦', 'A caixa está limpa em uma parte e engordurada em outra. Qual é a melhor decisão?', [AnswerData('Separar a parte limpa se a coleta local aceitar e consultar o destino da parte suja.', 'Gordura pode contaminar papel limpo. A aceitação depende do serviço da cidade.', correct: true), AnswerData('Colocar a caixa inteira junto com papel limpo.', 'Restos de alimento podem contaminar o lote reciclável.'), AnswerData('Molhar a caixa para soltar a gordura.', 'Papel molhado também dificulta a triagem.')]),
    QuestionData('🧴', 'Uma embalagem tem líquido dentro. O que fazer antes de separar?', [AnswerData('Esvaziar e seguir a orientação local para a embalagem.', 'Esvaziar a embalagem ajuda a manter os materiais limpos.', correct: true), AnswerData('Fechar cheia para não vazar.', 'Líquidos restantes podem contaminar outros materiais.'), AnswerData('Amassar com líquido dentro.', 'Esvazie primeiro e confira a regra da coleta.')]),
    QuestionData('🔎', 'O rótulo tem símbolo de reciclagem. Sua cidade aceita aquele material?', [AnswerData('Conferir a lista do serviço local.', 'O símbolo não confirma que toda coleta aceite o item.', correct: true), AnswerData('Assumir que qualquer coleta aceita.', 'A infraestrutura varia de cidade para cidade.'), AnswerData('Misturar com tudo para descobrir depois.', 'Itens não aceitos podem contaminar os materiais triados.')]),
  ]),
  PhaseData(id: 2, theme: 'Reciclagem', themeId: 'recycling', world: 'Vale da Reciclagem', icon: '♻️', creature: '🐸', title: 'Esteira de triagem', goal: 'Leve cada item ao coletor correspondente. Toque em um item e depois no destino, ou arraste.', lesson: 'No padrão brasileiro de cores, azul é papel, vermelho é plástico, verde é vidro e amarelo é metal. A coleta local pode ter regras específicas.', type: ActivityType.sorting, targets: const [TargetData('paper', 'Azul', '🔵'), TargetData('plastic', 'Vermelho', '🔴'), TargetData('glass', 'Verde', '🟢'), TargetData('metal', 'Amarelo', '🟡'), TargetData('organic', 'Orgânico', '🍃'), TargetData('residual', 'Rejeito', '⚫')], pairs: const [PairData('📦', 'Caixa limpa e seca', 'paper', 'Papel limpo e seco pode seguir para a triagem de papel.'), PairData('🧴', 'Frasco plástico vazio', 'plastic', 'Plásticos são associados ao coletor vermelho no padrão de cores.'), PairData('🍾', 'Pote de vidro inteiro', 'glass', 'Vidros inteiros são associados ao coletor verde.'), PairData('🥫', 'Lata de alumínio vazia', 'metal', 'Metais são associados ao coletor amarelo.'), PairData('🍌', 'Casca de banana', 'organic', 'Resíduos orgânicos podem virar composto quando há estrutura adequada.'), PairData('🍕', 'Papel engordurado', 'residual', 'Gordura pode contaminar papel limpo; consulte o destino local da parte suja.')]),
  PhaseData(id: 3, theme: 'Poluição', themeId: 'pollution', world: 'Baía das Águas Claras', icon: '💧', creature: '🐟', title: 'O que chega ao rio?', goal: 'Investigue como chuva, lixo e produtos derramados podem afetar a água.', lesson: 'A chuva pode levar lixo, óleo e outros poluentes das ruas para bueiros, córregos e rios. Evitar que cheguem ao chão ajuda a proteger os ecossistemas aquáticos.', type: ActivityType.quiz, questions: [
    QuestionData('🌧️', 'Depois de uma chuva forte, o que pode ser carregado até o córrego?', [AnswerData('Lixo e óleo derramado.', 'A enxurrada pode levar contaminantes da rua até a drenagem.', correct: true), AnswerData('Somente nuvens.', 'A água da chuva percorre ruas e pode carregar materiais.'), AnswerData('Apenas folhas de árvores.', 'Folhas não são a única coisa que a água pode transportar.')]),
    QuestionData('🛢️', 'Qual é uma atitude segura para óleo de cozinha usado?', [AnswerData('Guardar fechado e procurar um ponto de coleta.', 'Óleo não deve ser despejado no ralo; procure orientação local.', correct: true), AnswerData('Despejar no ralo.', 'Óleo pode prejudicar tubulações e ambientes aquáticos.'), AnswerData('Jogar num bueiro.', 'Bueiros podem conduzir poluentes para rios.')]),
    QuestionData('🐠', 'Como ajudar a proteger um riacho?', [AnswerData('Manter lixo e produtos químicos longe da drenagem.', 'Bueiros não são locais de descarte.', correct: true), AnswerData('Deixar o lixo perto da margem.', 'Vento e chuva podem levar resíduos para a água.'), AnswerData('Lavar tinta no bueiro.', 'Tintas e químicos precisam de destino adequado.')]),
  ]),
  PhaseData(id: 4, theme: 'Poluição', themeId: 'pollution', world: 'Baía das Águas Claras', icon: '💧', creature: '🐟', title: 'Resgate da baía', goal: 'A maré está levando resíduos. Arraste os itens seguros até a rede para limpar a margem.', lesson: 'Na vida real, nunca toque em vidro quebrado, químicos ou objetos desconhecidos. Avise um adulto ou uma equipe responsável.', type: ActivityType.cleanup, cleanupItems: const [PairData('🥤', 'Copo descartável', '', ''), PairData('🧴', 'Garrafa plástica', '', ''), PairData('🛍️', 'Sacola plástica', '', ''), PairData('🥫', 'Lata vazia', '', ''), PairData('🧃', 'Embalagem vazia', '', ''), PairData('🧻', 'Papel de embalagem', '', '')]),
  PhaseData(id: 5, theme: 'Os 3 Rs', themeId: 'three-rs', world: 'Montanhas dos 3 Rs', icon: '🔁', creature: '🦊', title: 'Escolhas conscientes', goal: 'Descubra como pequenas escolhas podem reduzir a quantidade de resíduos.', lesson: 'A prioridade é evitar gerar resíduos; depois vêm reduzir, reutilizar e reciclar. Reciclar é importante, mas prevenir o descarte vem primeiro.', type: ActivityType.quiz, questions: [
    QuestionData('🧃', 'O que pode evitar um copo descartável no passeio?', [AnswerData('Levar uma garrafa reutilizável.', 'Usar algo que já temos evita criar um novo resíduo.', correct: true), AnswerData('Comprar dois copos.', 'Comprar mais itens não reduz o descarte.'), AnswerData('Jogar o copo no chão.', 'O descarte no ambiente causa poluição.')]),
    QuestionData('🔁', 'Qual ordem começa pela prioridade mais alta?', [AnswerData('Não gerar, reduzir, reutilizar, reciclar.', 'Prevenir a geração vem antes das demais etapas.', correct: true), AnswerData('Reciclar, reutilizar, reduzir.', 'Reduzir e reutilizar são prioridades anteriores à reciclagem.'), AnswerData('Descartar, reciclar, reduzir.', 'O descarte vem depois de prevenir, reutilizar e reciclar.')]),
    QuestionData('🫙', 'Qual é um exemplo de reutilização?', [AnswerData('Usar um pote limpo para guardar sementes.', 'Reutilizar prolonga a vida útil de um item seguro.', correct: true), AnswerData('Comprar um pote novo para cada uso.', 'Isso aumenta o consumo de embalagens.'), AnswerData('Descartar um pote inteiro.', 'Um pote em boas condições ainda pode ser útil.')]),
  ]),
  PhaseData(id: 6, theme: 'Os 3 Rs', themeId: 'three-rs', world: 'Montanhas dos 3 Rs', icon: '🔁', creature: '🦊', title: 'Oficina de reuso', goal: 'Ligue cada objeto seguro a uma nova utilidade. Arraste ou toque nos dois cartões.', lesson: 'Reutilizar prolonga a vida útil. Considere a limpeza, a segurança e se a nova função combina com o material.', type: ActivityType.reuse, targets: const [TargetData('pencils', 'Organizar lápis', '✏️'), TargetData('cleaning', 'Pano de limpeza', '🧽'), TargetData('notes', 'Folha de rascunho', '📝'), TargetData('planter', 'Vaso protegido', '🪴')], pairs: const [PairData('🫙', 'Pote inteiro e limpo', 'pencils', 'Um pote sem rachaduras pode guardar lápis.'), PairData('👕', 'Camiseta limpa e sem uso', 'cleaning', 'Tecido limpo pode virar pano de limpeza.'), PairData('📄', 'Folha impressa de um lado', 'notes', 'O lado vazio pode ser usado para rascunho.'), PairData('🥫', 'Lata estável com borda protegida', 'planter', 'Um recipiente protegido pode virar vaso. Peça ajuda adulta para fazer furos.')]),
  PhaseData(id: 7, theme: 'Plantio', themeId: 'planting', world: 'Jardins da Esperança', icon: '🌱', creature: '🐝', title: 'O segredo da semente', goal: 'Antes de plantar, pense nas necessidades da espécie e no lugar onde ela vai crescer.', lesson: 'Cada espécie precisa de condições próprias de luz, água e solo. Restauração deve considerar o ambiente local e orientação de viveiros ou equipes da região.', type: ActivityType.quiz, questions: [
    QuestionData('🌳', 'O que vem antes de plantar uma árvore em uma área natural?', [AnswerData('Escolher uma espécie adequada ao local.', 'Espécie e ambiente precisam combinar.', correct: true), AnswerData('Plantar qualquer espécie em qualquer lugar.', 'Uma escolha inadequada pode prejudicar o ecossistema.'), AnswerData('Cobrir a muda com plástico.', 'Plástico não substitui o cuidado correto com a planta.')]),
    QuestionData('☀️', 'Como cuidar da água para uma muda?', [AnswerData('Observar a necessidade da espécie e do solo.', 'Excesso e falta de água podem prejudicar a planta.', correct: true), AnswerData('Usar o máximo de água sempre.', 'A quantidade adequada depende do local e da planta.'), AnswerData('Nunca verificar o solo.', 'Observar o solo ajuda a perceber o que a muda precisa.')]),
    QuestionData('🦋', 'Por que consultar um projeto de restauração local?', [AnswerData('Para escolher espécies e cuidados apropriados ao ecossistema.', 'Orientação local ajuda a proteger a biodiversidade.', correct: true), AnswerData('Para plantar qualquer espécie exótica.', 'A escolha deve priorizar as espécies adequadas ao lugar.'), AnswerData('Para dispensar cuidados futuros.', 'Plantas e áreas restauradas precisam de acompanhamento.')]),
  ]),
  PhaseData(id: 8, theme: 'Plantio', themeId: 'planting', world: 'Jardins da Esperança', icon: '🌱', creature: '🐝', title: 'Jardim em ação', goal: 'Arraste os cuidados para os espaços e monte uma sequência responsável de plantio.', lesson: 'Um plantio cuidadoso começa entendendo o local e a espécie. Depois, a muda é acomodada e acompanhada conforme as condições do ambiente.', type: ActivityType.sequence, sequence: const ['Escolher espécie e local com orientação', 'Preparar o local e o solo', 'Acomodar a muda com cuidado', 'Regar conforme a necessidade e acompanhar']),
  PhaseData(id: 9, theme: 'Desmatamento', themeId: 'forest', world: 'Floresta dos Guardiões', icon: '🌳', creature: '🦜', title: 'Quando a mata some', goal: 'Veja o que pode mudar quando uma floresta é desmatada ou degradada.', lesson: 'A perda de habitat pode fragmentar áreas naturais, afetar a biodiversidade, alterar ciclos da água e favorecer erosão. As consequências dependem do local e das causas.', type: ActivityType.quiz, questions: [
    QuestionData('🦜', 'O que pode acontecer quando o habitat é destruído?', [AnswerData('Animais e plantas podem perder abrigo e alimento.', 'A perda de habitat ameaça a biodiversidade.', correct: true), AnswerData('Todas as espécies se mudam sem impacto.', 'Muitas espécies não conseguem se deslocar ou se adaptar.'), AnswerData('O solo fica sempre mais protegido.', 'A remoção da vegetação pode aumentar a erosão.')]),
    QuestionData('🌧️', 'A retirada de árvores também pode afetar...', [AnswerData('O solo e os ciclos da água.', 'Florestas ajudam a proteger o solo e fazem parte do ciclo da água.', correct: true), AnswerData('Somente a cor das folhas.', 'Os efeitos vão além da aparência.'), AnswerData('Nada além da paisagem.', 'Ecossistemas conectam água, solo e seres vivos.')]),
    QuestionData('🪺', 'Qual atitude pode ajudar a evitar mais perda de floresta?', [AnswerData('Proteger áreas naturais e apoiar o uso responsável dos recursos.', 'Proteção e uso responsável ajudam a conservar habitats.', correct: true), AnswerData('Abrir trilhas fora das áreas permitidas.', 'Isso pode degradar a vegetação e perturbar a fauna.'), AnswerData('Remover a vegetação das margens.', 'A vegetação ciliar protege margens e habitats.')]),
  ]),
  PhaseData(id: 10, theme: 'Desmatamento', themeId: 'forest', world: 'Floresta dos Guardiões', icon: '🌳', creature: '🦜', title: 'Guardiões da floresta', goal: 'Tome decisões que ajudam a recuperar um habitat degradado.', lesson: 'Recuperar uma floresta exige compreender o ecossistema, proteger a área e acompanhar o processo com as comunidades e equipes locais.', type: ActivityType.quiz, questions: [
    QuestionData('🌿', 'Qual é um bom começo para recuperar uma área?', [AnswerData('Entender as condições locais e proteger o espaço.', 'Conhecer o lugar ajuda a escolher ações apropriadas.', correct: true), AnswerData('Plantar qualquer espécie em fileiras.', 'A restauração precisa respeitar o ecossistema local.'), AnswerData('Deixar a área vulnerável ao fogo e ao pisoteio.', 'Proteger o local ajuda as plantas a crescer.')]),
    QuestionData('🪴', 'Como escolher plantas para restauração?', [AnswerData('Usar espécies adequadas ao ecossistema local.', 'A espécie precisa combinar com solo, clima e habitat.', correct: true), AnswerData('Escolher pela flor sem olhar o ambiente.', 'Aparência sozinha não indica que a planta é apropriada.'), AnswerData('Usar apenas plantas de outro bioma.', 'Espécies inadequadas podem desequilibrar o ambiente.')]),
    QuestionData('🦋', 'Depois de plantar, o trabalho acabou?', [AnswerData('Não. É preciso observar e cuidar da recuperação.', 'Monitoramento ajuda a perceber problemas e acompanhar a área.', correct: true), AnswerData('Sim. Nunca mais é preciso observar.', 'A restauração é um processo, não uma ação de um dia.'), AnswerData('Sim. Basta publicar uma foto.', 'A recuperação depende de cuidado contínuo.')]),
  ]),
  PhaseData(id: 11, theme: 'Reciclagem bônus', themeId: 'recycling', world: 'Cooperativa dos Guardiões', icon: '🔍', creature: '🐸', title: 'Auditoria da cooperativa', goal: 'Marque os itens que precisam de destino especial ou cuidado antes do descarte.', lesson: 'Pilhas, baterias, eletrônicos e vidro quebrado exigem destinos específicos. Não os coloque na coleta comum; procure orientação e peça ajuda para itens cortantes.', type: ActivityType.audit, auditItems: const [PairData('🔋', 'Pilha usada', '', ''), PairData('📱', 'Celular antigo', '', ''), PairData('🍾', 'Pote inteiro, vazio e limpo', '', ''), PairData('📦', 'Papelão limpo e seco', '', ''), PairData('🪟', 'Vidro quebrado sem proteção', '', '')]),
  PhaseData(id: 12, theme: 'Poluição bônus', themeId: 'pollution', world: 'Cidade da Chuva', icon: '🌧️', creature: '🐟', title: 'Chuva na cidade', goal: 'Ligue cada risco a uma prevenção que interrompe o caminho da poluição até o rio.', lesson: 'A drenagem urbana pode levar água e contaminantes aos córregos. Prevenir derramamentos e descartar corretamente ajuda a proteger os rios.', type: ActivityType.runoff, targets: const [TargetData('oil', 'Conter e recolher com orientação', '🧰'), TargetData('litter', 'Descartar em local adequado', '🗑️'), TargetData('paint', 'Levar a resíduo especial', '♻️'), TargetData('soil', 'Proteger vegetação e solo', '🌿')], pairs: const [PairData('🛢️', 'Óleo derramado na rua', 'oil', 'Conter o derramamento evita que a chuva o carregue.'), PairData('🛍️', 'Lixo perto do bueiro', 'litter', 'O lixo deve ser colocado em um destino adequado.'), PairData('🎨', 'Sobra de tinta', 'paint', 'Tintas não devem ser despejadas em ralos ou bueiros.'), PairData('🏗️', 'Solo exposto em uma obra', 'soil', 'Proteção do solo reduz sedimentos na água.')]),
  PhaseData(id: 13, theme: 'Os 3 Rs bônus', themeId: 'three-rs', world: 'Acampamento consciente', icon: '🎒', creature: '🦊', title: 'Carrinho consciente', goal: 'Monte um kit de passeio que caiba no orçamento e evite descartáveis desnecessários.', lesson: 'Planejar o que levar e aproveitar itens que você já tem reduz compras e embalagens. Orçamento do jogo é uma medida fictícia.', type: ActivityType.basket, budget: 18, budgetGroups: const [
    [BudgetOption('🥤', 'Garrafa reutilizável', 4, true), BudgetOption('🧃', 'Pacote individual', 7, false), BudgetOption('💧', 'Garrafa descartável', 6, false)],
    [BudgetOption('🍎', 'Fruta levada de casa', 3, true), BudgetOption('🍬', 'Lanche embalado', 6, false), BudgetOption('🥪', 'Lanche em pote', 5, true)],
    [BudgetOption('🎒', 'Mochila que já tenho', 0, true), BudgetOption('🛍️', 'Sacola nova', 5, false), BudgetOption('🧺', 'Bolsa reutilizada', 2, true)],
  ]),
  PhaseData(id: 14, theme: 'Plantio bônus', themeId: 'planting', world: 'Estufa da Muda', icon: '🌱', creature: '🐝', title: 'Muda resiliente', goal: 'Ajuste luz e água e observe a resposta da muda fictícia da missão.', lesson: 'Este exercício usa valores fictícios. Na vida real, as necessidades variam por espécie, clima, solo e local.', type: ActivityType.garden, lightRange: const [6, 8], waterRange: const [3, 5]),
  PhaseData(id: 15, theme: 'Floresta bônus', themeId: 'forest', world: 'Corredor Verde', icon: '🦜', creature: '🦜', title: 'Corredor da vida', goal: 'Conecte ações de proteção às partes do habitat que precisam de cuidado.', lesson: 'Áreas conectadas podem ajudar espécies a se deslocar entre habitats. Cada projeto deve considerar a paisagem e as espécies locais.', type: ActivityType.habitat, targets: const [TargetData('river', 'Margem do rio', '💧'), TargetData('trees', 'Árvores nativas', '🌳'), TargetData('wildlife', 'Passagem de fauna', '🦜'), TargetData('community', 'Cuidado comunitário', '🤝')], pairs: const [PairData('🌿', 'Recuperar vegetação ciliar', 'river', 'A vegetação protege as margens e oferece abrigo.'), PairData('🌱', 'Plantar espécies adequadas ao local', 'trees', 'Espécies locais apoiam o ecossistema.'), PairData('🛤️', 'Conectar dois trechos de mata', 'wildlife', 'Conexões podem facilitar o deslocamento da fauna.'), PairData('👥', 'Planejar com moradores e equipes locais', 'community', 'A conservação funciona melhor quando considera quem vive no lugar.')]),
];

PhaseData phaseById(int id) => phases.firstWhere((phase) => phase.id == id, orElse: () => phases.first);

String musicForPhase(int id) {
  if (id <= 2) return 'Bottles_In_Flight.mp3';
  if (id <= 4) return 'Where_the_River_Bends.mp3';
  if (id <= 6) return 'The_Final_Tally.mp3';
  if (id <= 8) return 'Beneath_the_Canopy.mp3';
  if (id <= 10) return 'Sentry_of_the_Ancient_Vale.mp3';
  return 'Path_Through_the_Ferns.mp3';
}
