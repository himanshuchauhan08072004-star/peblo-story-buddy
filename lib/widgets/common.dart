import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PebloButton extends StatelessWidget {
  const PebloButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.filled = true,
    this.loading = false,
    this.color,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool filled;
  final bool loading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = color ?? scheme.primary;
    final disabled = onTap == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: filled ? bg.withValues(alpha: disabled ? 0.5 : 1) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: filled ? null : Border.all(color: bg, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: filled ? Colors.white : bg,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 20, color: filled ? Colors.white : bg),
                if (loading || icon != null) const SizedBox(width: 10),
                Text(
                  label,
                  style: PebloText.body(
                    16,
                    weight: FontWeight.w800,
                    color: filled ? Colors.white : bg,
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

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: PebloText.display(22, color: context.ink)),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class PillBadge extends StatelessWidget {
  const PillBadge({super.key, required this.label, this.icon, this.color});

  final String label;
  final String? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon!, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: PebloText.body(12, weight: FontWeight.w800, color: c),
          ),
        ],
      ),
    );
  }
}
