import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsController extends ChangeNotifier {
  static const _kThemeMode = 'themeMode';
  static const _kLocale = 'locale';

  ThemeMode _themeMode = ThemeMode.dark; // default: dark, weil du willst
  Locale _locale = const Locale('tr', 'TR'); // default: Türkisch

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final themeRaw = prefs.getString(_kThemeMode);
    final localeRaw = prefs.getString(_kLocale);

    if (themeRaw != null) {
      _themeMode = switch (themeRaw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.dark,
      };
    }

    if (localeRaw != null) {
      // format: tr_TR / de_DE
      final parts = localeRaw.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      }
    }

    notifyListeners();
  }

  Future<void> save({
    ThemeMode? themeMode,
    Locale? locale,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (themeMode != null) {
      _themeMode = themeMode;
      await prefs.setString(
        _kThemeMode,
        switch (themeMode) {
          ThemeMode.light => 'light',
          ThemeMode.dark => 'dark',
          ThemeMode.system => 'system',
        },
      );
    }

    if (locale != null) {
      _locale = locale;
      await prefs.setString(_kLocale, '${locale.languageCode}_${locale.countryCode}');
    }

    notifyListeners();
  }
}
