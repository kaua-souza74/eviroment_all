import 'package:audioplayers/audioplayers.dart';

import 'game_data.dart';
import 'game_store.dart';

class GameAudio {
  final AudioPlayer _music = AudioPlayer(playerId: 'enviroment_music');
  final AudioPlayer _effects = AudioPlayer(playerId: 'enviroment_effects');
  GameStore? _store;
  String? _activeTrack;
  bool _initialized = false;

  String? get activeTrack => _activeTrack;

  Future<void> initialize(GameStore store) async {
    _store = store;
    await _music.setReleaseMode(ReleaseMode.loop);
    await _effects.setReleaseMode(ReleaseMode.stop);
    await _music.setVolume(store.settings.musicVolume);
    await _effects.setVolume(store.settings.effectsVolume);
    _initialized = true;
    await setMenuTrack();
  }

  Future<void> setMenuTrack() => _setTrack('Threshold_of_the_Wild.mp3');

  Future<void> setPhaseTrack(int level) => _setTrack(musicForPhase(level));

  Future<void> _setTrack(String filename) async {
    if (!_initialized) return;
    if (_activeTrack == filename) {
      if (_store?.settings.musicOn == true && _music.state != PlayerState.playing) {
        try {
          if (_music.state == PlayerState.paused) {
            await _music.resume();
          } else {
            await _music.play(AssetSource('music/$filename'));
          }
        } catch (_) {}
      }
      return;
    }
    _activeTrack = filename;
    try {
      await _music.stop();
      if (_store?.settings.musicOn == true) {
        await _music.play(AssetSource('music/$filename'));
      } else {
        await _music.setSource(AssetSource('music/$filename'));
      }
    } catch (_) {
      // Browser autoplay policies can defer playback until the first tap.
    }
  }

  Future<void> setMusicEnabled(bool enabled) async {
    if (!_initialized) return;
    if (enabled) {
      try {
        if (_music.state == PlayerState.paused) {
          await _music.resume();
        } else if (_activeTrack != null) {
          await _music.play(AssetSource('music/$_activeTrack'));
        }
      } catch (_) {}
    } else {
      await _music.pause();
    }
  }

  Future<void> setMusicVolume(double value) async {
    if (_initialized) await _music.setVolume(value.clamp(0, 1).toDouble());
  }

  Future<void> setEffectsVolume(double value) async {
    if (_initialized) await _effects.setVolume(value.clamp(0, 1).toDouble());
  }

  Future<void> click() async {
    final store = _store;
    if (!_initialized || store == null) return;
    if (store.settings.musicOn && _activeTrack != null && _music.state != PlayerState.playing) {
      try {
        if (_music.state == PlayerState.paused) {
          await _music.resume();
        } else {
          await _music.play(AssetSource('music/$_activeTrack'));
        }
      } catch (_) {}
    }
    if (!store.settings.soundOn || store.settings.effectsVolume <= 0) return;
    try {
      await _effects.stop();
      await _effects.play(AssetSource('audio/ui_click.wav'), volume: store.settings.effectsVolume);
    } catch (_) {}
  }

  Future<void> onAppPaused() async {
    if (_music.state == PlayerState.playing) await _music.pause();
  }

  Future<void> onAppResumed() async {
    if (_store?.settings.musicOn == true && _activeTrack != null && _music.state == PlayerState.paused) {
      try {
        await _music.resume();
      } catch (_) {}
    }
  }

  Future<void> dispose() async {
    await _music.dispose();
    await _effects.dispose();
  }
}
