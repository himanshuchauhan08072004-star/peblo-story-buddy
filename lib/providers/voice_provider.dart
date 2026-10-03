import 'package:flutter/foundation.dart';

import '../models/story_voice.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import '../services/voice_service.dart';

const kPreviewLine =
    'Once upon a time, a little star fell from the sky and landed softly '
    'in the woods.';

class VoiceProvider extends ChangeNotifier {
  VoiceProvider(this._tts, this._voiceService, this._storage);

  final TtsService _tts;
  final VoiceService _voiceService;
  final StorageService _storage;

  List<StoryVoice> _voices = [];
  List<StoryVoice> get voices => _voices;

  StoryVoice? _selected;
  StoryVoice? get selected => _voices.isEmpty ? null : (_selected ?? _voices.first);

  double _speed = 0.85;
  double get speed => _speed;

  bool _previewingId(String id) => _previewId == id;
  bool isPreviewing(String id) => _previewingId(id) && _previewActive;
  String? _previewId;
  bool _previewActive = false;

  bool _ready = false;
  bool get ready => _ready;

  bool get usingRealVoices => _voiceService.usingRealVoices;

  Future<void> initialize() async {
    _voices = await _voiceService.discover();
    _speed = _storage.getSpeed();

    final savedId = _storage.getVoiceId();
    if (savedId != null) {
      final match = _voices.where((v) => v.id == savedId);
      if (match.isNotEmpty) _selected = match.first;
    }
    _selected ??= _voices.isNotEmpty ? _voices.first : null;

    _ready = true;
    notifyListeners();
  }

  Future<void> select(StoryVoice voice) async {
    _selected = voice;
    notifyListeners();
    await _storage.setVoiceId(voice.id);
  }

  Future<void> setSpeed(double value) async {
    _speed = value;
    notifyListeners();
    await _storage.setSpeed(value);
  }

  /// Applies the currently selected narrator's voice/pitch/rate to the TTS
  /// engine. Call before every `speak()`.
  Future<void> applyToEngine() async {
    final v = selected;
    if (v == null) return;
    if (v.hasDeviceVoice) {
      await _tts.setVoice(name: v.deviceVoiceName, locale: v.deviceVoiceLocale);
    } else {
      await _tts.setLanguage('en-US');
    }
    await _tts.setPitch(v.pitch);
    await _tts.setRate((v.rate * (_speed / 0.85)).clamp(0.3, 1.0));
  }

  Future<void> preview(StoryVoice voice) async {
    if (_previewActive) {
      await stopPreview();
    }
    await select(voice);
    _previewId = voice.id;
    _previewActive = true;
    notifyListeners();

    await applyToEngine();
    // Save whatever handler is already wired up (e.g. the story reader's
    // scene-advance logic) and restore it once the preview finishes, so a
    // narrator preview never breaks story narration.
    final previousOnComplete = _tts.onComplete;
    _tts.onComplete = () {
      _previewActive = false;
      notifyListeners();
      _tts.onComplete = previousOnComplete;
    };
    await _tts.speak(kPreviewLine);
  }

  Future<void> stopPreview() async {
    await _tts.stop();
    _previewActive = false;
    notifyListeners();
  }
}
