(() => {
  const phases = {
    1: { theme: "Reciclagem", themeId: "recycling", world: "Vale da Reciclagem", icon: "♻️", creature: "🐸", title: "Primeiros passos", goal: "Leia o cenário e escolha como preparar os materiais antes da coleta.", lesson: "A Resolução CONAMA 275 associa azul a papel, vermelho a plástico, verde a vidro e amarelo a metal. A regra de cores é uma referência; os materiais aceitos dependem do serviço de cada cidade.", type: "quiz", questions: [
      { icon: "📦", prompt: "A cooperativa aceita papel limpo e embalagens vazias. Uma caixa tem fundo engordurado e uma garrafa ainda tem líquido. Como preparar o lote?", answers: [{ text: "Separar o trecho limpo se aceito localmente, esvaziar a garrafa e conferir a regra da coleta", ok: true }, { text: "Colocar tudo junto porque o símbolo da embalagem confirma a coleta", why: "Símbolos não garantem aceitação local, e restos podem contaminar materiais limpos." }, { text: "Molhar a caixa e fechar a garrafa cheia para evitar vazamentos", why: "Papel molhado e líquidos restantes podem atrapalhar a triagem; esvazie e siga a orientação local." }] },
      { icon: "🍕", prompt: "Uma caixa tem uma parte seca e outra engordurada. Qual é a decisão mais cuidadosa?", answers: [{ text: "Separar a parte limpa se a coleta local aceitar; consultar a regra para a parte suja", ok: true }, { text: "Colocar a caixa inteira junto com papel limpo", why: "Gordura e restos de alimento podem contaminar materiais limpos; confira a orientação local." }, { text: "Molhar a caixa toda antes de separar", why: "Papel molhado não é uma boa condição para a triagem; consulte a coleta local." }] },
      { icon: "🔎", prompt: "O rótulo tem símbolo de reciclagem, mas você não sabe se sua cidade recolhe esse material. O que fazer?", answers: [{ text: "Conferir a lista do serviço local antes de colocar no coletor", ok: true }, { text: "Assumir que qualquer símbolo garante coleta na cidade", why: "O símbolo não garante que todo serviço local aceite o item." }, { text: "Misturar com os recicláveis para descobrir depois", why: "Itens não aceitos podem contaminar o lote; confirme a regra local primeiro." }] }
    ] },
    2: { theme: "Reciclagem", themeId: "recycling", world: "Vale da Reciclagem", icon: "♻️", creature: "🐸", title: "Esteira de triagem", goal: "Arraste cada material para o coletor correto. Leia o item: alguns parecem recicláveis, mas precisam de cuidado.", lesson: "Esvazie embalagens e siga a regra local. Papel engordurado, vidro quebrado e resíduos perigosos precisam de orientações próprias.", type: "match", matchTitle: "Esteira de triagem", matchHint: "Arraste o item até o coletor. No celular, toque no item e depois no coletor.", targets: ["paper", "plastic", "glass", "metal", "organic", "residual"], items: [
      { icon: "📦", name: "Caixa de papelão limpa e seca", target: "paper", reason: "Papelão limpo e seco pode seguir para a triagem de papel." },
      { icon: "🧴", name: "Frasco plástico vazio", target: "plastic", reason: "Plástico é associado ao coletor vermelho no padrão nacional; a coleta local pode variar." },
      { icon: "🍾", name: "Pote de vidro inteiro", target: "glass", reason: "O vidro é associado ao coletor verde no padrão de cores." },
      { icon: "🥫", name: "Lata de alumínio vazia", target: "metal", reason: "Metais são associados ao coletor amarelo." },
      { icon: "🍌", name: "Casca de banana", target: "organic", reason: "Orgânicos podem ser compostados onde houver estrutura adequada." },
      { icon: "📦", name: "Caixa de pizza com fundo engordurado", target: "residual", reason: "Gordura pode contaminar papel limpo. Separe a parte seca se a coleta aceitar e consulte o destino local da parte suja." }
    ] },
    3: { theme: "Poluição", themeId: "pollution", world: "Baía das Águas Claras", icon: "💧", creature: "🐟", title: "O que vai para o rio?", goal: "Investigue como resíduos e outras substâncias podem chegar à água.", lesson: "A chuva pode carregar lixo, óleo, sedimentos e outros poluentes das ruas para bueiros, córregos e rios. Evitar que cheguem ao chão e à drenagem protege os ecossistemas aquáticos.", type: "quiz", questions: [
      { icon: "🌧️", prompt: "Depois de uma chuva forte, o que pode ser levado da rua ao córrego?", answers: [{ text: "Lixo e óleo derramado", ok: true }, { text: "Somente nuvens", why: "A água da chuva pode arrastar contaminantes e lixo até a drenagem e os rios." }, { text: "Apenas folhas de árvores", why: "A enxurrada pode transportar muitos materiais, como lixo e óleo, não apenas folhas." }] },
      { icon: "🛢️", prompt: "O que fazer com óleo de cozinha usado?", answers: [{ text: "Despejar no ralo", why: "Óleo não deve ir para o ralo; procure a orientação de coleta da sua cidade." }, { text: "Guardar fechado e procurar ponto de coleta", ok: true }, { text: "Jogar num bueiro", why: "Bueiros levam água para a drenagem e podem conduzir poluentes a rios." }] },
      { icon: "🐠", prompt: "Qual atitude ajuda a proteger um riacho?", answers: [{ text: "Deixar lixo perto da margem", why: "Vento e chuva podem levar esse lixo para a água." }, { text: "Manter lixo e produtos químicos longe da drenagem", ok: true }, { text: "Lavar tinta no bueiro", why: "Bueiros não são locais de descarte; siga as orientações locais para resíduos químicos." }] }
    ] },
    4: { theme: "Poluição", themeId: "pollution", world: "Baía das Águas Claras", icon: "💧", creature: "🐟", title: "Resgate do rio", goal: "A maré está levando resíduos. Arraste os itens seguros para a rede antes que cheguem ao rio.", lesson: "Resíduos no ambiente podem ser carregados pela chuva até córregos e rios. Na vida real, não toque em vidro quebrado, produtos químicos nem objetos desconhecidos: avise um adulto ou a equipe responsável.", type: "cleanup", items: [
      { icon: "🥤", name: "Copo descartável", left: 12, top: 18 }, { icon: "🧴", name: "Garrafa plástica", left: 43, top: 55 }, { icon: "🛍️", name: "Sacola plástica", left: 73, top: 17 }, { icon: "🥫", name: "Lata", left: 81, top: 66 }, { icon: "🧃", name: "Embalagem", left: 28, top: 72 }, { icon: "🧻", name: "Papel de embalagem", left: 57, top: 27 }
    ] },
    5: { theme: "Os 3 Rs", themeId: "three-rs", world: "Montanhas dos 3 Rs", icon: "📦", creature: "🦊", title: "Escolhas conscientes", goal: "Conheça a ordem de prioridade que reduz a geração de resíduos.", lesson: "A política brasileira de resíduos prioriza não gerar, reduzir, reutilizar e reciclar, nessa ordem. Reciclar é importante, mas evitar o descarte quando possível vem antes.", type: "quiz", questions: [
      { icon: "🧃", prompt: "Antes de escolher um descartável, qual atitude pode evitar resíduo?", answers: [{ text: "Levar uma garrafa reutilizável", ok: true }, { text: "Comprar duas embalagens", why: "Comprar apenas o necessário e optar por itens reutilizáveis pode evitar resíduos." }, { text: "Jogar a embalagem no chão", why: "O descarte no ambiente causa poluição; procure reduzir e descartar corretamente." }] },
      { icon: "🔁", prompt: "Qual sequência começa pela opção de maior prioridade na gestão de resíduos?", answers: [{ text: "Reciclar, reutilizar, reduzir", why: "A prioridade começa antes: não gerar e reduzir vêm antes de reutilizar e reciclar." }, { text: "Não gerar, reduzir, reutilizar, reciclar", ok: true }, { text: "Descartar, reciclar, reduzir", why: "A disposição final fica depois das opções de prevenção, reutilização e reciclagem." }] },
      { icon: "🛍️", prompt: "Qual exemplo mostra reutilização?", answers: [{ text: "Usar um pote limpo para guardar sementes", ok: true }, { text: "Comprar um pote novo para cada uso", why: "Reutilizar é prolongar a vida útil do objeto antes de descartá-lo." }, { text: "Jogar um pote inteiro no lixo", why: "Se estiver em boas condições, ele pode ter outro uso seguro." }] }
    ] },
    6: { theme: "Os 3 Rs", themeId: "three-rs", world: "Montanhas dos 3 Rs", icon: "📦", creature: "🦊", title: "Oficina de reuso", goal: "Arraste cada objeto limpo e seguro para uma nova utilidade. Pense no material e no estado do item.", lesson: "Reutilizar prolonga a vida útil de um objeto. Considere limpeza, segurança e se a nova função combina com o material.", type: "match", matchTitle: "Bancada de invenções", matchHint: "Ligue cada objeto a um reuso possível. Toque nos dois cartões se não puder arrastar.", targets: ["pencils", "cleaning", "notes", "planter"], targetLabels: { pencils: "Organizar lápis", cleaning: "Pano de limpeza", notes: "Folha de rascunho", planter: "Vaso com drenagem" }, targetIcons: { pencils: "✏️", cleaning: "🧽", notes: "📝", planter: "🪴" }, items: [
      { icon: "🫙", name: "Pote de vidro inteiro e limpo", target: "pencils", reason: "Um pote inteiro pode organizar lápis; reutilize vidro somente sem rachaduras." },
      { icon: "👕", name: "Camiseta limpa, sem uso", target: "cleaning", reason: "Tecido limpo pode virar pano de limpeza antes do descarte." },
      { icon: "📄", name: "Folha impressa de um lado", target: "notes", reason: "O lado vazio pode servir para rascunho." },
      { icon: "🥫", name: "Lata estável, limpa e com borda protegida", target: "planter", reason: "Com bordas protegidas e drenagem adequada, ela pode virar um pequeno vaso. Faça furos apenas com ajuda adulta." }
    ] },
    7: { theme: "Plantio", themeId: "planting", world: "Jardins da Esperança", icon: "🌱", creature: "🐝", title: "O segredo da semente", goal: "Descubra como escolher uma espécie e um local adequados para plantar.", lesson: "Cada espécie tem necessidades próprias de luz, água e solo. Para recuperar a natureza, a escolha deve considerar o ambiente local; procure orientação de viveiros, projetos ou equipes da sua região.", type: "quiz", questions: [
      { icon: "🌳", prompt: "O que vem antes de plantar uma árvore em uma área natural?", answers: [{ text: "Escolher espécie adequada ao local", ok: true }, { text: "Plantar qualquer espécie em qualquer lugar", why: "Espécies e locais têm necessidades diferentes; a escolha deve combinar com o ambiente." }, { text: "Cobrir a muda com plástico", why: "Plástico não substitui solo e cuidado adequado; procure orientação de plantio local." }] },
      { icon: "☀️", prompt: "O que ajuda uma muda a crescer?", answers: [{ text: "Condições adequadas de luz, água e nutrientes", ok: true }, { text: "Deixá-la sem observar", why: "Mudas precisam das condições adequadas à espécie e acompanhamento após o plantio." }, { text: "Usar mais água sempre", why: "Excesso também pode prejudicar. A necessidade varia com espécie, solo e clima." }] },
      { icon: "🦋", prompt: "Por que consultar um projeto local de restauração?", answers: [{ text: "Para escolher espécies e cuidados adequados ao ecossistema", ok: true }, { text: "Para plantar somente plantas ornamentais exóticas", why: "A restauração precisa considerar o ecossistema local e as espécies apropriadas." }, { text: "Para dispensar o cuidado depois de plantar", why: "Mudas precisam de acompanhamento; os cuidados variam com o local." }] }
    ] },
    8: { theme: "Plantio", themeId: "planting", world: "Jardins da Esperança", icon: "🌱", creature: "🐝", title: "Jardim em ação", goal: "Arraste os passos para os espaços vazios e monte a ordem de um plantio cuidadoso.", lesson: "Um bom plantio começa por entender o local e a espécie. Depois, a muda precisa ser instalada com cuidado e acompanhada; água e manutenção dependem do clima, do solo e da planta.", type: "sequence", steps: [
      { icon: "🔎", text: "Escolher espécie e local com orientação adequada" }, { icon: "🪴", text: "Preparar o local e o solo" }, { icon: "🌱", text: "Acomodar a muda com cuidado" }, { icon: "💧", text: "Regar conforme a necessidade e acompanhar" }
    ] },
    9: { theme: "Desmatamento", themeId: "deforestation", world: "Floresta dos Guardiões", icon: "🌳", creature: "🦜", title: "Quando a mata some", goal: "Entenda o que pode mudar quando uma floresta é desmatada ou degradada.", lesson: "Desmatamento e degradação podem fragmentar habitats, afetar a biodiversidade, alterar ciclos da água e favorecer erosão do solo. As consequências variam conforme o lugar e as causas.", type: "quiz", questions: [
      { icon: "🦜", prompt: "O que pode acontecer quando o habitat de uma floresta é destruído?", answers: [{ text: "Animais e plantas podem perder abrigo e alimento", ok: true }, { text: "Todas as espécies se mudam sem impacto", why: "A perda e a fragmentação de habitats ameaçam a biodiversidade." }, { text: "O solo fica sempre mais protegido", why: "A retirada da cobertura vegetal pode aumentar a erosão do solo." }] },
      { icon: "🌧️", prompt: "A remoção de árvores também pode afetar...?", answers: [{ text: "Solo e ciclos da água", ok: true }, { text: "Somente a cor das folhas", why: "A degradação florestal pode influenciar solo, água e habitats." }, { text: "Nada além da paisagem", why: "Florestas se relacionam com biodiversidade, água, solo e comunidades." }] },
      { icon: "🪺", prompt: "Qual atitude ajuda a evitar mais perda de floresta?", answers: [{ text: "Proteger áreas naturais e apoiar uso responsável dos recursos", ok: true }, { text: "Abrir trilhas fora das áreas permitidas", why: "Respeitar áreas protegidas e as orientações locais reduz danos aos habitats." }, { text: "Remover vegetação da margem do rio", why: "A vegetação ciliar ajuda a proteger margens e habitats; siga orientação técnica local." }] }
    ] },
    10: { theme: "Desmatamento", themeId: "restoration", world: "Floresta dos Guardiões", icon: "🌳", creature: "🦜", title: "Guardiões da floresta", goal: "Tome decisões que apoiam a recuperação de um habitat degradado.", lesson: "Recuperar florestas exige mais que plantar árvores: é preciso entender o ecossistema, proteger a área e acompanhar a recuperação junto de comunidades e profissionais locais.", type: "quiz", questions: [
      { icon: "🌿", prompt: "Para recuperar uma área, qual escolha é um bom começo?", answers: [{ text: "Entender as condições locais e proteger a área", ok: true }, { text: "Plantar qualquer espécie em fileiras", why: "A restauração depende das condições do lugar e de espécies adequadas." }, { text: "Deixar a área vulnerável a pisoteio e fogo", why: "Proteger as mudas e o local é importante para a recuperação." }] },
      { icon: "🪴", prompt: "Como escolher plantas para a restauração?", answers: [{ text: "Com espécies adequadas ao ecossistema local", ok: true }, { text: "Pelo tamanho da flor, sem olhar o local", why: "Espécies precisam combinar com o solo, clima e ecossistema da área." }, { text: "Usando só plantas de outro bioma", why: "A escolha deve considerar espécies apropriadas ao ambiente local." }] },
      { icon: "🦋", prompt: "Depois de plantar, o trabalho acabou?", answers: [{ text: "Não: é preciso acompanhar e cuidar da recuperação", ok: true }, { text: "Sim, nunca mais é preciso observar", why: "Acompanhar as mudas e o local ajuda a perceber problemas e apoiar a recuperação." }, { text: "Sim, basta publicar uma foto", why: "A recuperação ecológica é um processo; monitoramento e cuidado importam." }] }
    ] },
    11: { theme: "Reciclagem", themeId: "recycling", world: "Vale da Reciclagem", icon: "♻️", creature: "🐸", title: "Auditoria da cooperativa", goal: "Revise uma caixa de materiais e marque os itens que não devem seguir na coleta comum.", lesson: "Pilhas, baterias, eletrônicos e vidro quebrado exigem cuidado e destinos específicos. Não coloque materiais perigosos na esteira da coleta seletiva; procure um ponto adequado e peça ajuda para itens cortantes.", type: "audit", items: [
      { icon: "🔋", name: "Pilha usada", hazard: true }, { icon: "📱", name: "Celular antigo", hazard: true }, { icon: "🍾", name: "Pote inteiro, vazio e limpo", hazard: false }, { icon: "📦", name: "Papelão limpo e seco", hazard: false }, { icon: "🪟", name: "Vidro quebrado sem embalagem", hazard: true }
    ] },
    12: { theme: "Poluição", themeId: "pollution", world: "Baía das Águas Claras", icon: "💧", creature: "🐟", title: "Chuva na cidade", goal: "Ligue cada fonte de poluição a uma prevenção que realmente interrompe o caminho até o rio.", lesson: "A drenagem urbana pode conduzir água e poluentes rapidamente aos córregos. Prevenir o derramamento e descartar cada resíduo no local correto ajuda a proteger as águas; bueiros não são lixeiras.", type: "match", matchTitle: "Missão: antes da chuva", matchHint: "Arraste cada problema para uma prevenção. No celular, toque nos dois cartões.", targets: ["oil", "litter", "paint", "soil"], targetLabels: { oil: "Conter e recolher o óleo com orientação", litter: "Descartar o lixo em local adequado", paint: "Guardar e levar a resíduo especial", soil: "Manter vegetação e solo protegidos" }, targetIcons: { oil: "🧰", litter: "🗑️", paint: "♻️", soil: "🌿" }, items: [
      { icon: "🛢️", name: "Óleo derramado na rua", target: "oil", reason: "Conter o derramamento e buscar orientação evita que a chuva leve o óleo ao bueiro." },
      { icon: "🥤", name: "Embalagens perto do bueiro", target: "litter", reason: "Recolher e descartar corretamente evita que o lixo entre na drenagem." },
      { icon: "🪣", name: "Sobra de tinta", target: "paint", reason: "Tinta não deve ser despejada no ralo ou bueiro; siga a orientação local de resíduos." },
      { icon: "⛰️", name: "Terra solta após obra", target: "soil", reason: "Controlar sedimentos e proteger o solo ajuda a evitar que a enxurrada carregue terra." }
    ] },
    13: { theme: "Os 3 Rs", themeId: "three-rs", world: "Montanhas dos 3 Rs", icon: "📦", creature: "🦊", title: "Carrinho consciente", goal: "Monte um kit de passeio com limite de 10 folhas. Escolha uma solução para cada situação sem criar descarte desnecessário.", lesson: "Planejar compras e levar itens reutilizáveis pode evitar embalagens de uso único. Considere o que já possui, a segurança e as condições reais de uso; não existe uma escolha única para todas as pessoas.", type: "basket", budget: 10, categories: [
      { title: "Para beber", options: [{ icon: "🥤", label: "Usar garrafa reutilizável que já tenho", cost: 0, good: true }, { icon: "🧃", label: "Comprar bebida em embalagem individual", cost: 3, good: false }] },
      { title: "Para o lanche", options: [{ icon: "🍎", label: "Fruta solta da estação", cost: 4, good: true }, { icon: "🍪", label: "Lanche com várias embalagens", cost: 3, good: false }] },
      { title: "Para carregar", options: [{ icon: "🛍️", label: "Levar sacola resistente que já tenho", cost: 0, good: true }, { icon: "🛍️", label: "Pedir sacola nova para um item", cost: 2, good: false }] }
    ] },
    14: { theme: "Plantio", themeId: "planting", world: "Jardins da Esperança", icon: "🌱", creature: "🐝", title: "Muda resiliente", goal: "Ajuste luz e água para a muda desta missão. Leia o cartão da espécie e observe como ela reage.", lesson: "Necessidades de luz e água variam por espécie, clima, solo e estágio de crescimento. Os controles desta fase representam apenas uma espécie fictícia; no mundo real, consulte orientação local e observe a planta.", type: "garden", needs: { light: [6, 8], water: [3, 5] } },
    15: { theme: "Desmatamento", themeId: "restoration", world: "Floresta dos Guardiões", icon: "🌳", creature: "🦜", title: "Corredor verde", goal: "Reconecte três pontos do mapa para ajudar a fauna a circular entre áreas de floresta.", lesson: "Corredores ecológicos podem conectar habitats, mas o desenho precisa respeitar a paisagem, espécies, propriedades e comunidades locais. Proteger áreas existentes e planejar com especialistas é essencial.", type: "match", matchTitle: "Reconstrua a passagem", matchHint: "Leve cada cuidado ao trecho do mapa que ele protege. Toque nos cartões se estiver no celular.", targets: ["stream", "gap", "edge"], targetLabels: { stream: "Margem do riacho", gap: "Entre as duas matas", edge: "Borda da floresta" }, targetIcons: { stream: "💧", gap: "🌳", edge: "🍃" }, items: [
      { icon: "🌿", name: "Manter a vegetação ciliar", target: "stream", reason: "A vegetação das margens protege o riacho e oferece habitat; a largura e o manejo dependem das regras locais." },
      { icon: "🌳", name: "Reconectar fragmentos com espécies locais", target: "gap", reason: "Planejar uma conexão com espécies adequadas pode facilitar o deslocamento da fauna." },
      { icon: "🚧", name: "Evitar novas clareiras e perturbações", target: "edge", reason: "Proteger as bordas reduz novas pressões sobre a floresta e os habitats." }
    ] }
  };

  const bins = {
    paper: { label: "Azul", color: "paper", icon: "" },
    plastic: { label: "Vermelho", color: "plastic", icon: "" },
    glass: { label: "Verde", color: "glass", icon: "" },
    metal: { label: "Amarelo", color: "metal", icon: "" },
    organic: { label: "Marrom", color: "organic", icon: "" },
    residual: { label: "Cinza", color: "residual", icon: "" }
  };
  const params = new URLSearchParams(window.location.search);
  const level = Math.min(15, Math.max(1, Number(params.get("fase") || 1)));
  const phase = phases[level];
  const root = document.querySelector("#phaseRoot");
  const area = document.querySelector("#activityArea");
  const feedback = document.querySelector("#activityFeedback");
  let correct = 0;
  let mistakes = 0;
  let phaseCompleting = false;
  let completedTasks = 0;
  let questionIndex = 0;
  let sortIndex = 0;
  let sequenceIndex = 0;
  let cleanupCount = 0;
  let selectedMatchIndex = null;
  const matchPlaced = new Set();
  const totalTasks = phase.questions?.length || phase.items?.length || phase.steps?.length || phase.categories?.length || (phase.type === "garden" ? 2 : 1);

  let existingProgress = {};
  try { existingProgress = JSON.parse(localStorage.getItem("enviromentAll.progress") || "{}"); } catch { existingProgress = {}; }
  if (!phase) {
    window.location.replace("phases.html");
    return;
  }
  const highestCompleted = Math.max(0, ...(Array.isArray(existingProgress.completedLevels) ? existingProgress.completedLevels : []).map(Number));
  const unlockedThrough = Math.min(15, Math.max(1, Number(existingProgress.unlockedThrough || 1), highestCompleted + 1));
  if (level > unlockedThrough) {
    window.location.replace("phases.html");
    return;
  }
  document.title = `Fase ${level}: ${phase.title} · Enviroment All`;
  root.dataset.theme = phase.themeId;
  document.querySelector("#worldIcon").textContent = phase.icon;
  document.querySelector("#worldName").textContent = phase.theme.toUpperCase();
  document.querySelector("#phasePosition").textContent = `FASE ${level} / 15`;
  document.querySelector("#phaseTitle").textContent = phase.title;
  document.querySelector("#phaseGoal").textContent = phase.goal;
  document.querySelector("#lessonText").textContent = phase.lesson;
  document.querySelector("#sceneCaption").textContent = phase.world;
  document.querySelector("#sceneCreature").textContent = phase.creature;
  document.querySelector("#xpCount").textContent = `⭐ ${Number(existingProgress.xp || 0).toLocaleString("pt-BR")} XP`;
  document.querySelector("#phaseEyebrow").textContent = phase.type === "quiz" ? "MISSÃO DE DESCOBERTA" : "MISSÃO INTERATIVA";
  document.querySelector("#phaseScene").className = `phase-scene scene-${phase.themeId}`;
  if ([10, 15].includes(level)) document.querySelector("#phaseScene").classList.add("scene-restoration");
  renderProgress();
  if (phase.type === "quiz") renderQuiz();
  if (phase.type === "sort") renderSort();
  if (phase.type === "cleanup") renderCleanup();
  if (phase.type === "sequence") renderSequence();
  if (phase.type === "match") renderMatch();
  if (phase.type === "audit") renderAudit();
  if (phase.type === "basket") renderBasket();
  if (phase.type === "garden") renderGarden();

  function renderProgress() {
    const percent = Math.round((completedTasks / totalTasks) * 100);
    document.querySelector("#taskProgress").style.width = `${percent}%`;
  }
  function showFeedback(text, wrong = false) {
    feedback.textContent = text;
    feedback.classList.toggle("is-wrong", wrong);
    feedback.hidden = !text;
  }
  function heading(text, hint) {
    const row = document.createElement("div");
    row.className = "activity-heading";
    const title = document.createElement("strong");
    title.textContent = text;
    const info = document.createElement("small");
    info.textContent = hint;
    row.append(title, info);
    return row;
  }
  function questionCard(icon, prompt) {
    const card = document.createElement("div");
    card.className = "question-card";
    const art = document.createElement("span");
    art.className = "question-art";
    art.setAttribute("aria-hidden", "true");
    art.textContent = icon;
    const copy = document.createElement("strong");
    copy.className = "question-copy";
    copy.textContent = prompt;
    card.append(art, copy);
    return card;
  }
  function makeButton(text, className, action) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = className;
    button.textContent = text;
    button.addEventListener("click", action);
    return button;
  }
  function actionButton(text, handler) {
    const button = makeButton(text, "game-button game-button--green next-question", handler);
    area.append(button);
    return button;
  }
  function renderQuiz() {
    showFeedback("");
    area.replaceChildren(heading(phase.type === "quiz" && [6,10].includes(level) ? "Escolha de guardião" : "Desafio de descoberta", `${questionIndex + 1} / ${phase.questions.length}`));
    const q = phase.questions[questionIndex];
    area.append(questionCard(q.icon, q.prompt));
    const grid = document.createElement("div");
    grid.className = "answer-grid";
    q.answers.forEach((answer) => {
      const button = makeButton(answer.text, "answer-button", () => {
        if (answer.ok) {
          window.EnviromentAudio?.play("correct");
          grid.querySelectorAll("button").forEach((choice) => { choice.disabled = true; });
          correct++;
          completedTasks++;
          button.classList.add("is-correct");
          showFeedback("Isso! " + (answer.why || q.success || "Essa escolha ajuda a cuidar do ambiente."));
          renderProgress();
          actionButton(questionIndex + 1 === phase.questions.length ? "Ver resultado" : "Próximo desafio", () => {
            questionIndex++;
            if (questionIndex >= phase.questions.length) completePhase();
            else renderQuiz();
          });
        } else {
          window.EnviromentAudio?.play("wrong");
          mistakes++;
          button.classList.add("is-wrong");
          showFeedback((answer.why || q.correction || "Releia o cenário e tente outra combinação.") + " Você ainda pode tentar de novo.", true);
          window.setTimeout(() => button.classList.remove("is-wrong"), 420);
        }
      });
      grid.append(button);
    });
    area.append(grid);
  }
  function renderSort() {
    phase.items.forEach((item) => { item.target = item.bin; });
    phase.targets = phase.bins;
    phase.matchTitle = "Esteira de triagem";
    phase.matchHint = "Arraste cada material para a cor certa. No celular, toque no item e depois no coletor.";
    renderMatch();
  }
  function renderCleanup() {
    showFeedback("");
    area.replaceChildren(heading("Limpe a margem", `${cleanupCount} / ${phase.items.length} itens`));
    const counter = document.createElement("p");
    counter.className = "cleanup-counter";
    counter.textContent = "Arraste os resíduos para a rede. No celular, toque no item e depois na rede.";
    area.append(counter);
    const board = document.createElement("div");
    board.className = "cleanup-board";
    board.dataset.selected = "-1";
    phase.items.forEach((item) => {
      const piece = makeButton(item.icon, "cleanup-target", () => {
        if (piece.classList.contains("is-collected")) return;
        board.querySelectorAll(".cleanup-target").forEach((node) => node.classList.toggle("is-selected", node === piece));
        board.dataset.selected = String(Array.from(board.querySelectorAll(".cleanup-target")).indexOf(piece));
      });
      piece.draggable = true;
      piece.dataset.cleanupItem = item.name;
      piece.style.left = `${item.left}%`;
      piece.style.top = `${item.top}%`;
      piece.setAttribute("aria-label", `Arraste ${item.name} para a rede`);
      piece.addEventListener("dragstart", (event) => event.dataTransfer.setData("text/plain", String(Array.from(board.querySelectorAll(".cleanup-target")).indexOf(piece))));
      board.append(piece);
    });
    const net = makeButton(`🧺  Rede da equipe · ${cleanupCount}/${phase.items.length}`, "cleanup-net", () => collectTrash(Number(board.dataset.selected)));
    net.addEventListener("dragover", (event) => event.preventDefault());
    net.addEventListener("drop", (event) => { event.preventDefault(); collectTrash(Number(event.dataTransfer.getData("text/plain"))); });
    board.append(net);
    area.append(board);
    area.insertAdjacentHTML("beforeend", '<p class="safety-note">Na vida real, não toque em objetos desconhecidos ou perigosos. Peça ajuda.</p>');
    function collectTrash(index) {
      const piece = board.querySelectorAll(".cleanup-target")[index];
      if (!piece || piece.classList.contains("is-collected")) return;
      window.EnviromentAudio?.play("drop");
      piece.classList.add("is-collected");
      piece.setAttribute("aria-label", `${piece.dataset.cleanupItem} removido`);
      cleanupCount++;
      correct++;
      completedTasks = cleanupCount;
      board.dataset.selected = "-1";
      net.textContent = `🧺  Rede da equipe · ${cleanupCount}/${phase.items.length}`;
      counter.textContent = `${cleanupCount} de ${phase.items.length} resíduos retirados. Agora a chuva não os leva até o rio.`;
      renderProgress();
      showFeedback("Boa! Na vida real, peça ajuda para fazer a limpeza com segurança.");
      if (cleanupCount === phase.items.length) actionButton("Proteger a baía", completePhase);
    }
  }
  function renderSequence() {
    showFeedback("");
    area.replaceChildren(heading("Monte o plantio", `${sequenceIndex} / ${phase.steps.length} passos`));
    area.append(questionCard("🪴", "Arraste cada etapa para a próxima posição. No celular, toque em uma etapa e depois em um espaço."));
    const slots = document.createElement("div");
    slots.className = "sequence-slots";
    const tray = document.createElement("div");
    tray.className = "sequence-list";
    const order = [2, 0, 3, 1];
    order.forEach((stepIndex) => {
      const step = phase.steps[stepIndex];
      const button = makeButton(`${step.icon}  ${step.text}`, "sequence-button", () => {
        tray.querySelectorAll(".sequence-button").forEach((node) => node.classList.toggle("is-selected", node === button));
        tray.dataset.selected = String(stepIndex);
      });
      button.draggable = true;
      button.dataset.step = String(stepIndex);
      button.addEventListener("dragstart", (event) => event.dataTransfer.setData("text/plain", String(stepIndex)));
      tray.append(button);
    });
    phase.steps.forEach((step, slotIndex) => {
      const slot = makeButton(`✦  ${slotIndex + 1}. Solte uma etapa aqui`, "sequence-slot", () => placeStep(Number(tray.dataset.selected), slotIndex, slot));
      slot.dataset.slot = String(slotIndex);
      slot.addEventListener("dragover", (event) => event.preventDefault());
      slot.addEventListener("drop", (event) => { event.preventDefault(); placeStep(Number(event.dataTransfer.getData("text/plain")), slotIndex, slot); });
      slots.append(slot);
    });
    area.append(slots, tray);
    function placeStep(stepIndex, slotIndex, slot) {
      if (!Number.isInteger(stepIndex) || stepIndex < 0 || !tray.querySelector(`[data-step="${stepIndex}"]`) || slot.classList.contains("is-done")) return;
      if (stepIndex !== slotIndex) {
        window.EnviromentAudio?.play("wrong");
        mistakes++;
        slot.classList.add("is-wrong");
        showFeedback("Observe o ciclo completo: conhecer o local, preparar, plantar e acompanhar.", true);
        window.setTimeout(() => slot.classList.remove("is-wrong"), 420);
        return;
      }
      const source = tray.querySelector(`[data-step="${stepIndex}"]`);
      source?.remove();
      window.EnviromentAudio?.play("correct");
      slot.classList.add("is-done");
      slot.textContent = `${slotIndex + 1}. ${step.icon} ${step.text}`;
      slot.disabled = true;
      tray.dataset.selected = "";
      sequenceIndex++;
      correct++;
      completedTasks = sequenceIndex;
      renderProgress();
      showFeedback("Etapa encaixada! Um plantio responsável começa com contexto e continua com acompanhamento.");
      document.querySelector(".activity-heading small").textContent = `${sequenceIndex} / ${phase.steps.length}`;
      if (sequenceIndex === phase.steps.length) actionButton("Ver jardim pronto", completePhase);
    }
  }
  function renderMatch() {
    showFeedback("");
    selectedMatchIndex = null;
    matchPlaced.clear();
    const targets = phase.targets || [];
    area.replaceChildren(heading(phase.matchTitle || "Conecte as ideias", "0 / " + phase.items.length));
    const hint = document.createElement("p");
    hint.className = "sort-progress";
    hint.textContent = phase.matchHint || "Arraste cada item até o destino certo. Toque nos dois cartões para jogar sem arrastar.";
    const board = document.createElement("div");
    board.className = "matching-board";
    const sourceColumn = document.createElement("div");
    sourceColumn.className = "match-sources";
    const targetGrid = document.createElement("div");
    targetGrid.className = "match-targets" + (phase.themeId === "recycling" ? " match-targets--bins" : "");
    const targetNodes = new Map();
    targets.forEach((id) => {
      const bin = bins[id];
      const label = phase.targetLabels?.[id] || bin?.label || id;
      const icon = phase.targetIcons?.[id] || bin?.icon || "✦";
      const button = makeButton(icon + " " + label, "match-target " + (bin ? "bin-" + bin.color : ""), () => {
        if (selectedMatchIndex !== null) placeItem(selectedMatchIndex, id);
      });
      button.dataset.target = id;
      button.addEventListener("dragover", (event) => event.preventDefault());
      button.addEventListener("drop", (event) => { event.preventDefault(); placeItem(Number(event.dataTransfer.getData("text/plain")), id); });
      targetNodes.set(id, button);
      targetGrid.append(button);
    });
    phase.items.forEach((item, index) => {
      const button = makeButton(item.icon + "  " + item.name, "match-piece", () => {
        if (matchPlaced.has(index)) return;
        selectedMatchIndex = index;
        sourceColumn.querySelectorAll(".match-piece").forEach((node) => node.classList.toggle("is-selected", node === button));
      });
      button.draggable = true;
      button.dataset.matchItem = String(index);
      button.addEventListener("dragstart", (event) => event.dataTransfer.setData("text/plain", String(index)));
      sourceColumn.append(button);
    });
    board.append(sourceColumn, targetGrid);
    area.append(hint, board);
    if (phase.themeId === "recycling" && level === 2) area.insertAdjacentHTML("beforeend", '<p class="sorting-note">Padrão de cores no Brasil; confirme o que sua coleta local aceita.</p>');
    function placeItem(index, targetId) {
      const item = phase.items[index];
      if (!item || matchPlaced.has(index)) return;
      if (item.target !== targetId) {
        window.EnviromentAudio?.play("wrong");
        mistakes++;
        const target = targetNodes.get(targetId);
        target?.classList.add("is-wrong");
        showFeedback("Esse destino não combina com as pistas do material. Releia o item e tente outro.", true);
        window.setTimeout(() => target?.classList.remove("is-wrong"), 430);
        return;
      }
      matchPlaced.add(index);
      window.EnviromentAudio?.play("drop");
      correct++;
      completedTasks = matchPlaced.size;
      selectedMatchIndex = null;
      sourceColumn.querySelector('[data-match-item="' + index + '"]')?.remove();
      sourceColumn.querySelectorAll(".match-piece").forEach((node) => node.classList.remove("is-selected"));
      const target = targetNodes.get(targetId);
      target?.classList.add("is-matched");
      if (target && !bins[targetId]) {
        const badge = document.createElement("span");
        badge.className = "match-count";
        badge.textContent = String(Number(target.dataset.matched || 0) + 1);
        target.dataset.matched = badge.textContent;
        target.querySelector(".match-count")?.remove();
        target.append(badge);
      }
      renderProgress();
      showFeedback(item.reason || "Material encaminhado para o destino adequado.");
      const count = document.querySelector(".activity-heading small");
      if (count) count.textContent = matchPlaced.size + " / " + phase.items.length;
      if (matchPlaced.size === phase.items.length) actionButton("Concluir missão", completePhase);
    }
  }
  function renderAudit() {
    showFeedback("");
    area.replaceChildren(heading("Inspeção da cooperativa", "0 / " + phase.items.length + " selecionados"));
    area.append(questionCard("🔎", "Selecione todos os itens que exigem destino ou cuidado especial antes da esteira comum."));
    const grid = document.createElement("div");
    grid.className = "audit-grid";
    phase.items.forEach((item, index) => {
      const card = makeButton(item.icon + "  " + item.name, "audit-item", () => {
        card.classList.toggle("is-selected");
        card.setAttribute("aria-pressed", String(card.classList.contains("is-selected")));
        const selected = grid.querySelectorAll(".audit-item.is-selected").length;
        document.querySelector(".activity-heading small").textContent = selected + " / " + phase.items.length + " selecionados";
      });
      card.dataset.auditItem = String(index);
      card.setAttribute("aria-pressed", "false");
      grid.append(card);
    });
    area.append(grid);
    const checkButton = actionButton("Conferir a caixa", () => {
      const selected = new Set(Array.from(grid.querySelectorAll(".audit-item.is-selected"), (node) => Number(node.dataset.auditItem)));
      const exact = phase.items.every((item, index) => selected.has(index) === item.hazard);
      if (!exact) {
        window.EnviromentAudio?.play("wrong");
        mistakes++;
        showFeedback("Ainda há um item arriscado ou um material comum na lista. Reveja vidro, eletrônicos e pilhas.", true);
        grid.querySelectorAll(".audit-item").forEach((node) => node.classList.add("audit-nudge"));
        window.setTimeout(() => grid.querySelectorAll(".audit-item").forEach((node) => node.classList.remove("audit-nudge")), 450);
        return;
      }
      correct = phase.items.length;
      window.EnviromentAudio?.play("correct");
      completedTasks = phase.items.length;
      renderProgress();
      showFeedback("Inspeção segura! Esses materiais precisam de orientação e destinos próprios.");
      checkButton.disabled = true;
      actionButton("Fechar inspeção", completePhase);
    });
  }
  function renderBasket() {
    showFeedback("");
    area.replaceChildren(heading("Carrinho de passeio", "0 / " + phase.categories.length + " escolhas"));
    const cost = document.createElement("p");
    cost.className = "basket-budget";
    cost.textContent = "🍃 Orçamento: " + phase.budget + " folhas · Total: 0";
    area.append(questionCard("🛒", "Escolha uma opção em cada grupo. O kit precisa caber no orçamento e evitar descartáveis desnecessários."), cost);
    const groups = document.createElement("div");
    groups.className = "basket-groups";
    const selected = new Map();
    phase.categories.forEach((category, categoryIndex) => {
      const fieldset = document.createElement("fieldset");
      fieldset.className = "basket-category";
      const legend = document.createElement("legend");
      legend.textContent = category.title;
      fieldset.append(legend);
      category.options.forEach((option, optionIndex) => {
        const button = makeButton(option.icon + " " + option.label + " · " + option.cost + " folhas", "basket-option", () => {
          selected.set(categoryIndex, optionIndex);
          fieldset.querySelectorAll(".basket-option").forEach((node) => node.classList.toggle("is-selected", node === button));
          const total = Array.from(selected, ([groupIndex, choiceIndex]) => phase.categories[groupIndex].options[choiceIndex].cost).reduce((sum, amount) => sum + amount, 0);
          cost.textContent = "🍃 Orçamento: " + phase.budget + " folhas · Total: " + total;
          document.querySelector(".activity-heading small").textContent = selected.size + " / " + phase.categories.length + " escolhas";
        });
        fieldset.append(button);
      });
      groups.append(fieldset);
    });
    area.append(groups);
    const checkButton = actionButton("Conferir meu kit", () => {
      if (selected.size !== phase.categories.length) {
        showFeedback("Falta escolher um item para cada parte do passeio.", true);
        return;
      }
      const chosen = Array.from(selected, ([groupIndex, choiceIndex]) => phase.categories[groupIndex].options[choiceIndex]);
      const total = chosen.reduce((sum, option) => sum + option.cost, 0);
      if (total > phase.budget || chosen.some((option) => !option.good)) {
        window.EnviromentAudio?.play("wrong");
        mistakes++;
        showFeedback(total > phase.budget ? "O kit passou do orçamento. Reveja o que já pode levar de casa." : "O kit cabe no orçamento, mas ainda pode evitar mais embalagens. Pense no que você já tem.", true);
        return;
      }
      correct = phase.categories.length;
      window.EnviromentAudio?.play("correct");
      completedTasks = phase.categories.length;
      renderProgress();
      showFeedback("Kit pronto! Planejar o passeio ajudou a reduzir compras e embalagens.");
      checkButton.disabled = true;
      actionButton("Partir para o passeio", completePhase);
    });
  }
  function renderGarden() {
    showFeedback("");
    area.replaceChildren(heading("Cuide da muda", "Observe e ajuste"));
    area.append(questionCard("🌱", "Cartão da missão: esta espécie fictícia gosta de sol moderado e solo úmido, nunca encharcado."));
    const card = document.createElement("div");
    card.className = "garden-simulator";
    card.innerHTML = '<div class="garden-sky" aria-hidden="true"><span>☀️</span><span class="garden-seedling" id="gardenSeedling">🌱</span></div><label for="lightRange">Luz recebida <output id="lightValue">5/10</output></label><input id="lightRange" type="range" min="0" max="10" value="5"><label for="waterRange">Água no solo <output id="waterValue">5/10</output></label><input id="waterRange" type="range" min="0" max="10" value="5"><p class="garden-meter" id="gardenMeter">A muda ainda está se adaptando.</p>';
    area.append(card);
    const light = card.querySelector("#lightRange");
    const water = card.querySelector("#waterRange");
    const seedling = card.querySelector("#gardenSeedling");
    const meter = card.querySelector("#gardenMeter");
    function updatePlant() {
      card.querySelector("#lightValue").textContent = light.value + "/10";
      card.querySelector("#waterValue").textContent = water.value + "/10";
      const dry = Number(water.value) < 3;
      const flooded = Number(water.value) > 5;
      const tooBright = Number(light.value) > 8;
      const tooDark = Number(light.value) < 6;
      const stressed = dry || flooded || tooBright || tooDark;
      seedling.textContent = stressed ? "🥀" : "🌿";
      seedling.classList.toggle("is-thriving", !stressed);
      meter.textContent = flooded ? "O solo parece encharcado." : dry ? "A muda parece estar com sede." : tooBright ? "A folha está recebendo luz demais." : tooDark ? "A muda precisa de mais luz." : "A muda está reagindo bem; confirme cada ajuste.";
    }
    light.addEventListener("input", updatePlant);
    water.addEventListener("input", updatePlant);
    updatePlant();
    const checkButton = actionButton("Observar a muda", () => {
      const lightOk = Number(light.value) >= phase.needs.light[0] && Number(light.value) <= phase.needs.light[1];
      const waterOk = Number(water.value) >= phase.needs.water[0] && Number(water.value) <= phase.needs.water[1];
      if (!lightOk || !waterOk) {
        window.EnviromentAudio?.play("wrong");
        mistakes++;
        showFeedback((!lightOk ? "Reavalie a luz observando o cartão da espécie. " : "") + (!waterOk ? "Confira se o solo está úmido, sem ficar encharcado." : ""), true);
        updatePlant();
        return;
      }
      correct = 2;
      window.EnviromentAudio?.play("correct");
      completedTasks = 2;
      renderProgress();
      seedling.textContent = "🌼";
      seedling.classList.add("is-thriving");
      meter.textContent = "A muda floresceu! Essas medidas pertencem apenas à espécie fictícia da missão.";
      showFeedback("Ajuste equilibrado. Na vida real, as necessidades mudam conforme a espécie e o ambiente.");
      checkButton.disabled = true;
      actionButton("Florescer", completePhase);
    });
  }
  function completePhase() {
    if (phaseCompleting) return;
    phaseCompleting = true;
    const stars = mistakes === 0 ? 3 : mistakes <= Math.max(1, Math.ceil(totalTasks * .4)) ? 2 : 1;
    let progress = {};
    try { progress = JSON.parse(localStorage.getItem("enviromentAll.progress") || "{}"); } catch { progress = {}; }
    progress.completedLevels = Array.isArray(progress.completedLevels) ? progress.completedLevels : [];
    progress.records = progress.records || {};
    const isNew = !progress.completedLevels.includes(level);
    if (isNew) progress.completedLevels.push(level);
    const oldStars = Number(progress.records[level]?.stars || 0);
    const bestStars = Math.max(stars, oldStars);
    progress.records[level] = { stars: bestStars, correct: Math.max(correct, Number(progress.records[level]?.correct || 0)), total: totalTasks };
    progress.unlockedThrough = Math.min(15, Math.max(1, Number(progress.unlockedThrough || 1), level + 1));
    progress.xp = Number(progress.xp || 0) + (isNew ? 40 + bestStars * 15 : 0);
    progress.correctAnswers = Number(progress.correctAnswers || 0) + (isNew ? correct : 0);
    progress.totalAttempts = Number(progress.totalAttempts || 0) + (isNew ? totalTasks : 0);
    localStorage.setItem("enviromentAll.progress", JSON.stringify(progress));
    let wallet = {};
    try { wallet = JSON.parse(localStorage.getItem("enviromentAll.wallet") || "{}"); } catch { wallet = {}; }
    wallet.coins = Number(wallet.coins ?? 500);
    wallet.crystals = Number(wallet.crystals ?? 50);
    wallet.owned = Array.isArray(wallet.owned) ? wallet.owned : [];
    const coinsWon = isNew ? 40 + bestStars * 10 : 0;
    const crystalsWon = isNew && bestStars === 3 ? 2 : 0;
    if (isNew) {
      wallet.coins += coinsWon;
      wallet.crystals += crystalsWon;
    }
    localStorage.setItem("enviromentAll.wallet", JSON.stringify(wallet));
    const victory = new URLSearchParams({
      fase: String(level),
      tema: phase.themeId,
      moedas: String(coinsWon),
      cristais: String(crystalsWon),
      estrelas: String(bestStars)
    });
    window.location.href = "victory.html?" + victory.toString();
  }
})();
