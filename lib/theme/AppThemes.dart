import 'package:flutter/material.dart';
import '../providers/ThemeProvider.dart';

class AppThemes {
  static const _radius = 10.0;

  // ── Light (Minimalist Professional) ───────────────────────────
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A1A2E),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF1A1A2E),
      secondary: const Color(0xFF4A90D9),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F9FA),
      foregroundColor: Color(0xFF1A1A2E),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F3F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0xFF1A1A2E), width: 1.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF1A1A2E),
      unselectedItemColor: Color(0xFFADB5BD),
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
    ),
  );

  // ── Dark (Minimalist Professional Dark) ───────────────────────
  static final cyberpunk = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A90D9),
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF111318),
      onSurface: const Color(0xFFE8EAED),
      primary: const Color(0xFF4A90D9),
      secondary: const Color(0xFF7CB9E8),
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF0D0F12),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D0F12),
      foregroundColor: Color(0xFFE8EAED),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardColor: const Color(0xFF1A1D23),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90D9),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1D23),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0xFF2C2F36)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0xFF2C2F36)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 1.5),
      ),
      labelStyle: const TextStyle(color: Color(0xFF8A8F9A)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF111318),
      selectedItemColor: Color(0xFF4A90D9),
      unselectedItemColor: Color(0xFF4A4F5A),
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF1E2128),
      thickness: 1,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE8EAED)),
      bodyMedium: TextStyle(color: Color(0xFFADB5BD)),
      titleLarge: TextStyle(color: Color(0xFFE8EAED)),
    ),
  );

  // ── Color helpers ──────────────────────────────────────────────
  static Color cardColor(AppThemeMode m) => const {
    AppThemeMode.light: Colors.white,
    AppThemeMode.cyberpunk: Color(0xFF1A1D23),
  }[m]!;

  static Color accent(AppThemeMode m) => const {
    AppThemeMode.light: Color(0xFF1A1A2E),
    AppThemeMode.cyberpunk: Color(0xFF4A90D9),
  }[m]!;

  static Color accentSecondary(AppThemeMode m) => const {
    AppThemeMode.light: Color(0xFF4A90D9),
    AppThemeMode.cyberpunk: Color(0xFF7CB9E8),
  }[m]!;

  static Color bg(AppThemeMode m) => const {
    AppThemeMode.light: Color(0xFFF8F9FA),
    AppThemeMode.cyberpunk: Color(0xFF0D0F12),
  }[m]!;

  static Color textPrimary(AppThemeMode m) => const {
    AppThemeMode.light: Color(0xFF1A1A2E),
    AppThemeMode.cyberpunk: Color(0xFFE8EAED),
  }[m]!;

  static Color textSecondary(AppThemeMode m) => const {
    AppThemeMode.light: Color(0xFF6C757D),
    AppThemeMode.cyberpunk: Color(0xFF6C757D),
  }[m]!;

  static Color border(AppThemeMode m) => const {
    AppThemeMode.light: Color(0xFFEEEEEE),
    AppThemeMode.cyberpunk: Color(0xFF2C2F36),
  }[m]!;

  static Color accentSubtle(AppThemeMode m) => {
    AppThemeMode.light: const Color(0xFF1A1A2E).withValues(alpha: 0.06),
    AppThemeMode.cyberpunk: const Color(0xFF4A90D9).withValues(alpha: 0.10),
  }[m]!;

  static List<BoxShadow> shadow(AppThemeMode m) => {
    AppThemeMode.light: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.04),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
    AppThemeMode.cyberpunk: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  }[m]!;

  static IconData themeIcon(AppThemeMode m) => {
    AppThemeMode.light: Icons.light_mode_outlined,
    AppThemeMode.cyberpunk: Icons.dark_mode_outlined,
  }[m]!;

  static String themeLabel(AppThemeMode m) =>
      {AppThemeMode.light: 'Light', AppThemeMode.cyberpunk: 'Dark'}[m]!;
}
