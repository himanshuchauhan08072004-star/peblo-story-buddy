import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/progress_provider.dart';
import 'providers/story_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/voice_provider.dart';
import 'screens/root_shell.dart';
import 'services/storage_service.dart';
import 'services/tts_service.dart';
import 'services/voice_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();

  final tts = TtsService();
  await tts.initialize();

  final voiceService = VoiceService(tts);

  runApp(PebloApp(storage: storage, tts: tts, voiceService: voiceService));
}

class PebloApp extends StatelessWidget {
  const PebloApp({
    super.key,
    required this.storage,
    required this.tts,
    required this.voiceService,
  });

  final StorageService storage;
  final TtsService tts;
  final VoiceService voiceService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(storage)),
        ChangeNotifierProvider(create: (_) => ProgressProvider(storage)),
        ChangeNotifierProvider(
          create: (_) => VoiceProvider(tts, voiceService, storage)..initialize(),
        ),
        ChangeNotifierProxyProvider<VoiceProvider, StoryProvider>(
          create: (context) => StoryProvider(
            tts,
            context.read<VoiceProvider>(),
            context.read<ProgressProvider>(),
          ),
          update: (context, voiceProvider, previous) =>
              previous ?? StoryProvider(tts, voiceProvider, context.read<ProgressProvider>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Peblo Story Buddy',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const RootShell(),
          );
        },
      ),
    );
  }
}
