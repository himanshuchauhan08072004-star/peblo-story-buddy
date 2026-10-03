import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// All local persistence in one place — completed stories, narrator choice,
/// theme mode, and lightweight listening-time/answer counters.
class StorageService {
  static const _kCompleted = 'peblo.completedStories';
  static const _kVoiceId = 'peblo.voiceId';
  static const _kSpeed = 'peblo.speed';
  static const _kThemeMode = 'peblo.themeMode'; // 'light' | 'dark' | 'system'
  static const _kListenSeconds = 'peblo.listenSeconds';
  static const _kQuestionsAnswered = 'peblo.questionsAnswered';
  static const _kQuestionsCorrect = 'peblo.questionsCorrect';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    final p = _prefs;
    if (p == null) {
      throw StateError('StorageService.init() must be called first.');
    }
    return p;
  }

  Set<String> getCompletedStoryIds() {
    final raw = _p.getString(_kCompleted);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as List).cast<String>().toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> markStoryCompleted(String id) async {
    final set = getCompletedStoryIds()..add(id);
    await _p.setString(_kCompleted, jsonEncode(set.toList()));
  }

  String? getVoiceId() => _p.getString(_kVoiceId);

  Future<void> setVoiceId(String id) => _p.setString(_kVoiceId, id);

  double getSpeed() => _p.getDouble(_kSpeed) ?? 0.85;

  Future<void> setSpeed(double speed) => _p.setDouble(_kSpeed, speed);

  String getThemeMode() => _p.getString(_kThemeMode) ?? 'system';

  Future<void> setThemeMode(String mode) => _p.setString(_kThemeMode, mode);

  int getListenSeconds() => _p.getInt(_kListenSeconds) ?? 0;

  Future<void> addListenSeconds(int seconds) async {
    await _p.setInt(_kListenSeconds, getListenSeconds() + seconds);
  }

  int getQuestionsAnswered() => _p.getInt(_kQuestionsAnswered) ?? 0;
  int getQuestionsCorrect() => _p.getInt(_kQuestionsCorrect) ?? 0;

  Future<void> recordAnswer({required bool correct}) async {
    await _p.setInt(_kQuestionsAnswered, getQuestionsAnswered() + 1);
    if (correct) {
      await _p.setInt(_kQuestionsCorrect, getQuestionsCorrect() + 1);
    }
  }
}
