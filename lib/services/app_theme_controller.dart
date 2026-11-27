import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppThemeController extends ChangeNotifier {
  AppThemeController._();

  static final AppThemeController instance = AppThemeController._();
  static const _themeKey = 'pilara_theme_mode';
  static const _storage = FlutterSecureStorage();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> load() async {
    final savedMode = await _storage.read(key: _themeKey);
    _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    final themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(
      key: _themeKey,
      value: enabled ? 'dark' : 'light',
    );
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    notifyListeners();
  }
}
