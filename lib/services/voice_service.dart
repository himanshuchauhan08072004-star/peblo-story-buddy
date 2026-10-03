import '../data/voice_catalog.dart';
import '../models/story_voice.dart';
import 'tts_service.dart';

/// Discovers real device/browser TTS voices and intelligently maps them onto
/// the six narrator personalities. Never assumes six distinct voices exist —
/// gracefully falls back to fewer distinct timbres (still varying pitch and
/// rate per personality) rather than crashing or lying about it.
class VoiceService {
  VoiceService(this._tts);

  final TtsService _tts;

  List<StoryVoice> _voices = [];
  bool _usingRealVoices = false;

  List<StoryVoice> get voices => _voices;

  /// True if at least one narrator was matched to a distinct on-device voice.
  bool get usingRealVoices => _usingRealVoices;

  Future<List<StoryVoice>> discover() async {
    final catalog = buildVoiceCatalog();
    final deviceVoices = await _tts.getVoices();

    if (deviceVoices.isEmpty) {
      _voices = catalog;
      _usingRealVoices = false;
      return _voices;
    }

    final used = <String>{};

    for (final voice in catalog) {
      final match = _bestMatch(deviceVoices, voice, used);
      if (match != null) {
        voice.deviceVoiceName = match['name'];
        voice.deviceVoiceLocale = match['locale'];
        used.add(match['name']!);
        _usingRealVoices = true;
      }
    }

    _voices = catalog;
    return _voices;
  }

  Map<String, String>? _bestMatch(
    List<Map<String, String>> deviceVoices,
    StoryVoice voice,
    Set<String> used,
  ) {
    // Pass 1: locale match + gender/age hint in the voice name, unused.
    for (final locale in voice.localeHints) {
      for (final dv in deviceVoices) {
        if (used.contains(dv['name'])) continue;
        if (!(dv['locale'] ?? '').toLowerCase().contains(locale.toLowerCase())) {
          continue;
        }
        final name = (dv['name'] ?? '').toLowerCase();
        final hasHint = voice.genderHints.any(name.contains);
        if (hasHint) return dv;
      }
    }
    // Pass 2: locale match only, unused.
    for (final locale in voice.localeHints) {
      for (final dv in deviceVoices) {
        if (used.contains(dv['name'])) continue;
        if ((dv['locale'] ?? '').toLowerCase().contains(locale.toLowerCase())) {
          return dv;
        }
      }
    }
    // Pass 3: any unused voice at all, so every narrator still sounds
    // distinct from ones already claimed where possible.
    for (final dv in deviceVoices) {
      if (!used.contains(dv['name'])) return dv;
    }
    // Pass 4: platform truly has one voice — reuse it; pitch/rate still vary.
    return deviceVoices.isNotEmpty ? deviceVoices.first : null;
  }
}
