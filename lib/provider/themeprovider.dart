import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ThemeProvider with ChangeNotifier {
  final Box _themeMode = Hive.box('themeMode');

  Box get themeModeBox => _themeMode;

  get themeMode => getThemeMode();

  getThemeMode() {
    try {
      if (_themeMode.get('isLight') == null) {
        _themeMode.put('isLight', false);
      }
      bool data = _themeMode.get('isLight');
      return data;
    } catch (e) {
      return -1;
    }
  }

  toggleTheme() {
    if (_themeMode.get('isLight') == false) {
      _themeMode.put('isLight', true);
    } else {
      _themeMode.put('isLight', false);
    }
    notifyListeners();
  }
}
