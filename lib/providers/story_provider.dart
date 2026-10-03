import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';

import '../models/quiz_question.dart';
import '../models/story.dart';
import '../services/tts_service.dart';
import 'progress_provider.dart';
import 'voice_provider.dart';

enum ReaderStage { scenes, quiz, complete }

class StoryProvider extends ChangeNotifier {
  StoryProvider(this._tts, this._voiceProvider, this._progress) {
    _tts.onComplete = _handleSpeechComplete;
    _tts.onError = _handleSpeechError;
  }

  final TtsService _tts;
  final VoiceProvider _voiceProvider;
  final ProgressProvider _progress;

  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  Story? _story;
  Story? get story => _story;

  int _sceneIndex = 0;
  int get sceneIndex => _sceneIndex;
  StoryScene get currentScene => _story!.scenes[_sceneIndex];
  bool get isLastScene => _sceneIndex >= _story!.scenes.length - 1;
  double get sceneProgress =>
      (_sceneIndex + 1) / (_story?.scenes.length ?? 1);

  ReaderStage _stage = ReaderStage.scenes;
  ReaderStage get stage => _stage;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  CharacterPose _pose = CharacterPose.idle;
  CharacterPose get pose => _pose;

  String? _fallbackNotice;
  String? get fallbackNotice => _fallbackNotice;

  // --- Quiz state ---
  int _quizIndex = 0;
  int get quizIndex => _quizIndex;
  QuizQuestion get currentQuestion => _story!.quiz[_quizIndex];
  int get quizLength => _story?.quiz.length ?? 0;

  int? _selectedOption;
  int? get selectedOption => _selectedOption;

  bool _answeredCorrectly = false;
  bool get answeredCorrectly => _answeredCorrectly;

  bool _shake = false;
  bool get shake => _shake;

  int _quizCorrectCount = 0;
  int get quizCorrectCount => _quizCorrectCount;

  DateTime? _listenStartedAt;

  void openStory(Story story) {
    _story = story;
    _sceneIndex = 0;
    _stage = ReaderStage.scenes;
    _isPlaying = false;
    _isPaused = false;
    _pose = story.scenes.first.pose;
    _quizIndex = 0;
    _selectedOption = null;
    _answeredCorrectly = false;
    _quizCorrectCount = 0;
    _fallbackNotice = null;
    notifyListeners();
  }

  Future<void> playScene() async {
    if (_story == null) return;
    await _voiceProvider.applyToEngine();
    final voice = _voiceProvider.selected;
    if (voice != null &&
        !voice.hasDeviceVoice &&
        !_voiceProvider.usingRealVoices &&
        _fallbackNotice == null) {
      _fallbackNotice =
          "Using this device's default voice — narrator personalities still "
          'vary in pitch and pace.';
    }

    _isPlaying = true;
    _isPaused = false;
    _pose = CharacterPose.talking;
    _listenStartedAt = DateTime.now();
    notifyListeners();

    await _tts.speak(currentScene.text);
  }

  Future<void> pause() async {
    if (!_isPlaying) return;
    await _tts.pause();
    _isPaused = true;
    _isPlaying = false;
    _pose = _story != null ? currentScene.pose : CharacterPose.idle;
    _tallyListenTime();
    notifyListeners();
  }

  Future<void> resume() async {
    if (_isPaused) {
      await playScene();
    }
  }

  Future<void> stopAndRestart() async {
    await _tts.stop();
    _tallyListenTime();
    _sceneIndex = 0;
    _isPlaying = false;
    _isPaused = false;
    _stage = ReaderStage.scenes;
    _pose = _story?.scenes.first.pose ?? CharacterPose.idle;
    notifyListeners();
  }

  Future<void> goToScene(int index) async {
    if (_story == null) return;
    await _tts.stop();
    _sceneIndex = index.clamp(0, _story!.scenes.length - 1);
    _isPlaying = false;
    _isPaused = false;
    _pose = currentScene.pose;
    notifyListeners();
  }

  void _handleSpeechComplete() {
    _tallyListenTime();
    _isPlaying = false;
    _pose = _story != null ? currentScene.pose : CharacterPose.idle;

    if (_story == null) {
      notifyListeners();
      return;
    }

    if (!isLastScene) {
      _sceneIndex += 1;
      _pose = currentScene.pose;
      notifyListeners();
      // Auto-advance narration to the next scene.
      playScene();
    } else if (_story!.quiz.isNotEmpty) {
      _stage = ReaderStage.quiz;
      notifyListeners();
    } else {
      _completeStory();
    }
  }

  void _handleSpeechError(String message) {
    _isPlaying = false;
    _fallbackNotice = "Narration hit a snag — you can still read along.";
    notifyListeners();
  }

  void _tallyListenTime() {
    final start = _listenStartedAt;
    if (start == null) return;
    final seconds = DateTime.now().difference(start).inSeconds;
    _listenStartedAt = null;
    if (seconds > 0) {
      _progress.addListenSeconds(seconds);
    }
  }

  Future<void> answerQuiz(int optionIndex) async {
    if (_story == null || _selectedOption != null) return;
    _selectedOption = optionIndex;
    final correct = currentQuestion.isCorrect(optionIndex);
    _answeredCorrectly = correct;
    await _progress.recordAnswer(correct: correct);

    if (correct) {
      _quizCorrectCount += 1;
      confettiController.play();
      notifyListeners();
    } else {
      _shake = true;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 450));
      _shake = false;
      // Allow another attempt instead of locking the child out.
      _selectedOption = null;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_story == null) return;
    if (_quizIndex < _story!.quiz.length - 1) {
      _quizIndex += 1;
      _selectedOption = null;
      _answeredCorrectly = false;
      notifyListeners();
    } else {
      _completeStory();
    }
  }

  void _completeStory() {
    if (_story == null) return;
    _stage = ReaderStage.complete;
    _progress.markCompleted(_story!.id);
    notifyListeners();
  }

  Future<void> replay() async {
    if (_story == null) return;
    openStory(_story!);
    await playScene();
  }

  Future<void> disposeSession() async {
    await _tts.stop();
    _tallyListenTime();
    _story = null;
    notifyListeners();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
}
