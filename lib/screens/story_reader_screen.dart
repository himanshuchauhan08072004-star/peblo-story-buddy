import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/story_provider.dart';
import '../providers/voice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/audio_controls.dart';
import '../widgets/character_avatar.dart';
import 'completion_screen.dart';
import 'quiz_screen.dart';
import 'voice_selection_screen.dart';

class StoryReaderScreen extends StatefulWidget {
  const StoryReaderScreen({super.key});

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryProvider>().playScene();
    });
  }

  @override
  void dispose() {
    // Use a microtask-safe read since the widget tree may already be gone.
    Future.microtask(() => context.read<StoryProvider>().disposeSession());
    super.dispose();
  }

  void _openNarratorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, controller) => Container(
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: const VoiceSelectionScreen(embedded: true),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final story = sp.story;
    if (story == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBackground(
              environment: story.environment,
              theme: story.theme,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      ),
                      Expanded(
                        child: Text(
                          story.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PebloText.display(16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                if (sp.stage == ReaderStage.scenes)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressIndicator(
                      value: sp.sceneProgress,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(999),
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                    ),
                  ),
                Expanded(
                  child: switch (sp.stage) {
                    ReaderStage.scenes => _SceneView(),
                    ReaderStage.quiz => const _LightPanel(child: QuizScreen()),
                    ReaderStage.complete => const _LightPanel(child: CompletionScreen()),
                  },
                ),
                if (sp.stage == ReaderStage.scenes)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: AudioControls(
                      isPlaying: sp.isPlaying,
                      isPaused: sp.isPaused,
                      voice: context.watch<VoiceProvider>().selected,
                      speed: context.watch<VoiceProvider>().speed,
                      onPlayPause: () {
                        if (sp.isPlaying) {
                          sp.pause();
                        } else if (sp.isPaused) {
                          sp.resume();
                        } else {
                          sp.playScene();
                        }
                      },
                      onRestart: sp.stopAndRestart,
                      onChangeNarrator: _openNarratorPicker,
                      onSpeedChanged: (v) {
                        context.read<VoiceProvider>().setSpeed(v);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LightPanel extends StatelessWidget {
  const _LightPanel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF14172E) : PebloColors.cream,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: child,
    );
  }
}

class _SceneView extends StatelessWidget {
  const _SceneView();

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final story = sp.story!;
    final scene = sp.currentScene;
    final wide = context.isWide;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: wide ? 80 : 28, vertical: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CharacterAvatar(
                    character: story.character,
                    pose: sp.pose,
                    size: wide ? 180 : 150,
                    accent: story.theme.accent,
                  ),
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: Text(scene.prop, style: const TextStyle(fontSize: 28)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  scene.text,
                  key: ValueKey(sp.sceneIndex),
                  textAlign: TextAlign.center,
                  style: PebloText.display(
                    wide ? 22 : 19,
                    color: Colors.white,
                    weight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              if (sp.fallbackNotice != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    sp.fallbackNotice!,
                    style: PebloText.body(11, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
