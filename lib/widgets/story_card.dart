import 'package:flutter/material.dart';

import '../models/story.dart';
import '../theme/app_theme.dart';
import 'common.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({
    super.key,
    required this.story,
    required this.completed,
    required this.onTap,
    this.featured = false,
  });

  final Story story;
  final bool completed;
  final VoidCallback onTap;
  final bool featured;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final height = widget.featured ? 240.0 : 210.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 160),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [story.theme.skyTop, story.theme.skyBottom],
              ),
              boxShadow: [
                BoxShadow(
                  color: story.theme.accent.withValues(alpha: _hover ? 0.35 : 0.2),
                  blurRadius: _hover ? 26 : 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Text(
                    story.emoji,
                    style: TextStyle(
                      fontSize: widget.featured ? 130 : 100,
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          PillBadge(label: story.category, color: Colors.white),
                          const SizedBox(width: 8),
                          PillBadge(
                            label: story.durationLabel,
                            icon: '⏱',
                            color: Colors.white,
                          ),
                          const Spacer(),
                          if (widget.completed)
                            const Text('✅', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        story.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: PebloText.display(
                          widget.featured ? 26 : 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        story.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: PebloText.body(
                          13,
                          color: Colors.white.withValues(alpha: 0.85),
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow_rounded,
                                    size: 18, color: story.theme.accent),
                                const SizedBox(width: 4),
                                Text(
                                  widget.featured ? 'Start Adventure' : 'Play',
                                  style: PebloText.body(
                                    13,
                                    weight: FontWeight.w800,
                                    color: story.theme.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
