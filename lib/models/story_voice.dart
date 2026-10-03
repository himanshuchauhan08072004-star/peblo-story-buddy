enum VoicePersonality { warm, gentle, adventurous, storyteller, bright, energetic }

/// A narrator personality the child can pick, backed (when possible) by a
/// real on-device/browser TTS voice discovered at runtime.
class StoryVoice {
  StoryVoice({
    required this.id,
    required this.name,
    required this.personalityLabel,
    required this.ageStyle,
    required this.description,
    required this.icon,
    required this.pitch,
    required this.rate,
    required this.localeHints,
    required this.genderHints,
    this.deviceVoiceName,
    this.deviceVoiceLocale,
  });

  final String id;
  final String name;

  /// e.g. "Warm & Magical"
  final String personalityLabel;

  /// "Female" / "Male" / "Kid"
  final String ageStyle;
  final String description;
  final String icon;

  /// Base pitch/rate this personality prefers (further scaled by the
  /// in-session speed control).
  final double pitch;
  final double rate;

  /// Locale substrings used to match a real device voice, in priority order.
  final List<String> localeHints;

  /// Name substrings (case-insensitive) that hint at gender/age in the
  /// platform's voice name, used only to pick among matching locales.
  final List<String> genderHints;

  /// Filled in after querying `flutterTts.getVoices()`. Null means "no
  /// distinct device voice found — falls back to the platform default".
  String? deviceVoiceName;
  String? deviceVoiceLocale;

  bool get hasDeviceVoice => deviceVoiceName != null;
}
