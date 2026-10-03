import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final wide = context.isWide;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: wide ? 40 : 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Story Journey', style: PebloText.display(26, color: context.ink)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(icon: '⭐', value: '${progress.storiesCompleted}', label: 'Stories completed'),
              _StatCard(icon: '🧠', value: '${progress.questionsAnswered}', label: 'Questions answered'),
              _StatCard(icon: '🎧', value: '${progress.listenMinutes}', label: 'Minutes listened'),
            ],
          ),
          const SizedBox(height: 32),
          SectionHeader(title: 'Badges'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: progress.badges
                .map((b) => Container(
                      width: 140,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: b.earned ? context.surface : context.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.outline),
                      ),
                      child: Column(
                        children: [
                          Opacity(
                            opacity: b.earned ? 1 : 0.3,
                            child: Text(b.icon, style: const TextStyle(fontSize: 30)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            b.label,
                            textAlign: TextAlign.center,
                            style: PebloText.body(
                              12,
                              weight: FontWeight.w700,
                              color: b.earned ? context.ink : context.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label});
  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(value, style: PebloText.display(24, color: context.ink)),
          Text(label, style: PebloText.body(12, color: context.inkSoft)),
        ],
      ),
    );
  }
}
