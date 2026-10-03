import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/story.dart';
import '../providers/story_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/character_avatar.dart';
import '../widgets/common.dart';
import '../widgets/quiz_option.dart';
import '../widgets/shake_widget.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final story = sp.story!;
    final question = sp.currentQuestion;
    final wide = context.isWide;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: wide ? 60 : 20, vertical: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Let\'s see what you remember! ✨',
                style: PebloText.display(22, color: context.ink),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              'Question ${sp.quizIndex + 1} of ${sp.quizLength}',
              style: PebloText.body(13, color: context.inkSoft),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (sp.quizIndex + 1) / sp.quizLength,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: context.outline,
              color: story.theme.accent,
            ),
            const SizedBox(height: 24),
            CharacterAvatar(
              character: story.character,
              pose: sp.answeredCorrectly
                  ? CharacterPose.celebrating
                  : CharacterPose.thinking,
              size: 110,
              accent: story.theme.accent,
            ),
            const SizedBox(height: 20),
            Text(
              question.prompt,
              textAlign: TextAlign.center,
              style: PebloText.display(19, color: context.ink),
            ),
            const SizedBox(height: 20),
            ShakeWidget(
              shake: sp.shake,
              child: Column(
                children: List.generate(question.options.length, (i) {
                  QuizOptionState state = QuizOptionState.neutral;
                  if (sp.selectedOption != null) {
                    if (i == sp.selectedOption && sp.answeredCorrectly) {
                      state = QuizOptionState.selectedCorrect;
                    } else if (i != sp.selectedOption) {
                      state = QuizOptionState.dimmed;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: QuizOption(
                      label: question.options[i],
                      emoji: question.emojiFor(i),
                      state: state,
                      onTap: sp.selectedOption != null && sp.answeredCorrectly
                          ? null
                          : () => sp.answerQuiz(i),
                    ),
                  );
                }),
              ),
            ),
            if (sp.answeredCorrectly) ...[
              const SizedBox(height: 8),
              Text(question.explanation,
                  style: PebloText.body(14, color: context.inkSoft),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              PebloButton(
                label: sp.quizIndex < sp.quizLength - 1 ? 'Next Question' : 'See Results',
                icon: Icons.arrow_forward_rounded,
                color: story.theme.accent,
                onTap: sp.nextQuestion,
              ),
            ] else if (sp.selectedOption == null && question.hint != null) ...[
              const SizedBox(height: 4),
              Text('Almost! Try again. ${question.hint}',
                  style: PebloText.body(13, color: context.inkSoft),
                  textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
