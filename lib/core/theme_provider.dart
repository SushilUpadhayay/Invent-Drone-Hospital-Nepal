// lib/core/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    try {
      final box = await Hive.openBox('settings');
      final saved = box.get(_key, defaultValue: 'system') as String;

      _themeMode = switch (saved) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      notifyListeners();
    } catch (_) {
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final box = await Hive.openBox('settings');
      await box.put(_key, mode.name);
    } catch (_) {}
  }
}
