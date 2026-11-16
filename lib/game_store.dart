import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  bool soundOn = true;
  bool musicOn = true;
  bool reduceMotion = false;
  bool largeText = false;
  double musicVolume = .48;
  double effectsVolume = .75;
  String language = 'Português';
}

class GameStore extends ChangeNotifier {
  GameStore(this._prefs);
  final SharedPreferencesAsync _prefs;

  final GameSettings settings = GameSettings();
  final Map<int, int> completedLevels = {};
  final Set<String> ownedItems = {};
  int unlockedThrough = 1;
  int xp = 0;
  int coins = 0;
  int crystals = 0;
  int correctAnswers = 0;
  int totalAttempts = 0;
  String playerName = '';
  String playerEmail = '';
  bool rememberMe = true;
  bool _loaded = false;

  bool get isLoaded => _loaded;
  int get completedCount => completedLevels.length;

  static Future<GameStore> load() async {
    final prefs = SharedPreferencesAsync();
    final store = GameStore(prefs);
    store.settings.soundOn = await prefs.getBool('soundOn') ?? true;
    store.settings.musicOn = await prefs.getBool('musicOn') ?? true;
    store.settings.reduceMotion = await prefs.getBool('reduceMotion') ?? false;
    store.settings.largeText = await prefs.getBool('largeText') ?? false;
    store.settings.musicVolume = await prefs.getDouble('musicVolume') ?? .48;
    store.settings.effectsVolume = await prefs.getDouble('effectsVolume') ?? .75;
    store.settings.language = await prefs.getString('language') ?? 'Português';
    store.playerName = await prefs.getString('playerName') ?? '';
    store.playerEmail = await prefs.getString('playerEmail') ?? '';
    store.rememberMe = await prefs.getBool('rememberMe') ?? true;
    store.coins = await prefs.getInt('coins') ?? 0;
    store.crystals = await prefs.getInt('crystals') ?? 0;
    store.xp = await prefs.getInt('xp') ?? 0;
    store.correctAnswers = await prefs.getInt('correctAnswers') ?? 0;
    store.totalAttempts = await prefs.getInt('totalAttempts') ?? 0;
    final rawProgress = await prefs.getString('completedLevels');
    if (rawProgress != null) {
      try {
        final values = Map<String, dynamic>.from(jsonDecode(rawProgress) as Map);
        for (final entry in values.entries) {
          store.completedLevels[int.parse(entry.key)] = (entry.value as num).toInt();
        }
      } catch (_) {
        store.completedLevels.clear();
      }
    }
    final rawOwned = await prefs.getStringList('ownedItems') ?? const <String>[];
    store.ownedItems.addAll(rawOwned);
    store.unlockedThrough = (await prefs.getInt('unlockedThrough') ?? 1).clamp(1, 15).toInt();
    store._loaded = true;
    return store;
  }

  Future<void> saveSetting(String key, Object value) async {
    switch (key) {
      case 'soundOn':
        settings.soundOn = value as bool;
        await _prefs.setBool(key, settings.soundOn);
        break;
      case 'musicOn':
        settings.musicOn = value as bool;
        await _prefs.setBool(key, settings.musicOn);
        break;
      case 'reduceMotion':
        settings.reduceMotion = value as bool;
        await _prefs.setBool(key, settings.reduceMotion);
        break;
      case 'largeText':
        settings.largeText = value as bool;
        await _prefs.setBool(key, settings.largeText);
        break;
      case 'musicVolume':
        settings.musicVolume = (value as num).toDouble().clamp(0, 1).toDouble();
        await _prefs.setDouble(key, settings.musicVolume);
        break;
      case 'effectsVolume':
        settings.effectsVolume = (value as num).toDouble().clamp(0, 1).toDouble();
        await _prefs.setDouble(key, settings.effectsVolume);
        break;
      case 'language':
        settings.language = value as String;
        await _prefs.setString(key, settings.language);
        break;
    }
    notifyListeners();
  }

  Future<void> saveProfile({required String name, String email = ''}) async {
    playerName = name.trim();
    playerEmail = email.trim();
    await _prefs.setString('playerName', playerName);
    await _prefs.setString('playerEmail', playerEmail);
    notifyListeners();
  }

  Future<void> startFreshSession({required String name, String email = ''}) async {
    completedLevels.clear();
    ownedItems.clear();
    unlockedThrough = 1;
    xp = 0;
    coins = 0;
    crystals = 0;
    correctAnswers = 0;
    totalAttempts = 0;
    await _prefs.setStringList('claimedMissions', const <String>[]);
    await _prefs.setStringList('ownedItems', const <String>[]);
    await saveProfile(name: name, email: email);
    await _persistProgress();
    notifyListeners();
  }

  Future<void> setRememberMe(bool value) async {
    rememberMe = value;
    await _prefs.setBool('rememberMe', value);
    notifyListeners();
  }

  Future<({bool isNew, int stars, int coins, int crystals})> completeLevel({
    required int level,
    required int stars,
    required int correct,
    required int attempts,
  }) async {
    final wasComplete = completedLevels.containsKey(level);
    final bestStars = (completedLevels[level] ?? 0).compareTo(stars) > 0 ? completedLevels[level]! : stars;
    completedLevels[level] = bestStars;
    unlockedThrough = unlockedThrough > level + 1 ? unlockedThrough : (level + 1).clamp(1, 15).toInt();
    final earnedCoins = 80 + stars * 20;
    final earnedCrystals = 3 + stars;
    xp += 40 + stars * 15;
    correctAnswers += correct;
    totalAttempts += attempts;
    coins += earnedCoins;
    crystals += earnedCrystals;
    await _persistProgress();
    notifyListeners();
    return (isNew: !wasComplete, stars: bestStars, coins: earnedCoins, crystals: earnedCrystals);
  }

  Future<void> _persistProgress() async {
    await _prefs.setString('completedLevels', jsonEncode({for (final entry in completedLevels.entries) entry.key.toString(): entry.value}));
    await _prefs.setInt('unlockedThrough', unlockedThrough);
    await _prefs.setInt('xp', xp);
    await _prefs.setInt('correctAnswers', correctAnswers);
    await _prefs.setInt('totalAttempts', totalAttempts);
    await _prefs.setInt('coins', coins);
    await _prefs.setInt('crystals', crystals);
  }

  Future<bool> buyItem(String id, int price, {bool useCrystals = false}) async {
    if (ownedItems.contains(id)) return false;
    if (useCrystals ? crystals < price : coins < price) return false;
    if (useCrystals) {
      crystals -= price;
    } else {
      coins -= price;
    }
    ownedItems.add(id);
    await _prefs.setInt('coins', coins);
    await _prefs.setInt('crystals', crystals);
    await _prefs.setStringList('ownedItems', ownedItems.toList());
    notifyListeners();
    return true;
  }

  Future<bool> claimMission(String id, int reward) async {
    final claimed = await _prefs.getStringList('claimedMissions') ?? <String>[];
    if (claimed.contains(id)) return false;
    claimed.add(id);
    coins += reward;
    await _prefs.setStringList('claimedMissions', claimed);
    await _prefs.setInt('coins', coins);
    notifyListeners();
    return true;
  }

  Future<bool> missionClaimed(String id) async => (await _prefs.getStringList('claimedMissions') ?? const <String>[]).contains(id);
}
