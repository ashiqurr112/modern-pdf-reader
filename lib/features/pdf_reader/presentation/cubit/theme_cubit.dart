import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey);
    if (isDark != null) {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool(_themeKey, !isDark);
    emit(newMode);
  }
}
