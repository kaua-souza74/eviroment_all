import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio_service.dart';
import 'game_store.dart';
import 'game_screens.dart';
import 'phase_screen.dart';
import 'route_history.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  }
  final store = await GameStore.load();
  runApp(EnviromentAllApp(store: store));
}

class EnviromentAllApp extends StatefulWidget {
  const EnviromentAllApp({super.key, required this.store});
  final GameStore store;
  @override
  State<EnviromentAllApp> createState() => _EnviromentAllAppState();
}

class _EnviromentAllAppState extends State<EnviromentAllApp> with WidgetsBindingObserver {
  late final GameAudio _audio = GameAudio();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await _audio.initialize(widget.store);
    } catch (error, stackTrace) {
      debugPrint('Falha ao iniciar o áudio: $error\n$stackTrace');
    }
  }

  @override
  void dispose() { WidgetsBinding.instance.removeObserver(this); _audio.dispose(); super.dispose(); }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) { _audio.onAppResumed(); }
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) { _audio.onAppPaused(); }
  }

  Route<dynamic> _route(RouteSettings settings) {
    final name = settings.name ?? '/intro';
    Widget page;
    switch (name) {
      case '/login': page = LoginScreen(store: widget.store, audio: _audio); break;
      case '/signup': page = SignupScreen(store: widget.store, audio: _audio); break;
      case '/menu': page = MenuScreen(store: widget.store, audio: _audio); break;
      case '/phase-map': page = PhaseMapScreen(store: widget.store, audio: _audio); break;
      case '/phase': page = PhaseScreen(store: widget.store, audio: _audio, level: (settings.arguments as int?) ?? 1); break;
      case '/victory': page = VictoryScreen(store: widget.store, audio: _audio, result: (settings.arguments as VictoryResult?) ?? const VictoryResult(level: 1, stars: 1, coins: 0, crystals: 0)); break;
      case '/settings': page = SettingsScreen(store: widget.store, audio: _audio); break;
      case '/achievements': page = AchievementsScreen(store: widget.store, audio: _audio); break;
      case '/ranking': page = RankingScreen(store: widget.store, audio: _audio); break;
      case '/missions': page = MissionsScreen(store: widget.store, audio: _audio); break;
      case '/shop': page = ShopScreen(store: widget.store, audio: _audio); break;
      case '/intro':
      default: page = IntroScreen(store: widget.store, audio: _audio); break;
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) => MaterialApp(
        title: 'Enviroment All',
        debugShowCheckedModeBanner: false,
        initialRoute: '/intro',
        onGenerateRoute: _route,
        navigatorObservers: [RouteHistory.instance],
        builder: (context, child) {
          final scale = widget.store.settings.largeText ? 1.14 : 1.0;
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
            child: child ?? const SizedBox.shrink(),
          );
        },
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Trebuchet MS',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF159ED3),
            primary: const Color(0xFF159ED3),
            secondary: const Color(0xFF74D92B),
          ),
          scaffoldBackgroundColor: const Color(0xFF18331D),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xFF70452D)),
          ),
        ),
      ),
    );
  }
}
