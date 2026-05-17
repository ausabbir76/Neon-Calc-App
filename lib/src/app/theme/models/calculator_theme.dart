import 'package:flutter/material.dart';

enum ThemeType { neon, classic, retro, cyber, synthwave, glass, amberGlass }

class ThemeIcons {
  const ThemeIcons({
    required this.logo,
    required this.history,
    required this.settings,
    required this.delete,
    required this.back,
    required this.check,
    required this.deleteSweep,
    required this.warning,
    required this.modeBasic,
    required this.modeScientific,
    required this.arrowForward,
    required this.clear,
  });

  final IconData logo;
  final IconData history;
  final IconData settings;
  final IconData delete;
  final IconData back;
  final IconData check;
  final IconData deleteSweep;
  final IconData warning;
  final IconData modeBasic;
  final IconData modeScientific;
  final IconData arrowForward;
  final IconData clear;
}

abstract class CalculatorTheme {
  String get name;
  ThemeType get type;
  ThemeData get themeData;

  // Icons
  ThemeIcons get icons;

  // Colors
  Color get primaryColor;
  Color get secondaryColor;
  Color get backgroundDark;
  Color get panelBackground;
  Color get cardBackground;

  // Design Tokens
  double get borderRadius;
  bool get useGlowEffects;

  // Button Colors
  (List<Color>, Color) get numberButtonColors;
  (List<Color>, Color) get operatorButtonColors;
  (List<Color>, Color) get functionButtonColors;
  (List<Color>, Color) get commandButtonColors;
  (List<Color>, Color) get equalsButtonColors;

  // Custom Painters/Decorations
  CustomPainter? get backgroundPainter;
  String? get backgroundImage => null; // Path to asset image
  CustomPainter? getButtonGlowPainter(double progress, Color color);
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  );

  BoxDecoration get displayDecoration;
  BoxDecoration get panelDecoration;
  BoxDecoration get keypadUnderGlowDecoration;
  BoxDecoration getSwitchSegmentDecoration({
    required bool active,
    required bool pressed,
  });
  Color getDisplayPanelColor({
    required bool answerDisplayed,
    required bool equalFlash,
  });

  // Widget-specific styles
  TextStyle? get displayTextStyle;
  TextStyle? get resultTextStyle;

  // --- NEW SEMANTIC GETTERS ---

  // App Bar & General UI
  Color get appBarColor;
  double get appBarBlur;
  Border? get appBarBorder;
  Border? get navBarBorder;
  TextStyle get appBarTitleStyle;
  Color get appBarIconColor;

  // History Screen
  BoxDecoration getHistoryItemDecoration(bool isPressed);
  TextStyle get historyExpressionStyle;
  TextStyle get historyResultStyle;
  Color get historyDeleteIconColor;
  BoxDecoration get emptyStateIconDecoration;
  Color get emptyStateIconColor;

  // Dialogs
  BoxDecoration get dialogDecoration;
  double get dialogBlur;
  String getDialogTitle(String type); // 'warning' or 'purge'
  String getDialogMessage(String type);
  TextStyle get dialogTitleStyle;
  TextStyle get dialogMessageStyle;
  BoxDecoration getDialogIconDecoration(Color baseColor);
  String getDialogConfirmLabel(String type);
  String getDialogCancelLabel(String type);
  BoxDecoration getDialogButtonDecoration(Color baseColor);
  TextStyle getDialogButtonTextStyle(Color baseColor);

  // Theme Screen
  BoxDecoration getThemeItemDecoration(bool isSelected);
  TextStyle get themeItemTitleStyle;
  TextStyle get themeItemStatusStyle;
}
