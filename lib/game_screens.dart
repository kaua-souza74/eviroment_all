import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'audio_service.dart';
import 'game_data.dart';
import 'game_store.dart';
import 'game_widgets.dart';
import 'route_history.dart';

Widget _pageFrame({required GameStore store, required GameAudio audio, required String title, required String background, required Widget body, required VoidCallback onBack, bool dark = false, Widget? footer}) {
  return Scaffold(
    backgroundColor: GamePalette.forest,
    body: GameBackdrop(
      asset: background,
      dark: dark,
      reduceMotion: store.settings.reduceMotion,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(children: [
            GamePageHeader(title: title, onBack: onBack, audio: audio),
            const SizedBox(height: 10),
            Expanded(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.only(bottom: 22), child: body)),
            if (footer != null) footer,
          ]),
        ),
      ),
    ),
  );
}

void _popOrMenu(BuildContext context, GameAudio audio) {
  if (Navigator.of(context).canPop()) {
    if (RouteHistory.instance.previousName == '/menu') audio.setMenuTrack();
    Navigator.of(context).pop();
  } else {
    audio.setMenuTrack();
    Navigator.of(context).pushNamedAndRemoveUntil('/menu', (_) => false);
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1550));
  late final Animation<double> _scale = Tween(begin: .28, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: const Interval(0, .65, curve: Curves.easeOut));
  bool _openedLogin = false;
  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future<void>.delayed(const Duration(milliseconds: 2350), _continueToLogin);
  }
  void _continueToLogin() {
    if (!mounted || _openedLogin) return;
    _openedLogin = true;
    Navigator.of(context).pushNamed('/login').then((_) {
      if (mounted) _openedLogin = false;
    });
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
        body: GameBackdrop(asset: 'assets/screens/menu-background.png', reduceMotion: widget.store.settings.reduceMotion, child: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedBuilder(animation: _controller, builder: (context, _) => FadeTransition(opacity: _fade, child: Transform.scale(scale: _scale.value, child: Image.asset('assets/brand/enviroment-all-logo.png', width: 280, height: 200, fit: BoxFit.contain)))),
          const SizedBox(height: 18),
          const Text('Uma aventura para cuidar do planeta', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900, shadows: [Shadow(color: GamePalette.wood, blurRadius: 5, offset: Offset(0, 2))])),
          const SizedBox(height: 34),
          TextButton(onPressed: _continueToLogin, child: const Text('Continuar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ])))),
      );
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;

  void _signOut(BuildContext context) async {
    await store.saveProfile(name: '');
    await audio.setMenuTrack();
    if (context.mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => Scaffold(
          body: GameBackdrop(asset: 'assets/screens/menu-background.png', reduceMotion: store.settings.reduceMotion, child: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
            final compact = constraints.maxHeight < 720;
            return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: EdgeInsets.fromLTRB(18, compact ? 4 : 12, 18, 14), child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset('assets/brand/enviroment-all-logo.png', height: compact ? 102 : 128, fit: BoxFit.contain),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9), decoration: BoxDecoration(color: const Color(0xFFFFF0C6).withValues(alpha: .94), borderRadius: BorderRadius.circular(20), border: Border.all(color: GamePalette.wood, width: 2), boxShadow: const [BoxShadow(color: Color(0x55351C0F), blurRadius: 6, offset: Offset(0, 3))]), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.person_pin, color: GamePalette.forestLight), const SizedBox(width: 7), Flexible(child: Text('Logado como: ${store.playerName.isEmpty ? 'Visitante' : store.playerName}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900)))])),
              const SizedBox(height: 14),
              GameButton(label: 'Jogar', audio: audio, kind: ButtonKind.wood, height: compact ? 58 : 64, textSize: 22, icon: Icons.play_arrow_rounded, onPressed: () => Navigator.pushNamed(context, '/phase-map')),
              const SizedBox(height: 8),
              GameButton(label: store.playerName.isEmpty ? 'Entrar / Criar conta' : 'Trocar conta', audio: audio, kind: ButtonKind.blue, height: compact ? 53 : 58, textSize: 18, icon: Icons.account_circle, onPressed: () => Navigator.pushNamed(context, '/login')),
              const SizedBox(height: 12),
              LayoutBuilder(builder: (context, c) {
                const actions = [
                  ('Missões', Icons.flag_rounded, '/missions'),
                  ('Conquistas', Icons.workspace_premium_rounded, '/achievements'),
                  ('Configurações', Icons.settings_rounded, '/settings'),
                  ('Ranking', Icons.leaderboard_rounded, '/ranking'),
                  ('Loja', Icons.storefront_rounded, '/shop'),
                  ('Como jogar', Icons.lightbulb_rounded, '/how-to'),
                ];
                final width = (c.maxWidth - 10) / 2;
                return Wrap(spacing: 10, runSpacing: 9, children: actions.map((a) => SizedBox(width: width, child: GameButton(label: a.$1, audio: audio, kind: ButtonKind.wood, height: compact ? 50 : 56, textSize: 15, icon: a.$2, onPressed: () {
                  if (a.$3 == '/how-to') {
                    showDialog<void>(context: context, builder: (context) => const _HelpDialog());
                  } else {
                    Navigator.pushNamed(context, a.$3);
                  }
                }))).toList());
              }),
              const SizedBox(height: 12),
              GameButton(label: 'Sair da conta', audio: audio, kind: ButtonKind.red, height: 48, textSize: 16, icon: Icons.logout_rounded, onPressed: () => _signOut(context)),
            ]))));
          }))),
        ),
      );
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog();
  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: GamePalette.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: GamePalette.wood, width: 3)),
        title: const Text('Como jogar?', style: TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900)),
        content: const Text('Explore a trilha, conclua desafios e aprenda atitudes que ajudam o meio ambiente. Cada fase tem uma atividade diferente: perguntas, triagem, resgate, sequência e decisões.', style: TextStyle(height: 1.35)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendi'))],
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.store.rememberMe ? widget.store.playerName : '');
  final _password = TextEditingController();
  bool _remember = true;
  bool _showPassword = false;
  @override
  void initState() { super.initState(); _remember = widget.store.rememberMe; }
  @override
  void dispose() { _name.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    await widget.store.setRememberMe(_remember);
    await widget.store.startFreshSession(name: _name.text);
    await widget.audio.setMenuTrack();
    if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/menu', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: GameBackdrop(
          asset: 'assets/screens/login-background.png',
          reduceMotion: widget.store.settings.reduceMotion,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 470),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(children: [
                    Row(children: [
                      SizedBox(
                        width: 86,
                        height: 42,
                        child: TextButton.icon(
                          onPressed: () { widget.audio.click(); _popOrMenu(context, widget.audio); },
                          icon: const Icon(Icons.chevron_left, size: 20),
                          label: const Text('Voltar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                          style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: GamePalette.ocean, side: const BorderSide(color: Color(0xFF0C5883), width: 2), shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 6)),
                        ),
                      ),
                      Expanded(child: Center(child: Image.asset('assets/brand/enviroment-all-logo.png', height: 65, fit: BoxFit.contain))),
                      const SizedBox(width: 86),
                    ]),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Center(
                          child: LayoutBuilder(builder: (context, constraints) {
                            final cardWidth = math.min(constraints.maxWidth, 405.0);
                            return SizedBox(
                              width: cardWidth,
                              child: AspectRatio(
                                aspectRatio: .68,
                                child: Stack(children: [
                                  Positioned.fill(child: Image.asset('assets/ui/login-card.png', fit: BoxFit.fill)),
                                  Positioned(
                                    top: 0, left: 0, right: 0, height: .265 * cardWidth / .68,
                                    child: const Center(child: Padding(padding: EdgeInsets.only(top: 16), child: Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, shadows: [Shadow(color: GamePalette.wood, blurRadius: 3, offset: Offset(0, 2))])))),
                                  ),
                                  Positioned(
                                    left: cardWidth * .12, right: cardWidth * .12, top: cardWidth / .68 * .26, bottom: cardWidth / .68 * .055,
                                    child: Form(
                                      key: _form,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                        const Text('Boas-vindas!', textAlign: TextAlign.center, style: TextStyle(color: GamePalette.pink, fontWeight: FontWeight.w900, fontSize: 19)),
                                        const SizedBox(height: 10),
                                        _authField(controller: _name, label: 'Usuário', hint: 'Seu nome', icon: Icons.person, minFieldHeight: 64, validator: (v) => (v == null || v.trim().isEmpty) ? 'Digite seu nome.' : null),
                                        const SizedBox(height: 8),
                                        _authField(controller: _password, label: 'Senha', hint: 'Sua senha', icon: Icons.lock, obscure: !_showPassword, suffix: IconButton(icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: GamePalette.ocean), onPressed: () => setState(() => _showPassword = !_showPassword)), validator: (v) => (v == null || v.isEmpty) ? 'Digite sua senha.' : null),
                                        const SizedBox(height: 4),
                                        CheckboxListTile(contentPadding: EdgeInsets.zero, dense: true, activeColor: GamePalette.ocean, controlAffinity: ListTileControlAffinity.leading, title: const Text('Manter conectado', style: TextStyle(fontWeight: FontWeight.w800, color: GamePalette.ink, fontSize: 14)), value: _remember, onChanged: (value) { widget.audio.click(); setState(() => _remember = value ?? false); widget.store.setRememberMe(_remember); }),
                                        const Spacer(),
                                        Row(children: [
                                          Expanded(child: GameButton(label: 'Criar conta', audio: widget.audio, kind: ButtonKind.blue, height: 50, textSize: 15, onPressed: () => Navigator.pushNamed(context, '/signup'))),
                                          const SizedBox(width: 10),
                                          Expanded(child: GameButton(label: 'Entrar', audio: widget.audio, kind: ButtonKind.green, height: 50, textSize: 16, onPressed: _login)),
                                        ]),
                                        const SizedBox(height: 7),
                                        const Text('Acesso demonstrativo: esta versão salva apenas o perfil neste dispositivo.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, height: 1.1, color: Color(0xFF547A79), fontWeight: FontWeight.w700)),
                                      ]),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _showPassword = false;
  @override
  void dispose() { _name.dispose(); _email.dispose(); _password.dispose(); _confirm.dispose(); super.dispose(); }

  Future<void> _createAccount() async {
    if (!_form.currentState!.validate()) return;
    await widget.store.startFreshSession(name: _name.text, email: _email.text);
    await widget.audio.setMenuTrack();
    if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/menu', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GameBackdrop(
        asset: 'assets/screens/login-background.png',
        reduceMotion: widget.store.settings.reduceMotion,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(children: [
                  Row(children: [
                    SizedBox(
                      width: 86,
                      height: 42,
                      child: TextButton.icon(
                        onPressed: () { widget.audio.click(); Navigator.pop(context); },
                        icon: const Icon(Icons.chevron_left, size: 20),
                        label: const Text('Voltar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                        style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: GamePalette.ocean, side: const BorderSide(color: Color(0xFF0C5883), width: 2), shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 6)),
                      ),
                    ),
                    Expanded(child: Center(child: Image.asset('assets/brand/enviroment-all-logo.png', height: 62, fit: BoxFit.contain))),
                    const SizedBox(width: 86),
                  ]),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: LayoutBuilder(builder: (context, constraints) {
                          final cardWidth = math.min(constraints.maxWidth, 405.0);
                          return SizedBox(
                            width: cardWidth,
                            child: AspectRatio(
                              aspectRatio: .68,
                              child: Stack(children: [
                                Positioned.fill(child: Image.asset('assets/ui/login-card.png', fit: BoxFit.fill)),
                                Positioned(
                                  top: 0, left: 0, right: 0, height: .265 * cardWidth / .68,
                                  child: const Center(child: Padding(padding: EdgeInsets.only(top: 16), child: Text('Criar conta', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, shadows: [Shadow(color: GamePalette.wood, blurRadius: 3, offset: Offset(0, 2))])))),
                                ),
                                Positioned(
                                  left: cardWidth * .12, right: cardWidth * .12, top: cardWidth / .68 * .255, bottom: cardWidth / .68 * .055,
                                  child: SingleChildScrollView(child: Form(
                                    key: _form,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                      const Text('Entre para a aventura!', textAlign: TextAlign.center, maxLines: 1, style: TextStyle(color: GamePalette.pink, fontWeight: FontWeight.w900, fontSize: 15)),
                                      const SizedBox(height: 3),
                                      _authField(controller: _name, label: 'Nome', hint: 'Seu nome', icon: Icons.person, validator: (v) => (v == null || v.trim().length < 2) ? 'Informe seu nome.' : null),
                                      const SizedBox(height: 3),
                                      _authField(controller: _email, label: 'E-mail', hint: 'voce@exemplo.com', icon: Icons.alternate_email, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !RegExp(r'^.+@.+\..+$').hasMatch(v.trim())) ? 'Digite um e-mail válido.' : null),
                                      const SizedBox(height: 3),
                                      _authField(controller: _password, label: 'Senha', hint: 'Mínimo de 6 caracteres', icon: Icons.lock, obscure: !_showPassword, suffix: IconButton(icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: GamePalette.ocean), onPressed: () { widget.audio.click(); setState(() => _showPassword = !_showPassword); }), validator: (v) => (v == null || v.length < 6) ? 'Use pelo menos 6 caracteres.' : null),
                                      const SizedBox(height: 3),
                                      _authField(controller: _confirm, label: 'Confirmar senha', hint: 'Digite a senha novamente', icon: Icons.lock_outline, obscure: !_showPassword, validator: (v) => v != _password.text ? 'As senhas não coincidem.' : null),
                                      const SizedBox(height: 8),
                                      GameButton(label: 'Criar conta', audio: widget.audio, kind: ButtonKind.green, height: 50, textSize: 17, onPressed: _createAccount),
                                      TextButton(style: TextButton.styleFrom(minimumSize: const Size(0, 44), padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.padded), onPressed: () { widget.audio.click(); Navigator.pop(context); }, child: const Text('Já tem conta? Entrar', style: TextStyle(color: GamePalette.ocean, fontWeight: FontWeight.w900))),
                                    ]),
                                  )),
                                ),
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _authField({required TextEditingController controller, required String label, required String hint, required IconData icon, String? Function(String?)? validator, bool obscure = false, Widget? suffix, TextInputType? keyboardType, double minFieldHeight = 50}) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 5, bottom: 2), child: Text(label, style: const TextStyle(color: GamePalette.ocean, fontWeight: FontWeight.w900, fontSize: 11))),
      TextFormField(controller: controller, validator: validator, obscureText: obscure, keyboardType: keyboardType, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w800, fontSize: 16), decoration: InputDecoration(constraints: BoxConstraints(minHeight: minFieldHeight), isDense: true, hintText: hint, prefixIcon: Icon(icon, size: 19, color: GamePalette.ocean), prefixIconConstraints: BoxConstraints(minWidth: 42, minHeight: minFieldHeight), suffixIcon: suffix, suffixIconConstraints: BoxConstraints(minWidth: 42, minHeight: minFieldHeight), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), filled: true, fillColor: const Color(0xFFDDF8F7), hintStyle: const TextStyle(color: Color(0xFF73939A), fontWeight: FontWeight.w600), errorStyle: const TextStyle(fontSize: 10, height: .9), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Color(0xFF8FD5DC), width: 2)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: GamePalette.ocean, width: 2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Color(0xFFC7553A), width: 2)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Color(0xFFC7553A), width: 2)))),
    ]);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: store, builder: (context, _) => _pageFrame(store: store, audio: audio, title: 'Configurações', background: 'assets/screens/menu-background.png', onBack: () => _popOrMenu(context, audio), body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        GamePanel(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const _SectionHeading(icon: Icons.volume_up_rounded, title: 'Áudio'),
          _settingSwitch(context, 'Som dos botões', 'Cliques e interações', store.settings.soundOn, (v) async { await store.saveSetting('soundOn', v); }),
          _settingSwitch(context, 'Música', 'Trilha do menu e das fases', store.settings.musicOn, (v) async { await store.saveSetting('musicOn', v); await audio.setMusicEnabled(v); }),
          const SizedBox(height: 8),
          Text('Volume da música · ${(store.settings.musicVolume * 100).round()}%', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w800)),
          Slider(value: store.settings.musicVolume, activeColor: GamePalette.leaf, onChangeStart: (_) => audio.click(), onChanged: (v) { store.saveSetting('musicVolume', v); audio.setMusicVolume(v); }),
          Text('Volume dos efeitos · ${(store.settings.effectsVolume * 100).round()}%', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w800)),
          Slider(value: store.settings.effectsVolume, activeColor: GamePalette.ocean, onChangeStart: (_) => audio.click(), onChanged: (v) { store.saveSetting('effectsVolume', v); audio.setEffectsVolume(v); }),
          const Divider(color: GamePalette.sand, height: 24),
          const _SectionHeading(icon: Icons.accessibility_new_rounded, title: 'Acessibilidade'),
          _settingSwitch(context, 'Reduzir animações', 'Desliga folhas e movimentos decorativos', store.settings.reduceMotion, (v) => store.saveSetting('reduceMotion', v)),
          _settingSwitch(context, 'Texto ampliado', 'Aumenta o texto das telas de jogo', store.settings.largeText, (v) => store.saveSetting('largeText', v)),
          const Divider(color: GamePalette.sand, height: 24),
          const _SectionHeading(icon: Icons.language_rounded, title: 'Idioma'),
          DropdownButtonFormField<String>(value: store.settings.language, decoration: InputDecoration(filled: true, fillColor: Colors.white.withValues(alpha: .65), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))), items: const ['Português', 'English', 'Español'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) { audio.click(); if (v != null) store.saveSetting('language', v); }),
        ])),
        const SizedBox(height: 12),
        GameButton(label: 'Salvar preferências', audio: audio, kind: ButtonKind.green, icon: Icons.check_circle, onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preferências salvas neste dispositivo.')))),
        const SizedBox(height: 6),
        TextButton(onPressed: () async {
          audio.click();
          await store.saveSetting('soundOn', true); await audio.setMusicEnabled(true);
          await store.saveSetting('musicOn', true); await store.saveSetting('reduceMotion', false); await store.saveSetting('largeText', false);
          await store.saveSetting('musicVolume', .48); await audio.setMusicVolume(.48); await store.saveSetting('effectsVolume', .75); await audio.setEffectsVolume(.75); await store.saveSetting('language', 'Português');
        }, child: const Text('Restaurar padrão', style: TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900))),
      ])));

  Widget _settingSwitch(BuildContext context, String title, String subtitle, bool value, Future<void> Function(bool) onChanged) => SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, activeColor: GamePalette.leaf, title: Text(title, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF916344))), value: value, onChanged: (v) { audio.click(); onChanged(v); });
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [Icon(icon, color: GamePalette.wood), const SizedBox(width: 7), Text(title, style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900, fontSize: 17))]));
}

class PhaseMapScreen extends StatelessWidget {
  const PhaseMapScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;

  void _openLevel(BuildContext context, int id) {
    if (id > store.unlockedThrough) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conclua as fases anteriores para abrir este caminho.')));
      return;
    }
    audio.click();
    audio.setPhaseTrack(id);
    Navigator.pushNamed(context, '/phase', arguments: id);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: store, builder: (context, _) => _pageFrame(store: store, audio: audio, title: 'Trilha de desafios', background: 'assets/screens/menu-background.png', onBack: () => _popOrMenu(context, audio), body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        CurrencyPill(coins: store.coins, crystals: store.crystals),
        const SizedBox(height: 10),
        GamePanel(padding: const EdgeInsets.all(13), child: Row(children: [Expanded(child: Text('⭐ ${store.xp} XP  ·  ${store.completedCount} de 15 fases completas', style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900))), const Icon(Icons.explore, color: GamePalette.leaf)])),
        const SizedBox(height: 13),
        ...List<Widget>.generate(gameThemes.length, (index) {
          final theme = gameThemes[index];
          final isLastTheme = index == gameThemes.length - 1;
          final startsOnRight = theme.id != 'bonus';
          final lastIndex = theme.lastLevel - theme.firstLevel;
          final endsOnRight = lastIndex.isEven == startsOnRight;
          final nextStartsOnRight = !isLastTheme && gameThemes[index + 1].id != 'bonus';
          return Column(
            children: [
              Reveal(
                reduceMotion: store.settings.reduceMotion,
                delay: Duration(milliseconds: index * 100),
                child: _ThemePathCard(
                  theme: theme,
                  store: store,
                  audio: audio,
                  onLevel: (id) => _openLevel(context, id),
                ),
              ),
              if (!isLastTheme)
                _TrailTransition(
                  startOnRight: endsOnRight,
                  endOnRight: nextStartsOnRight,
                ),
            ],
          );
        }),
        const Center(child: Text('Continue descendo: novos caminhos e recompensas aguardam!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, shadows: [Shadow(color: GamePalette.wood, blurRadius: 5, offset: Offset(0, 2))]))),
      ])));
}

class _ThemePathCard extends StatelessWidget {
  const _ThemePathCard({required this.theme, required this.store, required this.audio, required this.onLevel});
  final ThemeDataGame theme;
  final GameStore store;
  final GameAudio audio;
  final ValueChanged<int> onLevel;
  @override
  Widget build(BuildContext context) {
    final ids = List<int>.generate(theme.lastLevel - theme.firstLevel + 1, (i) => theme.firstLevel + i);
    final completed = ids.where(store.completedLevels.containsKey).length;
    final routeHeight = ids.length == 2 ? 244.0 : ids.length * 112.0 + 16;
    final bannerColors = switch (theme.id) {
      'pollution' => const [Color(0xFF59CBE8), Color(0xFF258DB8)],
      'three-rs' => const [Color(0xFFF5C34E), Color(0xFFD77B22)],
      'planting' => const [Color(0xFFA6D95A), Color(0xFF58A537)],
      'forest' => const [Color(0xFF55AC5C), Color(0xFF216C43)],
      'bonus' => const [Color(0xFFB988E9), Color(0xFF8150C3)],
      _ => const [Color(0xFF94D653), Color(0xFF4D9D36)],
    };
    return GamePanel(
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: bannerColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFF875020), width: 2.5),
              boxShadow: const [
                BoxShadow(color: Color(0xFF774018), offset: Offset(0, 4)),
                BoxShadow(color: Color(0x88FFFFFF), offset: Offset(0, 1)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: theme.id == 'pollution'
                          ? const [Color(0xFFBDF5FF), Color(0xFF52BDE1)]
                          : const [Color(0xFFD5F58B), Color(0xFF63B83C)],
                    ),
                    border: Border.all(color: const Color(0xFFFFE9A5), width: 2),
                    boxShadow: const [
                      BoxShadow(color: Color(0x663C351C), offset: Offset(0, 3)),
                    ],
                  ),
                  child: Text(theme.icon, style: const TextStyle(fontSize: 25)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme.id == 'bonus'
                            ? 'EXPEDIÇÃO ESPECIAL'
                            : 'BIOMA ${gameThemes.indexOf(theme) + 1}',
                        style: const TextStyle(
                          color: Color(0xFFFFF1C9),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          shadows: [Shadow(color: GamePalette.wood, blurRadius: 2, offset: Offset(0, 1))],
                        ),
                      ),
                      Text(
                        theme.world,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: GamePalette.wood, blurRadius: 2, offset: Offset(0, 2))],
                        ),
                      ),
                      Text(
                        '${theme.title} · Fases ${theme.firstLevel}–${theme.lastLevel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFFFF0C6),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(theme.id == 'bonus' ? '🏆' : theme.id == 'pollution' ? '🐟' : '🌿', style: const TextStyle(fontSize: 23)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 8),
            child: Text(
              theme.blurb,
              textAlign: TextAlign.center,
              style: const TextStyle(color: GamePalette.ink, fontSize: 12, fontWeight: FontWeight.w800, height: 1.25),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: completed / ids.length,
                    minHeight: 9,
                    backgroundColor: const Color(0xFFE8D5A3),
                    valueColor: const AlwaysStoppedAnimation(GamePalette.leaf),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                '$completed/${ids.length}',
                style: const TextStyle(
                  color: GamePalette.wood,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: routeHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const nodeSize = 74.0;
                const stopHeight = 112.0;
                const firstTop = 7.0;
                final lastTop = routeHeight - stopHeight - 7;
                final step = ids.length == 1
                    ? 0.0
                    : (lastTop - firstTop) / (ids.length - 1);
                final startsOnRight = theme.id != 'bonus';
                final centers = List<Offset>.generate(ids.length, (index) {
                  final onRight = index.isEven == startsOnRight;
                  final x = constraints.maxWidth * (onRight ? .72 : .28);
                  final top = firstTop + step * index;
                  return Offset(x, top + nodeSize / 2);
                });
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme.id == 'pollution'
                          ? const [Color(0xFFDDF7E8), Color(0xFFBCEBF0)]
                          : theme.id == 'bonus'
                              ? const [Color(0xFFF0E2FF), Color(0xFFFFE5B7)]
                              : const [Color(0xFFE4F1BC), Color(0xFFFFE6B1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBA8A4E), width: 2),
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _TrailRoadPainter(points: centers, winding: ids.length == 2),
                        ),
                      ),
                      Positioned(
                        left: constraints.maxWidth * .5 - 21,
                        top: routeHeight * .43 - 21,
                        child: IgnorePointer(
                          child: Transform.rotate(
                            angle: .08,
                            child: Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0BD),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFC98A37), width: 2),
                                boxShadow: const [BoxShadow(color: Color(0xFF71421F), offset: Offset(0, 3))],
                              ),
                              child: Text(theme.id == 'bonus' ? '🎁' : '✨', style: const TextStyle(fontSize: 23)),
                            ),
                          ),
                        ),
                      ),
                      for (var index = 0; index < ids.length; index++)
                        Positioned(
                          left: centers[index].dx - 70,
                          top: firstTop + step * index,
                          width: 140,
                          height: stopHeight,
                          child: _TrailStop(
                            id: ids[index],
                            stars: store.completedLevels[ids[index]] ?? 0,
                            unlocked: ids[index] <= store.unlockedThrough,
                            onTap: () => onLevel(ids[index]),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrailStop extends StatelessWidget {
  const _TrailStop({required this.id, required this.stars, required this.unlocked, required this.onTap});
  final int id;
  final int stars;
  final bool unlocked;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final phase = phaseById(id);
    final complete = stars > 0;
    return Semantics(
      button: true,
      enabled: unlocked,
      label: 'Fase $id, ${phase.title}, ${complete ? '$stars estrelas' : unlocked ? 'disponível' : 'bloqueada'}',
      child: GestureDetector(
        onTap: unlocked ? onTap : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: .88, end: 1),
              duration: const Duration(milliseconds: 620),
              curve: Curves.elasticOut,
              builder: (context, scale, child) => Transform.scale(
                scale: scale,
                child: child,
              ),
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: complete
                        ? const [Color(0xFFFFE875), Color(0xFFFFAD32)]
                        : unlocked
                            ? const [Color(0xFFFFC24B), Color(0xFFEF7C27)]
                            : const [Color(0xFFB9B5A6), Color(0xFF858579)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: complete
                        ? const Color(0xFF9A671F)
                        : const Color(0xFF87451F),
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66472A14),
                      blurRadius: 6,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Color(0x88FFFFFF),
                      blurRadius: 1,
                      offset: Offset(-2, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$id',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: GamePalette.wood,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      complete
                          ? Icons.star_rounded
                          : unlocked
                              ? Icons.play_arrow_rounded
                              : Icons.lock_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              constraints: const BoxConstraints(maxWidth: 142),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0C6).withValues(alpha: .94),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB78342), width: 1.5),
              ),
              child: Column(
                children: [
                  Text(
                    phase.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: GamePalette.ink,
                      fontSize: 11,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (complete)
                    Text(
                      List<String>.filled(stars, '⭐').join(),
                      style: const TextStyle(fontSize: 9, height: 1),
                    )
                  else
                    Text(
                      unlocked ? 'TOQUE PARA JOGAR' : 'BLOQUEADA',
                      style: TextStyle(
                        color: unlocked ? GamePalette.forestLight : GamePalette.wood,
                        fontSize: 8,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrailRoadPainter extends CustomPainter {
  const _TrailRoadPainter({required this.points, this.winding = false});
  final List<Offset> points;
  final bool winding;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final road = Path()..moveTo(points.first.dx, points.first.dy);
    if (winding && points.length == 2) {
      road
        ..cubicTo(size.width * .28, size.height * .10, size.width * .16, size.height * .33, size.width * .48, size.height * .47)
        ..cubicTo(size.width * .84, size.height * .60, size.width * .85, size.height * .77, points.last.dx, points.last.dy);
    } else {
      for (var index = 1; index < points.length; index++) {
        final start = points[index - 1];
        final end = points[index];
        final rise = (end.dy - start.dy).abs();
        road.cubicTo(
          start.dx + (end.dx - start.dx) * .2,
          start.dy + rise * .55,
          end.dx - (end.dx - start.dx) * .2,
          end.dy - rise * .55,
          end.dx,
          end.dy,
        );
      }
    }
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 27
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF9B6036).withValues(alpha: .88);
    final dirt = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFE3AE62);
    final center = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFE2A1).withValues(alpha: .82);
    canvas.drawPath(road, edge);
    canvas.drawPath(road, dirt);
    canvas.drawPath(road, center);

    final stones = Paint()..color = const Color(0xFFFFF0C6).withValues(alpha: .8);
    for (final metric in road.computeMetrics()) {
      for (var distance = 12.0; distance < metric.length - 8; distance += 19) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 2.1, stones);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrailRoadPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.winding != winding;
}

class _TrailTransition extends StatelessWidget {
  const _TrailTransition({required this.startOnRight, required this.endOnRight});
  final bool startOnRight;
  final bool endOnRight;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 38,
        child: LayoutBuilder(
          builder: (context, constraints) => CustomPaint(
            painter: _TrailRoadPainter(
              points: [
                Offset(constraints.maxWidth * (startOnRight ? .73 : .27), 0),
                Offset(constraints.maxWidth * (endOnRight ? .73 : .27), 38),
              ],
            ),
          ),
        ),
      );
}

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: store, builder: (context, _) => _pageFrame(store: store, audio: audio, title: 'Missões ambientais', background: 'assets/screens/menu-background.png', onBack: () => _popOrMenu(context, audio), body: Column(children: [
        for (var i = 0; i < gameThemes.length - 1; i++) ...[
          _MissionCard(theme: gameThemes[i], store: store, audio: audio, onExplore: () => Navigator.pushNamed(context, '/phase-map')),
          const SizedBox(height: 11),
        ],
        GamePanel(padding: const EdgeInsets.all(14), child: Column(children: [const Text('🧭 Expedição bônus', style: TextStyle(color: GamePalette.ink, fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('Desafios extras misturam o que você aprendeu nos cinco temas.', textAlign: TextAlign.center), const SizedBox(height: 10), GameButton(label: 'Explorar trilha', audio: audio, kind: ButtonKind.green, height: 48, onPressed: () => Navigator.pushNamed(context, '/phase-map'))])),
      ])));
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.theme, required this.store, required this.audio, required this.onExplore});
  final ThemeDataGame theme;
  final GameStore store;
  final GameAudio audio;
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) {
    final total = theme.lastLevel - theme.firstLevel + 1;
    final complete = List<int>.generate(total, (i) => theme.firstLevel + i).where(store.completedLevels.containsKey).length;
    return GamePanel(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [SizedBox(width: 92, child: SpriteCell(asset: 'assets/ui/environment-mission-badges.png', index: theme.spriteIndex)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${theme.icon} ${theme.title}', style: const TextStyle(color: GamePalette.ink, fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(theme.blurb, style: const TextStyle(color: GamePalette.ink, fontSize: 12, height: 1.2))]))]),
      const SizedBox(height: 9),
      Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(9), child: LinearProgressIndicator(value: complete / total, minHeight: 9, backgroundColor: const Color(0xFFE4D3A6), valueColor: const AlwaysStoppedAnimation(GamePalette.leaf)))), const SizedBox(width: 8), Text('$complete/$total', style: const TextStyle(fontWeight: FontWeight.w900, color: GamePalette.ink))]),
      const SizedBox(height: 10),
      GameButton(label: 'Explorar tema', audio: audio, kind: ButtonKind.wood, height: 58, textSize: 17, icon: Icons.explore, onPressed: onExplore),
    ]));
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: store, builder: (context, _) {
        final completed = store.completedCount;
        final records = <(String, String, IconData, int)>[
          ('Separação correta', 'Conclua as duas fases de reciclagem.', Icons.recycling, [1, 2].where(store.completedLevels.containsKey).length),
          ('Guardião da água', 'Ajude a proteger a baía e os rios.', Icons.water_drop, [3, 4, 12].where(store.completedLevels.containsKey).length),
          ('Mestre dos 3 Rs', 'Repense, reutilize e reduza resíduos.', Icons.loop, [5, 6, 13].where(store.completedLevels.containsKey).length),
          ('Semeador de esperança', 'Aprenda a plantar e cuidar de mudas.', Icons.local_florist, [7, 8, 14].where(store.completedLevels.containsKey).length),
          ('Protetor da mata', 'Defenda habitats e corredores verdes.', Icons.forest, [9, 10, 15].where(store.completedLevels.containsKey).length),
          ('Explorador completo', 'Conclua todas as fases da aventura.', Icons.workspace_premium, completed),
        ];
        return _pageFrame(store: store, audio: audio, title: 'Conquistas', background: 'assets/screens/menu-background.png', onBack: () => _popOrMenu(context, audio), body: Column(children: [
          GamePanel(padding: const EdgeInsets.all(15), child: Column(children: [const Text('Cada pequena atitude conta!', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, color: GamePalette.ink, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text('$completed de 6 emblemas conquistados', style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w800)), const SizedBox(height: 9), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: completed / 6, minHeight: 11, backgroundColor: const Color(0xFFE9D7AA), valueColor: const AlwaysStoppedAnimation(GamePalette.leaf)))])),
          const SizedBox(height: 12),
          for (var i = 0; i < records.length; i++) ...[
            Reveal(reduceMotion: store.settings.reduceMotion, delay: Duration(milliseconds: i * 60), child: _AchievementCard(record: records[i], goal: i == records.length - 1 ? 15 : (i == 1 || i == 2 || i == 3 ? 3 : 2))),
            const SizedBox(height: 10),
          ],
        ]));
      });
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.record, required this.goal});
  final (String, String, IconData, int) record;
  final int goal;
  @override
  Widget build(BuildContext context) {
    final amount = record.$4.clamp(0, goal);
    final done = amount >= goal;
    return GamePanel(padding: const EdgeInsets.all(13), child: Row(children: [
      Container(width: 55, height: 55, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: done ? const [Color(0xFFFFD85A), Color(0xFFF39A2D)] : const [Color(0xFFD5D2C3), Color(0xFFAAA99E)]), border: Border.all(color: GamePalette.wood, width: 3)), child: Icon(record.$3, color: Colors.white, size: 30)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(record.$1, style: const TextStyle(color: GamePalette.ink, fontWeight: FontWeight.w900, fontSize: 16)), Text(record.$2, style: const TextStyle(color: GamePalette.ink, fontSize: 12, height: 1.2)), const SizedBox(height: 7), ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: amount / goal, minHeight: 8, backgroundColor: const Color(0xFFE5D1A2), valueColor: AlwaysStoppedAnimation(done ? GamePalette.leaf : GamePalette.ocean))), Text(done ? 'Conquistada!' : '$amount de $goal fases', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: GamePalette.wood))])),
    ]));
  }
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int _tab = 0;
  @override
  Widget build(BuildContext context) => _pageFrame(store: widget.store, audio: widget.audio, title: 'Ranking', background: 'assets/screens/menu-background.png', onBack: () => _popOrMenu(context, widget.audio), body: Column(children: [
        GamePanel(padding: const EdgeInsets.all(15), child: Column(children: [const Text('🏆 Liga da floresta', style: TextStyle(color: GamePalette.ink, fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text('Sua pontuação: ${widget.store.xp} XP', style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w800)), const SizedBox(height: 12), SegmentedButton<int>(segments: const [ButtonSegment(value: 0, label: Text('Semanal')), ButtonSegment(value: 1, label: Text('Amigos')), ButtonSegment(value: 2, label: Text('Geral'))], selected: {_tab}, showSelectedIcon: false, onSelectionChanged: (v) { widget.audio.click(); setState(() => _tab = v.first); })])),
        const SizedBox(height: 11),
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
          _podium('2', 'LiaVerde', '840 XP', const Color(0xFFB6BEC1), 76), const SizedBox(width: 5),
          _podium('1', 'EcoNina', '980 XP', const Color(0xFFFFD452), 98), const SizedBox(width: 5),
          _podium('3', 'GuiFolha', '720 XP', const Color(0xFFD7965D), 66),
        ]),
        const SizedBox(height: 11),
        GamePanel(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), child: Column(children: [
          for (final entry in _rankingRows()) _rankRow(entry.$1, entry.$2, entry.$3, entry.$4),
        ])),
        const SizedBox(height: 8),
        const Text('Classificação ilustrativa. O ranking online será conectado depois.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, shadows: [Shadow(color: GamePalette.wood, blurRadius: 4)])),
      ]));

  List<(int, String, int, bool)> _rankingRows() {
    final player = (3, widget.store.playerName.isEmpty ? 'Visitante' : widget.store.playerName, widget.store.xp, true);
    if (_tab == 1) return [player, (4, 'LiaVerde', 410, false), (5, 'GuiFolha', 365, false)];
    if (_tab == 2) return [(2, 'EcoNina', 4980, false), player, (4, 'FerriJL670', 3554, false), (5, 'MarcPT292', 2474, false)];
    return [(4, 'FerriJL670', 554, false), player, (6, 'MarcPT292', 474, false), (7, 'MiguelAR868', 373, false), (8, 'LuaDoVale', 325, false)];
  }

  Widget _podium(String place, String name, String xp, Color color, double height) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Text(
              place == '1' ? '👑' : place,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: GamePalette.ink,
                fontSize: 19,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: GamePalette.ink, fontSize: 11, fontWeight: FontWeight.w900)),
          Text(xp, style: const TextStyle(color: GamePalette.forestLight, fontSize: 10, fontWeight: FontWeight.w900)),
          Container(
            width: 92,
            height: height,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: .66)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border.all(color: GamePalette.wood, width: 2),
            ),
            child: Center(
              child: Text(
                place,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _rankRow(int pos, String name, int points, bool isUser) => Container(padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 7), decoration: BoxDecoration(color: isUser ? const Color(0xFFDDF3B9) : Colors.transparent, border: const Border(bottom: BorderSide(color: Color(0xFFE7D4A5)))), child: Row(children: [CircleAvatar(radius: 17, backgroundColor: const Color(0xFF83CDE8), child: Text('$pos', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))), const SizedBox(width: 9), Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w900, color: isUser ? GamePalette.forestLight : GamePalette.ink))), Text('$points XP', style: const TextStyle(color: GamePalette.ocean, fontWeight: FontWeight.w900))]));
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.store, required this.audio});
  final GameStore store;
  final GameAudio audio;
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _filter = 'Tudo';
  static const _items = <({String id, String name, String desc, int price, int sprite, String group})>[
    (id: 'bottle', name: 'Garrafa da trilha', desc: 'Uma companheira reutilizável para a aventura.', price: 120, sprite: 0, group: 'Aventura'),
    (id: 'seeds', name: 'Kit de sementes', desc: 'Uma seleção ilustrativa para o seu jardim.', price: 150, sprite: 1, group: 'Plantio'),
    (id: 'backpack', name: 'Mochila exploradora', desc: 'Leve seu caderno de campo com estilo.', price: 260, sprite: 2, group: 'Aventura'),
    (id: 'gloves', name: 'Luvas de plantio', desc: 'Para cuidar da horta com segurança.', price: 180, sprite: 3, group: 'Plantio'),
    (id: 'boots', name: 'Botas de trilha', desc: 'Prontas para caminhar por novos biomas.', price: 320, sprite: 4, group: 'Aventura'),
    (id: 'hat', name: 'Chapéu guardião', desc: 'Um acessório para proteger o explorador do sol.', price: 220, sprite: 5, group: 'Aventura'),
  ];

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: widget.store, builder: (context, _) {
        final shown = _items.where((item) => _filter == 'Tudo' || item.group == _filter).toList();
        return _pageFrame(store: widget.store, audio: widget.audio, title: 'Loja da floresta', background: 'assets/screens/menu-background.png', onBack: () => _popOrMenu(context, widget.audio), body: Column(children: [
          GamePanel(padding: const EdgeInsets.all(12), child: Column(children: [const Text('Provisões para a expedição', style: TextStyle(color: GamePalette.ink, fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 8), CurrencyPill(coins: widget.store.coins, crystals: widget.store.crystals), const SizedBox(height: 9), Wrap(spacing: 6, children: ['Tudo', 'Aventura', 'Plantio'].map((name) => ChoiceChip(label: Text(name), selected: _filter == name, selectedColor: const Color(0xFF9CDA50), onSelected: (_) { widget.audio.click(); setState(() => _filter = name); })).toList())])),
          const SizedBox(height: 12),
          for (var i = 0; i < shown.length; i++) ...[
            Reveal(reduceMotion: widget.store.settings.reduceMotion, delay: Duration(milliseconds: i * 55), child: _shopItem(context, shown[i])),
            const SizedBox(height: 10),
          ],
        ]));
      });

  Widget _shopItem(BuildContext context, ({String id, String name, String desc, int price, int sprite, String group}) item) {
    final owned = widget.store.ownedItems.contains(item.id);
    return FloatingGameCard(enabled: !widget.store.settings.reduceMotion, child: GamePanel(padding: const EdgeInsets.all(12), child: Row(children: [
      SizedBox(width: 112, child: SpriteCell(asset: 'assets/ui/eco-shop-items.png', index: item.sprite)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontSize: 16, color: GamePalette.ink, fontWeight: FontWeight.w900)), Text(item.desc, style: const TextStyle(color: GamePalette.ink, fontSize: 11, height: 1.2)), const SizedBox(height: 7), GameButton(label: owned ? 'Adquirido' : '🪙 ${item.price}', audio: widget.audio, kind: owned ? ButtonKind.blue : ButtonKind.green, height: 43, textSize: 14, onPressed: owned ? null : () async {
        final ok = await widget.store.buyItem(item.id, item.price);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? '${item.name} adicionado à mochila!' : 'Saldo insuficiente para este item.')));
      })])),
    ])));
  }
}

class VictoryResult {
  const VictoryResult({required this.level, required this.stars, required this.coins, required this.crystals});
  final int level;
  final int stars;
  final int coins;
  final int crystals;
}

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key, required this.store, required this.audio, required this.result});
  final GameStore store;
  final GameAudio audio;
  final VictoryResult result;

  Future<void> _home(BuildContext context) async {
    await audio.setMenuTrack();
    if (context.mounted) Navigator.of(context).pushNamedAndRemoveUntil('/menu', (_) => false);
  }

  Future<void> _next(BuildContext context) async {
    if (result.level >= 15) {
      Navigator.of(context).popUntil((route) => route.settings.name == '/phase-map' || route.isFirst);
      return;
    }
    final nextLevel = result.level + 1;
    await audio.setPhaseTrack(nextLevel);
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    navigator.popUntil((route) => route.settings.name == '/phase-map' || route.isFirst);
    navigator.pushNamed('/phase', arguments: nextLevel);
  }

  Future<void> _replay(BuildContext context) async {
    await audio.setPhaseTrack(result.level);
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    navigator.popUntil((route) => route.settings.name == '/phase-map' || route.isFirst);
    navigator.pushNamed('/phase', arguments: result.level);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => Scaffold(
          backgroundColor: GamePalette.forest,
          body: GameBackdrop(
            asset: 'assets/screens/victory-background.png',
            dark: true,
            reduceMotion: store.settings.reduceMotion,
            child: Stack(
              children: [
                if (!store.settings.reduceMotion)
                  const Positioned.fill(child: LeafConfetti()),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boardHeight = math.min(
                        (constraints.maxHeight - 8) / 1.19,
                        constraints.maxWidth / .571,
                      );
                      final boardWidth = boardHeight * .571;
                      final controlsHeight = boardWidth / 3;
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: boardWidth,
                              height: boardHeight,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'assets/ui/victory-board-rope-v2.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    left: boardWidth * .14,
                                    right: boardWidth * .14,
                                    top: boardHeight * .33,
                                    height: boardHeight * .055,
                                    child: _VictoryTitle(level: result.level),
                                  ),
                                  Positioned(
                                    left: boardWidth * .2,
                                    right: boardWidth * .2,
                                    top: boardHeight * .39,
                                    height: boardHeight * .045,
                                    child: Text(
                                      '${phaseById(result.level).theme.toUpperCase()}  ·  FASE ${result.level}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF9C6239),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: boardWidth * .2,
                                    right: boardWidth * .2,
                                    top: boardHeight * .455,
                                    height: boardHeight * .19,
                                    child: GamePanel(
                                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                                      color: const Color(0xFFEBD391),
                                      borderColor: const Color(0xFFD1A65B),
                                      radius: 22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('Suas recompensas', style: TextStyle(color: GamePalette.wood, fontSize: 16, fontWeight: FontWeight.w900)),
                                          const SizedBox(height: 3),
                                          Text(List<String>.filled(result.stars, '⭐').join(' '), style: const TextStyle(fontSize: 15, height: 1)),
                                          const SizedBox(height: 4),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '🪙 ${result.coins} ouro     💎 ${result.crystals} gemas',
                                              style: const TextStyle(color: GamePalette.ink, fontSize: 13, fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: boardWidth * .23,
                                    right: boardWidth * .23,
                                    top: boardHeight * .68,
                                    height: boardHeight * .085,
                                    child: GameButton(
                                      label: result.level < 15 ? 'Próxima fase' : 'Trilha concluída!',
                                      audio: audio,
                                      kind: ButtonKind.green,
                                      height: boardHeight * .085,
                                      textSize: boardWidth * .052,
                                      onPressed: () => _next(context),
                                    ),
                                  ),
                                  Positioned(
                                    left: boardWidth * .23,
                                    right: boardWidth * .23,
                                    top: boardHeight * .79,
                                    height: boardHeight * .085,
                                    child: GameButton(
                                      label: 'Início',
                                      audio: audio,
                                      kind: ButtonKind.blue,
                                      height: boardHeight * .085,
                                      textSize: boardWidth * .057,
                                      onPressed: () => _home(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: boardWidth,
                              height: controlsHeight,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset('assets/ui/victory-controls.png', fit: BoxFit.fill),
                                  ),
                                  _control(
                                    boardWidth,
                                    controlsHeight,
                                    left: .115,
                                    icon: store.settings.soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                                    label: store.settings.soundOn ? 'Som' : 'Som off',
                                    active: store.settings.soundOn,
                                    onTap: () => store.saveSetting('soundOn', !store.settings.soundOn),
                                  ),
                                  _control(
                                    boardWidth,
                                    controlsHeight,
                                    left: .315,
                                    icon: store.settings.musicOn ? Icons.music_note_rounded : Icons.music_off_rounded,
                                    label: store.settings.musicOn ? 'Música' : 'Música off',
                                    active: store.settings.musicOn,
                                    onTap: () async {
                                      final value = !store.settings.musicOn;
                                      await store.saveSetting('musicOn', value);
                                      await audio.setMusicEnabled(value);
                                    },
                                  ),
                                  _control(
                                    boardWidth,
                                    controlsHeight,
                                    left: .515,
                                    icon: Icons.help_rounded,
                                    label: 'Ajuda',
                                    active: true,
                                    onTap: () => showDialog<void>(
                                      context: context,
                                      builder: (_) => const _HelpDialog(),
                                    ),
                                  ),
                                  _control(
                                    boardWidth,
                                    controlsHeight,
                                    left: .715,
                                    icon: Icons.replay_rounded,
                                    label: 'Repetir',
                                    active: true,
                                    blue: true,
                                    onTap: () => _replay(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _control(double boardWidth, double panelHeight, {required double left, required IconData icon, required String label, required bool active, required VoidCallback onTap, bool blue = false}) {
        final diameter = boardWidth * .16;
        return Positioned(left: boardWidth * left, top: panelHeight * .13, width: diameter, height: panelHeight * .75, child: Column(children: [
          GestureDetector(onTap: () { audio.click(); onTap(); }, child: Container(width: diameter, height: diameter, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: !active ? const [Color(0xFFFF655E), Color(0xFFD51B29), Color(0xFF9C0C19)] : blue ? const [Color(0xFF61E9FF), Color(0xFF079DDD), Color(0xFF0862AF)] : const [Color(0xFFB5F928), Color(0xFF55C900), Color(0xFF198000)], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: !active ? const Color(0xFF870E1B) : const Color(0xFF4E4A17), width: 2), boxShadow: const [BoxShadow(color: Color(0x88442410), blurRadius: 3, offset: Offset(0, 3))]), child: Icon(icon, color: Colors.white, size: diameter * .56))),
          const SizedBox(height: 3),
          FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1, style: const TextStyle(color: GamePalette.wood, fontWeight: FontWeight.w900, fontSize: 10))),
        ]));
  }
}

class _VictoryTitle extends StatefulWidget {
  const _VictoryTitle({required this.level});
  final int level;
  @override
  State<_VictoryTitle> createState() => _VictoryTitleState();
}

class _VictoryTitleState extends State<_VictoryTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 950))..forward();
  late final Animation<double> _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _scale, child: FittedBox(fit: BoxFit.scaleDown, child: Text('Você venceu!', maxLines: 1, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFF29A34), fontSize: 27, fontWeight: FontWeight.w900, shadows: [Shadow(color: Color(0xFF814020), blurRadius: 2, offset: Offset(0, 3)), Shadow(color: Colors.white, blurRadius: 1)]))));
}
