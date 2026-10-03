import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({super.key, required this.controller});

  final ConfettiController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirection: 1.5708,
        emissionFrequency: 0.06,
        numberOfParticles: 18,
        maxBlastForce: 16,
        minBlastForce: 6,
        gravity: 0.25,
        shouldLoop: false,
        colors: const [
          PebloColors.gold,
          PebloColors.orange,
          PebloColors.lavender,
          PebloColors.sky,
          PebloColors.mint,
        ],
      ),
    );
  }
}
