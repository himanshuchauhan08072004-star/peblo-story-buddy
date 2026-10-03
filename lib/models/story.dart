import 'dart:math';

import 'package:flutter/material.dart';

import 'quiz_question.dart';

enum CharacterKind { pip, luna, milo, cloud, leo }

enum CharacterPose { idle, talking, happy, thinking, celebrating, surprised }

enum EnvironmentKind {
  nightForest,
  moonGarden,
  sunnyAdventure,
  cloudSky,
  secretForest,
}

class StoryTheme {
  const StoryTheme({
    required this.skyTop,
    required this.skyBottom,
    required this.accent,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color accent;
}

/// One "page" of the storybook. Narrated on its own so the scene can change
/// exactly when the narrator moves on.
class StoryScene {
  const StoryScene({
    required this.text,
    required this.prop,
    this.pose = CharacterPose.idle,
  });

  final String text;

  /// Emoji "prop" floating next to the character for this scene.
  final String prop;

  /// Emotion shown when the narrator is not actively talking.
  final CharacterPose pose;
}

class Story {
  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.character,
    required this.characterName,
    required this.category,
    required this.ageRange,
    required this.scenes,
    required this.quiz,
    required this.theme,
    required this.environment,
    required this.completionLine,
    required this.emoji,
  });

  final String id;
  final String title;
  final String description;
  final CharacterKind character;
  final String characterName;
  final String category;
  final String ageRange;
  final List<StoryScene> scenes;
  final List<QuizQuestion> quiz;
  final StoryTheme theme;
  final EnvironmentKind environment;
  final String completionLine;
  final String emoji;

  bool get isNight =>
      environment == EnvironmentKind.nightForest ||
      environment == EnvironmentKind.moonGarden ||
      environment == EnvironmentKind.secretForest;

  int get wordCount => scenes.fold<int>(
        0,
        (sum, scene) => sum + scene.text.trim().split(RegExp(r'\s+')).length,
      );

  /// Estimated from the real text: child-paced narration (~110 words/min)
  /// plus ~25 seconds per quiz question.
  int get minutes {
    final seconds = wordCount / 110 * 60 + quiz.length * 25;
    return max(1, (seconds / 60).ceil());
  }

  String get durationLabel => '$minutes min';
}
