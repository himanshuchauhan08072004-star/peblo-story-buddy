import 'package:flutter/material.dart';

import '../models/story_voice.dart';
import '../theme/app_theme.dart';

const kSpeeds = [0.7, 0.85, 1.0, 1.15];

class AudioControls extends StatelessWidget {
  const AudioControls({
    super.key,
    required this.isPlaying,
    required this.isPaused,
    required this.voice,
    required this.speed,
    required this.onPlayPause,
    required this.onRestart,
    required this.onChangeNarrator,
    required this.onSpeedChanged,
  });

  final bool isPlaying;
  final bool isPaused;
  final StoryVoice? voice;
  final double speed;
  final VoidCallback onPlayPause;
  final VoidCallback onRestart;
  final VoidCallback onChangeNarrator;
  final ValueChanged<double> onSpeedChanged;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 18),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onChangeNarrator,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(voice?.icon ?? '🎙', style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
                Text(
                  voice == null
                      ? 'Choose a narrator'
                      : '${voice!.name} is telling your story',
                  style: PebloText.body(12, weight: FontWeight.w700, color: context.inkSoft),
                ),
                const SizedBox(width: 4),
                Icon(Icons.expand_more_rounded, size: 16, color: context.inkSoft),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onRestart,
                icon: Icon(Icons.replay_rounded, color: context.inkSoft),
                tooltip: 'Restart',
              ),
              const SizedBox(width: 8),
              Material(
                color: accent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPlayPause,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<double>(
                initialValue: speed,
                onSelected: onSpeedChanged,
                tooltip: 'Speed',
                itemBuilder: (context) => kSpeeds
                    .map((s) => PopupMenuItem(value: s, child: Text('${s}x')))
                    .toList(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.speed_rounded, size: 18, color: context.inkSoft),
                      const SizedBox(width: 4),
                      Text('${speed}x',
                          style: PebloText.body(12,
                              weight: FontWeight.w800, color: context.inkSoft)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
