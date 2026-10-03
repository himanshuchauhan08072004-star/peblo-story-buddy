import 'package:flutter/material.dart';

import '../models/story.dart';

const Map<CharacterKind, String> _faceEmoji = {
  CharacterKind.pip: '🤖',
  CharacterKind.luna: '🦉',
  CharacterKind.milo: '🦁',
  CharacterKind.cloud: '☁️',
  CharacterKind.leo: '🦊',
};

const Map<CharacterPose, String> _poseOverlay = {
  CharacterPose.idle: '',
  CharacterPose.talking: '💬',
  CharacterPose.happy: '😊',
  CharacterPose.thinking: '💭',
  CharacterPose.celebrating: '🎉',
  CharacterPose.surprised: '❗',
};

/// A lightweight, reusable character — no image assets. A breathing/pulsing
/// circle with an emoji face and a small pose-overlay badge, so any screen
/// can show what the character is "doing" without new art.
class CharacterAvatar extends StatefulWidget {
  const CharacterAvatar({
    super.key,
    required this.character,
    required this.pose,
    this.size = 140,
    this.accent,
  });

  final CharacterKind character;
  final CharacterPose pose;
  final double size;
  final Color? accent;

  @override
  State<CharacterAvatar> createState() => _CharacterAvatarState();
}

class _CharacterAvatarState extends State<CharacterAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _active =>
      widget.pose == CharacterPose.talking ||
      widget.pose == CharacterPose.celebrating;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.pose == CharacterPose.celebrating ? 500 : 900),
    );
    if (_active) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant CharacterAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pose != widget.pose) {
      _controller.duration = Duration(
        milliseconds: widget.pose == CharacterPose.celebrating ? 500 : 900,
      );
      if (_active) {
        _controller.repeat(reverse: true);
      } else {
        _controller.animateTo(0, duration: const Duration(milliseconds: 250));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent ?? Theme.of(context).colorScheme.primary;
    final face = _faceEmoji[widget.character] ?? '🤖';
    final overlay = _poseOverlay[widget.pose] ?? '';

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = _active ? _controller.value : 0.0;
        final scale = 1.0 + pulse * 0.08;
        final tilt = widget.pose == CharacterPose.thinking ? -0.05 : 0.0;
        return Transform.rotate(
          angle: tilt,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(face, style: TextStyle(fontSize: widget.size * 0.5)),
            ),
            if (overlay.isNotEmpty)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(overlay, style: const TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
