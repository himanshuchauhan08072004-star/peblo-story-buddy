import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Thin wrapper around [FlutterTts]. The rest of the app never touches
/// flutter_tts directly — it goes through this service, which normalizes
/// callbacks and absorbs platform differences (especially on Web, where
/// available voices vary by browser).
class TtsService {
  TtsService() : _tts = FlutterTts();

  final FlutterTts _tts;

  VoidCallback? onStart;
  VoidCallback? onComplete;
  void Function(String message)? onError;

  bool _initialized = false;
  bool get isSpeaking => _isSpeaking;
  bool _isSpeaking = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _tts.setStartHandler(() {
      _isSpeaking = true;
      onStart?.call();
    });
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onComplete?.call();
    });
    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });
    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      onError?.call(msg.toString());
    });

    try {
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {
      // Not supported on every platform — safe to ignore.
    }
  }

  /// Returns the raw voice list from the platform, each entry typically a
  /// Map with `name` and `locale` keys. Never throws — returns an empty
  /// list if the platform can't report voices.
  Future<List<Map<String, String>>> getVoices() async {
    try {
      final raw = await _tts.getVoices;
      if (raw is! List) return [];
      return raw
          .whereType<Map>()
          .map(
            (v) => {
              'name': (v['name'] ?? '').toString(),
              'locale': (v['locale'] ?? '').toString(),
            },
          )
          .where((v) => v['name']!.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> setVoice({String? name, String? locale}) async {
    if (name == null || locale == null) return;
    try {
      await _tts.setVoice({'name': name, 'locale': locale});
    } catch (_) {
      // Fall back silently to whatever voice is already set.
    }
  }

  Future<void> setLanguage(String locale) async {
    try {
      await _tts.setLanguage(locale);
    } catch (_) {}
  }

  Future<void> setPitch(double pitch) async {
    try {
      await _tts.setPitch(pitch.clamp(0.5, 2.0));
    } catch (_) {}
  }

  Future<void> setRate(double rate) async {
    try {
      // flutter_tts rate is roughly 0.0-1.0 on most platforms.
      await _tts.setSpeechRate(rate.clamp(0.3, 1.0));
    } catch (_) {}
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (_) {
      // Pause isn't supported everywhere (e.g. some Web engines) — stop
      // is the safe fallback so we never get stuck.
      await stop();
    }
  }

  Future<void> stop() async {
    _isSpeaking = false;
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}
