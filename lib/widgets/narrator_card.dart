import 'package:flutter/material.dart';

import '../models/story_voice.dart';
import '../theme/app_theme.dart';

class NarratorCard extends StatelessWidget {
  const NarratorCard({
    super.key,
    required this.voice,
    required this.selected,
    required this.previewing,
    required this.onSelect,
    required this.onPreview,
  });

  final StoryVoice voice;
  final bool selected;
  final bool previewing;
  final VoidCallback onSelect;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected ? accent : context.outline,
          width: selected ? 2.4 : 1.4,
        ),
        boxShadow: selected
            ? [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 18)]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                AnimatedScale(
                  scale: previewing ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  child: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(voice.icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(voice.name,
                              style: PebloText.display(17, color: context.ink)),
                          const SizedBox(width: 6),
                          if (previewing)
                            Text('🔊',
                                style: TextStyle(
                                    fontSize: 13, color: accent)),
                        ],
                      ),
                      Text(
                        voice.personalityLabel,
                        style: PebloText.body(13, color: context.inkSoft),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onPreview,
                  icon: Icon(
                    previewing ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                    color: accent,
                    size: 30,
                  ),
                  tooltip: previewing ? 'Stop' : 'Preview',
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: accent, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
