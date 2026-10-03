class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.explanation,
    this.hint,
    this.emojis,
  });

  final String prompt;
  final List<String> options;
  final int answerIndex;

  /// Shown when the child answers correctly.
  final String explanation;

  /// Shown after a gentle miss.
  final String? hint;

  /// Optional decorative emoji per option (same order as [options]).
  final List<String>? emojis;

  bool isCorrect(int index) => index == answerIndex;

  String emojiFor(int index) {
    final list = emojis;
    if (list == null || index >= list.length) return '';
    return list[index];
  }
}
