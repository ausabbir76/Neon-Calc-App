import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/calculator_theme.dart';
import 'implementations/neon_theme.dart';
import 'implementations/classic_theme.dart';
import 'implementations/retro_theme.dart';
import 'implementations/cyber_theme.dart';
import 'implementations/synthwave_theme.dart';
import 'implementations/glass_theme.dart';
import 'implementations/amber_glass_theme.dart';

class ThemeController extends ChangeNotifier {
  static final ThemeController _instance = ThemeController._internal();
  factory ThemeController() => _instance;

  ThemeController._internal();

  CalculatorTheme _currentTheme = NeonTheme();
  CalculatorTheme get currentTheme => _currentTheme;

  final List<CalculatorTheme> availableThemes = [
    NeonTheme(),
    RetroTheme(),
    CyberTheme(),
    SynthwaveTheme(),
    GlassTheme(),
    AmberGlassTheme(),
    ClassicTheme(),
  ];

  bool _isSettingTheme = false;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTypeIndex = prefs.getInt('theme_type_index') ?? 0;

    final themeType = savedTypeIndex < ThemeType.values.length
        ? ThemeType.values[savedTypeIndex]
        : ThemeType.neon;

    _currentTheme = availableThemes.firstWhere(
      (t) => t.type == themeType,
      orElse: () => NeonTheme(),
    );
  }

  Future<void> setTheme(ThemeType type) async {
    if (_currentTheme.type == type || _isSettingTheme) return;

    _isSettingTheme = true;
    try {
      _currentTheme = availableThemes.firstWhere((t) => t.type == type);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_type_index', type.index);

      notifyListeners();
    } finally {
      _isSettingTheme = false;
    }
  }
}
