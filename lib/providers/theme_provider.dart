import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._storage) {
    _mode = _fromString(_storage.getThemeMode());
  }

  final StorageService _storage;
  late ThemeMode _mode;

  ThemeMode get mode => _mode;

  void toggle() {
    setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
    _storage.setThemeMode(_toString(mode));
  }

  ThemeMode _fromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
