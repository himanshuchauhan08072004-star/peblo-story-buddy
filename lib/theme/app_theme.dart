import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Peblo palette: warm off-whites, deep navy, gold/orange, lavender, sky.
class PebloColors {
  PebloColors._();

  static const midnight = Color(0xFF0B0D26);
  static const navy = Color(0xFF171A45);
  static const indigo = Color(0xFF2A2D6B);
  static const cream = Color(0xFFFFF8EE);
  static const sand = Color(0xFFFFEFD6);
  static const ink = Color(0xFF26264A);
  static const inkSoft = Color(0xFF6B6A8C);
  static const gold = Color(0xFFFFB84D);
  static const orange = Color(0xFFFF8A3D);
  static const lavender = Color(0xFFB9A7F5);
  static const sky = Color(0xFF7CC4F5);
  static const mint = Color(0xFF5FD3A6);
  static const coral = Color(0xFFFF7A7A);
}

extension PebloContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get ink => isDark ? Colors.white : PebloColors.ink;
  Color get inkSoft => isDark ? const Color(0xFFB8B7D9) : PebloColors.inkSoft;
  Color get surface => isDark ? const Color(0xFF1E2152) : Colors.white;
  Color get surfaceAlt =>
      isDark ? const Color(0xFF2A2E6B) : const Color(0xFFFFF0DA);
  Color get outline => isDark
      ? Colors.white.withValues(alpha: 0.12)
      : PebloColors.ink.withValues(alpha: 0.08);
  double get screenW => MediaQuery.sizeOf(this).width;
  bool get isWide => screenW >= 900;
  bool get isMedium => screenW >= 600;
}

class PebloText {
  PebloText._();

  static TextStyle display(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w600,
    double? height,
  }) =>
      GoogleFonts.fredoka(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
      );

  static TextStyle body(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w600,
    double? height,
  }) =>
      GoogleFonts.nunito(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
      );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: PebloColors.orange,
      brightness: brightness,
    ).copyWith(
      primary: dark ? PebloColors.gold : PebloColors.orange,
      onPrimary: dark ? PebloColors.midnight : Colors.white,
      secondary: PebloColors.lavender,
      surface: dark ? const Color(0xFF1E2152) : Colors.white,
      onSurface: dark ? Colors.white : PebloColors.ink,
    );
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? PebloColors.midnight : PebloColors.cream,
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? PebloColors.indigo : PebloColors.ink,
        contentTextStyle: PebloText.body(15, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}
