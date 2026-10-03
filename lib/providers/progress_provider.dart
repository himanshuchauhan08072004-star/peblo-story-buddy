import 'package:flutter/foundation.dart';

import '../services/storage_service.dart';

class StoryBadge {
  const StoryBadge({required this.icon, required this.label, required this.earned});
  final String icon;
  final String label;
  final bool earned;
}

class ProgressProvider extends ChangeNotifier {
  ProgressProvider(this._storage);

  final StorageService _storage;

  Set<String> get completedStoryIds => _storage.getCompletedStoryIds();
  int get storiesCompleted => completedStoryIds.length;
  int get listenMinutes => (_storage.getListenSeconds() / 60).round();
  int get questionsAnswered => _storage.getQuestionsAnswered();
  int get questionsCorrect => _storage.getQuestionsCorrect();

  bool isCompleted(String storyId) => completedStoryIds.contains(storyId);

  Future<void> markCompleted(String storyId) async {
    await _storage.markStoryCompleted(storyId);
    notifyListeners();
  }

  Future<void> addListenSeconds(int seconds) async {
    await _storage.addListenSeconds(seconds);
    notifyListeners();
  }

  Future<void> recordAnswer({required bool correct}) async {
    await _storage.recordAnswer(correct: correct);
    notifyListeners();
  }

  List<StoryBadge> get badges {
    final completed = storiesCompleted;
    final answered = questionsAnswered;
    return [
      StoryBadge(icon: '🌟', label: 'First Story', earned: completed >= 1),
      StoryBadge(icon: '📚', label: 'Story Explorer', earned: completed >= 3),
      StoryBadge(icon: '🎧', label: 'Great Listener', earned: listenMinutes >= 10),
      StoryBadge(icon: '🧠', label: 'Story Detective', earned: answered >= 5),
      StoryBadge(icon: '✨', label: 'Adventure Master', earned: completed >= 5),
    ];
  }
}
