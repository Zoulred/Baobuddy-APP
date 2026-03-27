import 'package:flutter/material.dart';

enum AppThemeMode { light, cyberpunk }

class ThemeProvider with ChangeNotifier {
  AppThemeMode _mode = AppThemeMode.light;

  AppThemeMode get mode => _mode;

  void cycle() {
    _mode = AppThemeMode.values[(_mode.index + 1) % AppThemeMode.values.length];
    notifyListeners();
  }

  bool get isDark => _mode == AppThemeMode.cyberpunk;
}
