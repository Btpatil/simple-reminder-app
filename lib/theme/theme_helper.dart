import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getThemeMode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("theme") == null) {
    String theme = await setTheme(ThemeMode.system);
    print("theme helper 8 $theme");
    return theme;
  } else {
    print("theme helper 11 ${prefs.getString("theme")}");
    return prefs.getString("theme")!;
  }
}

Future<String> setTheme(ThemeMode themeMode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString("is_dark", !isDark);
  await prefs.setString("theme", themeMode.toString());
  return themeMode.toString();
}
