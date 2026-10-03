import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/story_catalog.dart';
import '../models/story.dart';
import '../providers/progress_provider.dart';
import '../providers/story_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/story_card.dart';
import 'story_reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _stories = buildStoryCatalog();
  String _category = 'All';

  List<String> get _categories =>
      ['All', ..._stories.map((s) => s.category).toSet()];

  List<Story> get _filtered => _category == 'All'
      ? _stories
      : _stories.where((s) => s.category == _category).toList();

  void _openStory(Story story) {
    context.read<StoryProvider>().openStory(story);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StoryReaderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final featured = _stories.first;
    final wide = context.isWide;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: wide ? 40 : 18,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good day, little explorer 👋',
              style: PebloText.body(15, color: context.inkSoft)),
          const SizedBox(height: 4),
          Text('Where should we go today?',
              style: PebloText.display(wide ? 32 : 26, color: context.ink)),
          const SizedBox(height: 20),

          StoryCard(
            story: featured,
            completed: progress.isCompleted(featured.id),
            featured: true,
            onTap: () => _openStory(featured),
          ),

          const SizedBox(height: 28),
          SectionHeader(title: 'Continue exploring'),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = cat == _category;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = cat),
                  labelStyle: PebloText.body(13,
                      weight: FontWeight.w800,
                      color: selected ? Colors.white : context.ink),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: context.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(color: context.outline),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filtered.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: wide ? 3 : (context.isMedium ? 2 : 1),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: wide ? 0.95 : 1.15,
            ),
            itemBuilder: (context, i) {
              final story = _filtered[i];
              return StoryCard(
                story: story,
                completed: progress.isCompleted(story.id),
                onTap: () => _openStory(story),
              );
            },
          ),

          const SizedBox(height: 32),
          SectionHeader(title: 'Your Story Journey'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Wrap(
              spacing: 28,
              runSpacing: 12,
              children: [
                _StatChip(icon: '⭐', label: '${progress.storiesCompleted} stories completed'),
                _StatChip(icon: '🎧', label: '${progress.listenMinutes} min listened'),
                _StatChip(icon: '🧠', label: '${progress.questionsCorrect}/${progress.questionsAnswered} answered right'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(label, style: PebloText.body(14, weight: FontWeight.w700, color: context.ink)),
      ],
    );
  }
}
