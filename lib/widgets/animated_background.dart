import 'dart:math';

import 'package:flutter/material.dart';

import '../models/story.dart';

/// A lightweight, code-drawn atmosphere behind a story scene — no image
/// assets, just gradients and a handful of animated shapes/particles.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
    required this.environment,
    required this.theme,
  });

  final EnvironmentKind environment;
  final StoryTheme theme;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [widget.theme.skyTop, widget.theme.skyBottom],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ParticlePainter(
              t: _controller.value,
              environment: widget.environment,
              accent: widget.theme.accent,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.t,
    required this.environment,
    required this.accent,
  });

  final double t;
  final EnvironmentKind environment;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(environment.index * 97);
    final count = switch (environment) {
      EnvironmentKind.nightForest => 26,
      EnvironmentKind.moonGarden => 22,
      EnvironmentKind.secretForest => 20,
      EnvironmentKind.sunnyAdventure => 14,
      EnvironmentKind.cloudSky => 10,
    };

    for (var i = 0; i < count; i++) {
      final baseX = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final speed = 0.3 + rnd.nextDouble() * 0.7;
      final phase = rnd.nextDouble();
      final float = sin((t + phase) * 2 * pi * speed) * 10;
      final radius = 1.5 + rnd.nextDouble() * 2.5;
      final opacity = 0.25 + 0.55 * (0.5 + 0.5 * sin((t + phase) * 2 * pi));

      final paint = Paint()
        ..color = (environment == EnvironmentKind.sunnyAdventure
                ? Colors.white
                : accent)
            .withValues(alpha: opacity.clamp(0.15, 0.85));

      canvas.drawCircle(Offset(baseX, baseY + float), radius, paint);
    }

    if (environment == EnvironmentKind.cloudSky ||
        environment == EnvironmentKind.sunnyAdventure) {
      _drawClouds(canvas, size, rnd);
    }
  }

  void _drawClouds(Canvas canvas, Size size, Random rnd) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    for (var i = 0; i < 4; i++) {
      final baseX =
          ((rnd.nextDouble() * size.width) + t * size.width * 0.15) %
              (size.width + 120) -
          60;
      final y = 40.0 + i * 70 + sin(t * 2 * pi + i) * 6;
      canvas.drawCircle(Offset(baseX, y), 26, paint);
      canvas.drawCircle(Offset(baseX + 24, y + 6), 20, paint);
      canvas.drawCircle(Offset(baseX - 22, y + 8), 18, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.environment != environment;
}
