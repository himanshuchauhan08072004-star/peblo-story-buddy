import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'voice_selection_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _tabs = ['Stories', 'My Progress', 'Voice'];
  static const _screens = [
    HomeScreen(),
    ProgressScreen(),
    VoiceSelectionScreen(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wide ? 40 : 16, vertical: 14),
              child: Row(
                children: [
                  Text('🪄', style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text('Peblo', style: PebloText.display(20, color: context.ink)),
                  Text(' Story Buddy',
                      style: PebloText.body(13, weight: FontWeight.w700, color: context.inkSoft)),
                  const Spacer(),
                  if (wide)
                    Row(
                      children: List.generate(_tabs.length, (i) {
                        final selected = i == _index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextButton(
                            onPressed: () => setState(() => _index = i),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  selected ? Theme.of(context).colorScheme.primary : context.inkSoft,
                            ),
                            child: Text(
                              _tabs[i],
                              style: PebloText.body(14, weight: FontWeight.w800),
                            ),
                          ),
                        );
                      }),
                    ),
                  const SizedBox(width: 12),
                  IconButton(
                    tooltip: 'Toggle theme',
                    onPressed: themeProvider.toggle,
                    icon: Icon(
                      themeProvider.mode == ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: context.ink,
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    child: const Text('🦊', style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(index: _index, children: _screens),
            ),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.auto_stories_rounded), label: 'Stories'),
                NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'Progress'),
                NavigationDestination(icon: Icon(Icons.record_voice_over_rounded), label: 'Voice'),
              ],
            ),
    );
  }
}
