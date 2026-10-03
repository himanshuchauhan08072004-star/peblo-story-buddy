import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum QuizOptionState { neutral, selectedCorrect, selectedWrong, dimmed }

class QuizOption extends StatelessWidget {
  const QuizOption({
    super.key,
    required this.label,
    required this.emoji,
    required this.state,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final QuizOptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text = context.ink;

    switch (state) {
      case QuizOptionState.neutral:
        bg = context.surface;
        border = context.outline;
        break;
      case QuizOptionState.selectedCorrect:
        bg = PebloColors.mint.withValues(alpha: 0.18);
        border = PebloColors.mint;
        text = context.isDark ? Colors.white : const Color(0xFF1D6E4C);
        break;
      case QuizOptionState.selectedWrong:
        bg = PebloColors.coral.withValues(alpha: 0.16);
        border = PebloColors.coral;
        text = context.isDark ? Colors.white : const Color(0xFF9C2C2C);
        break;
      case QuizOptionState.dimmed:
        bg = context.surface.withValues(alpha: 0.6);
        border = context.outline;
        text = context.inkSoft;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                if (emoji.isNotEmpty) ...[
                  Text(emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: PebloText.body(17, weight: FontWeight.w800, color: text),
                  ),
                ),
                if (state == QuizOptionState.selectedCorrect)
                  const Icon(Icons.check_circle_rounded, color: PebloColors.mint),
                if (state == QuizOptionState.selectedWrong)
                  const Icon(Icons.refresh_rounded, color: PebloColors.coral),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
