import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/narrator_card.dart';

class VoiceSelectionScreen extends StatelessWidget {
  const VoiceSelectionScreen({super.key, this.embedded = false});

  /// When true, renders without its own Scaffold/AppBar (used inside the
  /// "Voice" tab). When false, it's pushed as a modal-style screen from the
  /// story reader.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final voiceProvider = context.watch<VoiceProvider>();
    final wide = context.isWide;

    final content = voiceProvider.ready
        ? SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: wide ? 40 : 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Who should tell your story?',
                    style: PebloText.display(wide ? 28 : 24, color: context.ink)),
                const SizedBox(height: 6),
                Text(
                  'Pick a voice that makes your adventure feel special.',
                  style: PebloText.body(14, color: context.inkSoft),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: voiceProvider.voices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: wide ? 2 : 1,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: wide ? 3.6 : 4.6,
                  ),
                  itemBuilder: (context, i) {
                    final voice = voiceProvider.voices[i];
                    final selected = voiceProvider.selected?.id == voice.id;
                    return NarratorCard(
                      voice: voice,
                      selected: selected,
                      previewing: voiceProvider.isPreviewing(voice.id),
                      onSelect: () => voiceProvider.select(voice),
                      onPreview: () {
                        if (voiceProvider.isPreviewing(voice.id)) {
                          voiceProvider.stopPreview();
                        } else {
                          voiceProvider.preview(voice);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());

    if (embedded) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Choose your storyteller')),
      body: content,
    );
  }
}
