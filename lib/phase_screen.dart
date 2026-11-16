import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'audio_service.dart';
import 'game_data.dart';
import 'game_screens.dart';
import 'game_store.dart';
import 'game_widgets.dart';

class PhaseScreen extends StatefulWidget {
  const PhaseScreen({super.key, required this.store, required this.audio, required this.level});
  final GameStore store;
  final GameAudio audio;
  final int level;
  @override
  State<PhaseScreen> createState() => _PhaseScreenState();
}

class _PhaseScreenState extends State<PhaseScreen> {
  late final PhaseData phase = phaseById(widget.level);
  int _mistakes = 0;
  int _correct = 0;
  int _questionIndex = 0;
  String _feedback = '';
  bool _feedbackError = false;
  bool _questionSolved = false;
  bool _complete = false;
  bool _busy = false;
  int? _selectedPair;
  int? _selectedCleanup;
  final Set<int> _solvedPairs = {};
  final Set<int> _collectedItems = {};
  final Set<int> _auditSelection = {};
  Map<int, int> _basketSelection = {};
  late List<int> _sequenceOrder;
  late List<List<AnswerData>> _questionAnswerSets;
  double _light = 5;
  double _water = 5;

  @override
  void initState() {
    super.initState();
    _questionAnswerSets = List.generate(phase.questions.length, (index) {
      final answers = List<AnswerData>.of(phase.questions[index].answers)
        ..shuffle(math.Random(DateTime.now().microsecondsSinceEpoch + phase.id * 31 + index));
      if (answers.isNotEmpty && answers.first.correct) {
        final correct = answers.removeAt(0);
        answers.insert(math.min(1, answers.length), correct);
      }
      return answers;
    });
    _sequenceOrder = List<int>.generate(phase.sequence.length, (i) => i);
    if (_sequenceOrder.length > 2) {
      _sequenceOrder = [_sequenceOrder[2], _sequenceOrder[0], _sequenceOrder.last, _sequenceOrder[1], ..._sequenceOrder.skip(4)];
    }
    _light = (phase.lightRange[0] + phase.lightRange[1]) / 2;
    _water = (phase.waterRange[0] + phase.waterRange[1]) / 2;
    widget.audio.setPhaseTrack(phase.id);
  }

  int get _total => switch (phase.type) {
        ActivityType.quiz => phase.questions.length,
        ActivityType.sorting || ActivityType.reuse || ActivityType.runoff || ActivityType.habitat => phase.pairs.length,
        ActivityType.cleanup => phase.cleanupItems.length,
        ActivityType.sequence => phase.sequence.length,
        ActivityType.audit => phase.auditItems.length,
        ActivityType.basket => phase.budgetGroups.length,
        ActivityType.garden => 2,
      };

  int get _progress => _complete ? _total : switch (phase.type) {
        ActivityType.quiz => _questionIndex,
        ActivityType.sorting || ActivityType.reuse || ActivityType.runoff || ActivityType.habitat => _solvedPairs.length,
        ActivityType.cleanup => _collectedItems.length,
        ActivityType.sequence => _complete ? phase.sequence.length : 0,
        ActivityType.audit => _complete ? phase.auditItems.length : 0,
        ActivityType.basket => _complete ? phase.budgetGroups.length : _basketSelection.length,
        ActivityType.garden => _complete ? 2 : 0,
      };

  int get _sceneIndex => switch (phase.id) {
        1 || 2 || 11 => 0,
        3 || 4 || 12 => 1,
        5 || 6 || 13 => 2,
        7 || 8 || 14 => 3,
        9 => 4,
        _ => 5,
      };

  void _message(String text, {bool error = false}) {
    setState(() { _feedback = text; _feedbackError = error; });
  }

  void _answer(AnswerData answer) {
    if (_questionSolved || _complete) return;
    if (!answer.correct) {
      _mistakes++;
      _message(answer.explanation, error: true);
      return;
    }
    setState(() {
      _correct++;
      _questionSolved = true;
      _feedback = answer.explanation;
      _feedbackError = false;
      if (_questionIndex == phase.questions.length - 1) _complete = true;
    });
  }

  void _nextQuestion() {
    setState(() { _questionIndex++; _questionSolved = false; _feedback = ''; _feedbackError = false; });
  }

  void _match(int itemIndex, String targetId) {
    if (_solvedPairs.contains(itemIndex)) return;
    final item = phase.pairs[itemIndex];
    if (item.target == targetId) {
      setState(() {
        _solvedPairs.add(itemIndex);
        _correct++;
        _selectedPair = null;
        _feedback = item.reason;
        _feedbackError = false;
        if (_solvedPairs.length == phase.pairs.length) _complete = true;
      });
    } else {
      setState(() { _mistakes++; _selectedPair = null; _feedback = 'Esse destino não combina com o item. Releia os cartões e tente outra combinação.'; _feedbackError = true; });
    }
  }

  void _collect(int index) {
    if (_collectedItems.contains(index)) return;
    setState(() {
      _collectedItems.add(index);
      _selectedCleanup = null;
      _correct++;
      _feedback = 'Boa! Um resíduo a menos na margem. Continue limpando com segurança.';
      _feedbackError = false;
      if (_collectedItems.length == phase.cleanupItems.length) {
        _complete = true;
        _feedback = 'Margem limpa! Na vida real, deixe o manuseio de resíduos a uma equipe segura.';
      }
    });
  }

  bool _isHazard(int i) => i == 0 || i == 1 || i == phase.auditItems.length - 1;

  Future<void> _checkAudit() async {
    final expected = <int>{for (var i = 0; i < phase.auditItems.length; i++) if (_isHazard(i)) i};
    if (_auditSelection.length == expected.length && _auditSelection.containsAll(expected)) {
      setState(() { _correct = expected.length; _complete = true; _feedback = 'Inspeção segura! Esses itens precisam de destino especial ou proteção.'; _feedbackError = false; });
    } else {
      setState(() { _mistakes++; _feedback = 'Revise cada item pensando se ele é seguro para a esteira comum. Você pode conferir novamente.'; _feedbackError = true; });
    }
  }

  void _checkSequence() {
    final isCorrect = List<int>.generate(phase.sequence.length, (i) => i).asMap().entries.every((e) => _sequenceOrder[e.key] == e.value);
    if (isCorrect) {
      setState(() { _correct = phase.sequence.length; _complete = true; _feedback = 'Sequência pronta! Depois do plantio, observe e cuide da muda.'; _feedbackError = false; });
    } else {
      setState(() { _mistakes++; _feedback = 'A ordem ainda pode melhorar. Comece pesquisando espécie e local, depois prepare, plante e acompanhe.'; _feedbackError = true; });
    }
  }

  void _checkBasket() {
    if (_basketSelection.length < phase.budgetGroups.length) {
      _message('Escolha uma opção para cada parte do passeio.', error: true);
      return;
    }
    final chosen = <BudgetOption>[];
    for (final entry in _basketSelection.entries) { chosen.add(phase.budgetGroups[entry.key][entry.value]); }
    final total = chosen.fold<int>(0, (sum, option) => sum + option.cost);
    if (total > phase.budget || chosen.any((option) => !option.good)) {
      setState(() { _mistakes++; _feedback = total > phase.budget ? 'O kit passou de ${phase.budget} folhas. Reveja o que já pode levar de casa.' : 'O kit cabe no orçamento, mas ainda pode evitar descartáveis. Pense no que você já tem.'; _feedbackError = true; });
      return;
    }
    setState(() { _correct = phase.budgetGroups.length; _complete = true; _feedback = 'Kit pronto! Planejar ajudou a reduzir compras e embalagens.'; _feedbackError = false; });
  }

  void _checkGarden() {
    final lightOk = _light >= phase.lightRange[0] && _light <= phase.lightRange[1];
    final waterOk = _water >= phase.waterRange[0] && _water <= phase.waterRange[1];
    if (lightOk && waterOk) {
      setState(() { _correct = 2; _complete = true; _feedback = 'A muda floresceu! Os valores são fictícios e servem apenas para este desafio.'; _feedbackError = false; });
    } else {
      setState(() { _mistakes++; _feedback = '${!lightOk ? 'Ajuste a luz observando o cartão da espécie. ' : ''}${!waterOk ? 'Deixe o solo úmido, sem ficar encharcado.' : ''}'; _feedbackError = true; });
    }
  }

  Future<void> _finish() async {
    if (!_complete || _busy) return;
    setState(() => _busy = true);
    final stars = _mistakes == 0 ? 3 : _mistakes <= math.max(1, (_total * .4).ceil()) ? 2 : 1;
    final reward = await widget.store.completeLevel(level: phase.id, stars: stars, correct: _correct, attempts: _total + _mistakes);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/victory', arguments: VictoryResult(level: phase.id, stars: reward.stars, coins: reward.coins, crystals: reward.crystals));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: widget.store, builder: (context, _) => Scaffold(
        backgroundColor: GamePalette.forest,
        body: GameBackdrop(asset: 'assets/screens/menu-background.png', reduceMotion: widget.store.settings.reduceMotion, child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(15, 8, 15, 10), child: Column(children: [
          GamePageHeader(title: 'Fase ${phase.id}', onBack: () => Navigator.pop(context), audio: widget.audio, backLabel: 'Trilha'),
          Expanded(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: 9),
            _hud(),
            const SizedBox(height: 9),
            _scene(),
            const SizedBox(height: 10),
            _intro(),
            const SizedBox(height: 10),
            GamePanel(padding: const EdgeInsets.all(13), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(_activityTitle(), textAlign: TextAlign.center, style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 9),
              _activity(),
              if (_feedback.isNotEmpty) ...[const SizedBox(height: 9), FeedbackBanner(text: _feedback, error: _feedbackError)],
              if (_questionSolved && !_complete) ...[const SizedBox(height: 8), GameButton(label: 'Próxima pergunta', audio: widget.audio, kind: ButtonKind.blue, height: 48, onPressed: _nextQuestion)],
              if (_complete) ...[const SizedBox(height: 10), GameButton(label: 'Concluir fase', audio: widget.audio, kind: ButtonKind.green, height: 54, icon: Icons.stars_rounded, enabled: !_busy, onPressed: _finish)],
            ])),
            const SizedBox(height: 10),
            const Text('Aprenda, tente de novo e descubra novas maneiras de cuidar do planeta.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, shadows: [Shadow(color: GamePalette.wood, blurRadius: 4)])),
            const SizedBox(height: 16),
          ]))),
        ])))),
      ));

  Widget _hud() => GamePanel(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9), child: Column(children: [Row(children: [Text(phase.icon, style: const TextStyle(fontSize: 24)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(phase.world.toUpperCase(), style: const TextStyle(color: GamePalette.wood, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)), Text('FASE ${phase.id} / 15', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900, fontSize: 15))])), Text('⭐ ${widget.store.xp} XP', style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900))]), const SizedBox(height: 7), ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: _total == 0 ? 0 : _progress / _total, minHeight: 9, backgroundColor: const Color(0xFFE8D8B2), valueColor: const AlwaysStoppedAnimation(GamePalette.leaf)))]));

  Widget _scene() => SizedBox(height: 145, child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Stack(fit: StackFit.expand, children: [
        SpriteCell(asset: 'assets/screens/phase-worlds-atlas.png', index: _sceneIndex),
        const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0x110B3820), Color(0x990B3820)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
        Positioned(left: 12, top: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: GamePalette.cream.withValues(alpha: .88), borderRadius: BorderRadius.circular(16)), child: Text(phase.world, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900, fontSize: 12)))),
        Center(child: Row(mainAxisSize: MainAxisSize.min, children: [Text(phase.creature, style: const TextStyle(fontSize: 52, shadows: [Shadow(color: Colors.black45, blurRadius: 7, offset: Offset(0, 3))])), const SizedBox(width: 7), const Icon(Icons.auto_awesome, color: Color(0xFFFFDB46), size: 26)])),
      ])));

  Widget _intro() => GamePanel(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), color: const Color(0xFFFFF4D9), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${phase.icon} ${phase.title}', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900, fontSize: 17)), const SizedBox(height: 4), Text(phase.goal, style: const TextStyle(color: GamePalette.ink, height: 1.24)), const SizedBox(height: 7), Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: const Color(0xFFF3E3B8), borderRadius: BorderRadius.circular(13)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('✦ ', style: TextStyle(color: GamePalette.orange, fontSize: 20)), Expanded(child: Text(phase.lesson, style: const TextStyle(color: GamePalette.ink, fontSize: 12, height: 1.25, fontWeight: FontWeight.w600)))]))]));

  String _activityTitle() => switch (phase.type) {
        ActivityType.quiz => 'Pergunta ${_questionIndex + 1} de ${phase.questions.length}',
        ActivityType.sorting => 'Esteira de triagem · ${_solvedPairs.length}/${phase.pairs.length}',
        ActivityType.cleanup => 'Resíduos recolhidos · ${_collectedItems.length}/${phase.cleanupItems.length}',
        ActivityType.reuse => 'Bancada de invenções · ${_solvedPairs.length}/${phase.pairs.length}',
        ActivityType.sequence => 'Ordem do plantio',
        ActivityType.audit => 'Inspecione cada item',
        ActivityType.runoff => 'Antes da chuva · ${_solvedPairs.length}/${phase.pairs.length}',
        ActivityType.basket => 'Orçamento: ${phase.budget} folhas',
        ActivityType.garden => 'Ajuste de luz e água',
        ActivityType.habitat => 'Conecte o corredor verde · ${_solvedPairs.length}/${phase.pairs.length}',
      };

  Widget _activity() => switch (phase.type) {
        ActivityType.quiz => _quiz(),
        ActivityType.sorting || ActivityType.reuse || ActivityType.runoff || ActivityType.habitat => _matching(),
        ActivityType.cleanup => _cleanup(),
        ActivityType.sequence => _sequence(),
        ActivityType.audit => _audit(),
        ActivityType.basket => _basket(),
        ActivityType.garden => _garden(),
      };

  Widget _quiz() {
    final questionIndex = _questionIndex.clamp(0, phase.questions.length - 1).toInt();
    final question = phase.questions[questionIndex];
    final answers = _questionAnswerSets[questionIndex];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .72), borderRadius: BorderRadius.circular(17), border: Border.all(color: GamePalette.sand, width: 2)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(question.icon, style: const TextStyle(fontSize: 29)), const SizedBox(width: 9), Expanded(child: Text(question.prompt, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900, fontSize: 15, height: 1.25)))])),
      const SizedBox(height: 9),
      for (var i = 0; i < answers.length; i++) ...[
        _answerCard(answers[i], i),
        const SizedBox(height: 7),
      ],
    ]);
  }

  Widget _answerCard(AnswerData answer, int index) => AnimatedScale(scale: _questionSolved ? .985 : 1, duration: const Duration(milliseconds: 160), child: InkWell(onTap: _questionSolved ? null : () { widget.audio.click(); _answer(answer); }, borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), decoration: BoxDecoration(color: Colors.white.withValues(alpha: _questionSolved ? .4 : .82), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFB8945F), width: 2), boxShadow: const [BoxShadow(color: Color(0x332B180D), blurRadius: 3, offset: Offset(0, 2))]), child: Row(children: [CircleAvatar(radius: 13, backgroundColor: const Color(0xFFEAC779), child: Text('${String.fromCharCode(65 + index)}', style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900, fontSize: 12))), const SizedBox(width: 9), Expanded(child: Text(answer.text, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w800, height: 1.22)))]))));

  Widget _matching() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Arraste uma peça ao destino ou toque nos dois cartões.', textAlign: TextAlign.center, style: TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        Wrap(spacing: 7, runSpacing: 7, alignment: WrapAlignment.center, children: [for (var i = 0; i < phase.pairs.length; i++) _draggablePair(i)]),
        const SizedBox(height: 12),
        const Row(children: [Icon(Icons.south_rounded, color: GamePalette.wood), SizedBox(width: 5), Text('Destinos', style: TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900))]),
        const SizedBox(height: 6),
        Wrap(spacing: 7, runSpacing: 7, alignment: WrapAlignment.center, children: [for (final target in phase.targets) _dropTarget(target)]),
      ]);

  Widget _draggablePair(int index) {
    final item = phase.pairs[index];
    final solved = _solvedPairs.contains(index);
    final content = Container(width: 136, constraints: const BoxConstraints(minHeight: 68), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: solved ? const Color(0xFFDCF3C1) : (_selectedPair == index ? const Color(0xFFFFD889) : Colors.white.withValues(alpha: .88)), borderRadius: BorderRadius.circular(15), border: Border.all(color: solved ? GamePalette.leaf : GamePalette.wood, width: 2)), child: Column(children: [Text(item.icon, style: const TextStyle(fontSize: 25)), Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: GamePalette.ink, fontSize: 11, height: 1.1, fontWeight: FontWeight.w800))]));
    return Draggable<int>(data: index, maxSimultaneousDrags: solved ? 0 : 1, feedback: Material(color: Colors.transparent, child: content), childWhenDragging: Opacity(opacity: .35, child: content), onDragStarted: () => setState(() => _selectedPair = index), child: GestureDetector(onTap: solved ? null : () { widget.audio.click(); setState(() => _selectedPair = index); }, child: content));
  }

  Widget _dropTarget(TargetData target) {
    final matches = <int>[for (var i = 0; i < phase.pairs.length; i++) if (phase.pairs[i].target == target.id) i];
    final allDone = matches.every(_solvedPairs.contains);
    final anyDone = matches.any(_solvedPairs.contains);
    return DragTarget<int>(onAccept: (index) => _match(index, target.id), builder: (context, candidates, rejects) {
      final active = candidates.isNotEmpty;
      return GestureDetector(onTap: _selectedPair == null ? null : () { widget.audio.click(); _match(_selectedPair!, target.id); }, child: AnimatedContainer(duration: const Duration(milliseconds: 160), width: phase.targets.length > 4 ? 89 : 137, constraints: const BoxConstraints(minHeight: 66), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), decoration: BoxDecoration(color: active || _selectedPair != null ? const Color(0xFFDDF3C2) : const Color(0xFFFFF7DF), borderRadius: BorderRadius.circular(17), border: Border.all(color: allDone || anyDone ? GamePalette.leaf : const Color(0xFFB8844B), width: 2), boxShadow: [if (active) const BoxShadow(color: Color(0x668DCE3E), blurRadius: 10, spreadRadius: 2)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(target.icon, style: const TextStyle(fontSize: 22)), Text(target.label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: GamePalette.ink, fontSize: 10, height: 1.05, fontWeight: FontWeight.w900)), if (matches.isNotEmpty) Text('${matches.where(_solvedPairs.contains).length}/${matches.length}', style: const TextStyle(color: GamePalette.forestLight, fontSize: 9, fontWeight: FontWeight.w900))])));
    });
  }

  Widget _cleanup() => Column(children: [
        const Text('Arraste o resíduo até a rede. No celular, toque no item e depois na rede.', textAlign: TextAlign.center, style: TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [for (var i = 0; i < phase.cleanupItems.length; i++) _cleanupPiece(i)]),
        const SizedBox(height: 12),
        DragTarget<int>(onAccept: _collect, builder: (context, candidates, rejects) => GestureDetector(onTap: _selectedCleanup == null ? null : () { widget.audio.click(); _collect(_selectedCleanup!); }, child: AnimatedContainer(duration: const Duration(milliseconds: 180), width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10), decoration: BoxDecoration(color: candidates.isNotEmpty ? const Color(0xFFB6EF5C) : const Color(0xFFD7F5EC), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF159C81), width: 3), boxShadow: const [BoxShadow(color: Color(0x33432B18), blurRadius: 4, offset: Offset(0, 3))]), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('🕸️', style: TextStyle(fontSize: 28)), SizedBox(width: 9), Text('REDE DE LIMPEZA', style: TextStyle(color: Color(0xFF277463), fontWeight: FontWeight.w900, fontSize: 15))])))),
      ]);

  Widget _cleanupPiece(int index) {
    final item = phase.cleanupItems[index];
    final done = _collectedItems.contains(index);
    final tile = GestureDetector(onTap: done ? null : () { widget.audio.click(); setState(() => _selectedCleanup = index); }, child: AnimatedOpacity(duration: const Duration(milliseconds: 180), opacity: done ? .28 : 1, child: Container(width: 92, height: 78, padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: _selectedCleanup == index ? const Color(0xFFFFDD8D) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _selectedCleanup == index ? GamePalette.orange : GamePalette.wood, width: 2)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(item.icon, style: const TextStyle(fontSize: 27)), Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, height: 1, color: GamePalette.ink, fontWeight: FontWeight.w800))]))));
    return Draggable<int>(data: index, maxSimultaneousDrags: done ? 0 : 1, feedback: Material(color: Colors.transparent, child: tile), childWhenDragging: Opacity(opacity: .35, child: tile), child: tile);
  }

  Widget _sequence() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Segure e arraste as placas para reorganizar os passos.', textAlign: TextAlign.center, style: TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        SizedBox(height: 290, child: ReorderableListView.builder(shrinkWrap: false, physics: const NeverScrollableScrollPhysics(), itemCount: _sequenceOrder.length, onReorder: (oldIndex, newIndex) {
          setState(() { if (newIndex > oldIndex) newIndex--; final item = _sequenceOrder.removeAt(oldIndex); _sequenceOrder.insert(newIndex, item); });
          widget.audio.click();
        }, itemBuilder: (context, index) {
          final stepIndex = _sequenceOrder[index];
          return Padding(key: ValueKey('step-$stepIndex'), padding: const EdgeInsets.only(bottom: 7), child: Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: const Color(0xFFFFF8E7), borderRadius: BorderRadius.circular(15), border: Border.all(color: GamePalette.wood, width: 2)), child: Row(children: [CircleAvatar(backgroundColor: GamePalette.orange, radius: 16, child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))), const SizedBox(width: 9), Expanded(child: Text(phase.sequence[stepIndex], style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w800))), const Icon(Icons.drag_handle, color: GamePalette.wood)])));
        })),
        GameButton(label: 'Conferir sequência', audio: widget.audio, kind: ButtonKind.blue, height: 48, onPressed: _complete ? null : _checkSequence),
      ]);

  Widget _audit() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Marque todos os itens que pedem orientação ou descarte especial.', textAlign: TextAlign.center, style: TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        for (var i = 0; i < phase.auditItems.length; i++) CheckboxListTile(dense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 8), tileColor: Colors.white.withValues(alpha: .65), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), activeColor: GamePalette.ocean, value: _auditSelection.contains(i), onChanged: _complete ? null : (value) { widget.audio.click(); setState(() { value == true ? _auditSelection.add(i) : _auditSelection.remove(i); }); }, title: Text('${phase.auditItems[i].icon}  ${phase.auditItems[i].name}', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w800))),
        const SizedBox(height: 8),
        GameButton(label: 'Conferir inspeção', audio: widget.audio, kind: ButtonKind.blue, height: 48, enabled: !_complete, onPressed: _checkAudit),
      ]);

  Widget _basket() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Escolha uma opção em cada grupo. Orçamento: ${phase.budget} folhas.', textAlign: TextAlign.center, style: const TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        for (var groupIndex = 0; groupIndex < phase.budgetGroups.length; groupIndex++) ...[
          Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: const Color(0xFFFFF7DF), border: Border.all(color: GamePalette.sand, width: 2), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(['Bebida', 'Lanche', 'Bolsa'][groupIndex], style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900)), const SizedBox(height: 4), for (var i = 0; i < phase.budgetGroups[groupIndex].length; i++) RadioListTile<int>(dense: true, contentPadding: EdgeInsets.zero, visualDensity: VisualDensity.compact, activeColor: GamePalette.leaf, value: i, groupValue: _basketSelection[groupIndex], onChanged: _complete ? null : (v) { if (v == null) return; widget.audio.click(); setState(() { _basketSelection[groupIndex] = v; _feedback = ''; }); }, title: Text('${phase.budgetGroups[groupIndex][i].icon} ${phase.budgetGroups[groupIndex][i].label} · ${phase.budgetGroups[groupIndex][i].cost} folhas', style: const TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700))) ])),
        ],
        Text('Total atual: ${_basketSelection.entries.fold<int>(0, (sum, entry) => sum + phase.budgetGroups[entry.key][entry.value].cost)} folhas', textAlign: TextAlign.center, style: const TextStyle(color: GamePalette.forestLight, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        GameButton(label: 'Conferir meu kit', audio: widget.audio, kind: ButtonKind.blue, height: 48, enabled: !_complete, onPressed: _checkBasket),
      ]);

  Widget _garden() {
    final healthy = _light >= phase.lightRange[0] && _light <= phase.lightRange[1] && _water >= phase.waterRange[0] && _water <= phase.waterRange[1];
    final stressed = _water < phase.waterRange[0] || _water > phase.waterRange[1] || _light < phase.lightRange[0] || _light > phase.lightRange[1];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('Esta espécie fictícia prefere sol moderado e solo úmido, sem encharcar.', textAlign: TextAlign.center, style: TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: healthy
                ? const [Color(0xFF9DE5F2), Color(0xFFB7E76B)]
                : const [Color(0xFFB5DDE9), Color(0xFFD0C494)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GamePalette.wood, width: 2),
        ),
        child: Center(
          child: AnimatedScale(
            scale: healthy ? 1.18 : 1,
            duration: const Duration(milliseconds: 400),
            child: Text(
              _complete ? '🌼' : stressed ? '🥀' : '🌱',
              style: const TextStyle(fontSize: 62),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      _rangeSlider('☀️ Luz', _light, (v) => setState(() => _light = v), '${_light.round()}/10'),
      _rangeSlider('💧 Água no solo', _water, (v) => setState(() => _water = v), '${_water.round()}/10'),
      const SizedBox(height: 3),
      Text(healthy ? 'A muda está reagindo bem.' : _water > phase.waterRange.last ? 'O solo parece encharcado.' : _water < phase.waterRange.first ? 'A muda parece estar com sede.' : 'Observe o equilíbrio de luz para a espécie.', textAlign: TextAlign.center, style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w800, fontSize: 12)),
      const SizedBox(height: 8),
      GameButton(label: _complete ? 'Muda cuidada!' : 'Observar a muda', audio: widget.audio, kind: ButtonKind.blue, height: 48, enabled: !_complete, onPressed: _checkGarden),
    ]);
  }

  Widget _rangeSlider(String label, double value, ValueChanged<double> onChanged, String output) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Text(label, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900)), const Spacer(), Text(output, style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900))]), Slider(value: value, min: 0, max: 10, divisions: 10, activeColor: GamePalette.leaf, onChanged: _complete ? null : onChanged)]);
}
