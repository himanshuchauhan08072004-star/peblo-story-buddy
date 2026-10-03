import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/story.dart';
import '../providers/story_provider.dart';
import '../providers/voice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_view.dart';
import '../widgets/character_avatar.dart';
import '../widgets/common.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryProvider>().confettiController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final voice = context.watch<VoiceProvider>().selected;
    final story = sp.story!;
    final wide = context.isWide;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: wide ? 60 : 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Text('✨ Adventure Complete! ✨',
                    style: PebloText.display(24, color: context.ink),
                    textAlign: TextAlign.center),
                const SizedBox(height: 18),
                CharacterAvatar(
                  character: story.character,
                  pose: CharacterPose.celebrating,
                  size: 140,
                  accent: story.theme.accent,
                ),
                const SizedBox(height: 18),
                Text(
                  story.completionLine,
                  style: PebloText.body(16, weight: FontWeight.w700, color: context.inkSoft),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _Stat(icon: '⭐', label: 'Story completed'),
                      _Stat(icon: '🎧', label: 'Narrator: ${voice?.name ?? '—'}'),
                      _Stat(
                        icon: '🧠',
                        label: 'Quiz: ${sp.quizCorrectCount}/${sp.quizLength}',
                      ),
                      _Stat(icon: '⏱', label: story.durationLabel),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    PebloButton(
                      label: 'Read Again',
                      icon: Icons.replay_rounded,
                      color: story.theme.accent,
                      onTap: sp.replay,
                    ),
                    PebloButton(
                      label: 'Choose Another Story',
                      icon: Icons.auto_stories_rounded,
                      filled: false,
                      color: story.theme.accent,
                      onTap: () {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CelebrationOverlay(controller: sp.confettiController),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(label, style: PebloText.body(13, weight: FontWeight.w700, color: context.ink)),
      ],
    );
  }
}

