import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../models/calculator_theme.dart';

class ClassicTheme extends CalculatorTheme {
  @override
  String get name => 'Orange Dark';

  @override
  ThemeType get type => ThemeType.classic;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.calculate,
    history: Icons.history,
    settings: Icons.settings,
    delete: Icons.backspace_outlined,
    back: Icons.chevron_left,
    check: Icons.check,
    deleteSweep: Icons.delete,
    warning: Icons.warning,
    modeBasic: Icons.grid_view,
    modeScientific: Icons.functions,
    arrowForward: Icons.arrow_forward_ios,
    clear: Icons.clear,
  );

  @override
  Color get primaryColor => const Color.fromARGB(255, 255, 115, 0);
  @override
  Color get secondaryColor => const Color.fromARGB(255, 126, 126, 126);
  @override
  Color get backgroundDark => const Color(0xFF121212);
  @override
  Color get panelBackground => const Color.fromARGB(255, 53, 53, 53);
  @override
  Color get cardBackground => const Color(0xFF2C2C2C);

  @override
  double get borderRadius => AppConstants.borderRadius;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(fontFamily: 'Inter');

    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: panelBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
    );
  }

  @override
  (List<Color>, Color) get numberButtonColors =>
      ([const Color(0xFF333333), const Color(0xFF222222)], Colors.white);

  @override
  (List<Color>, Color) get operatorButtonColors =>
      ([const Color(0xFF424242), const Color(0xFF303030)], Colors.orangeAccent);

  @override
  (List<Color>, Color) get functionButtonColors => (
    [const Color(0xFF424242), const Color(0xFF303030)],
    Colors.lightBlueAccent,
  );

  @override
  (List<Color>, Color) get commandButtonColors =>
      ([const Color(0xFF424242), const Color(0xFF303030)], Colors.redAccent);

  @override
  (List<Color>, Color) get equalsButtonColors =>
      ([Colors.orange, Colors.deepOrange], Colors.white);

  @override
  CustomPainter? get backgroundPainter => null;

  @override
  CustomPainter? getButtonGlowPainter(double progress, Color color) => null;

  @override
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  ) => null;

  @override
  BoxDecoration get displayDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    color: panelBackground,
    border: Border.all(color: Colors.white10),
  );

  @override
  BoxDecoration get panelDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    color: cardBackground,
  );

  @override
  BoxDecoration get keypadUnderGlowDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    gradient: RadialGradient(
      center: Alignment.center,
      radius: 1.05,
      colors: [
        secondaryColor.withValues(alpha: .16),
        primaryColor.withValues(alpha: .1),
        Colors.transparent,
      ],
      stops: const [0, 0.48, 1],
    ),
    boxShadow: [
      BoxShadow(
        color: secondaryColor.withValues(alpha: .2),
        blurRadius: 70,
        spreadRadius: 10,
      ),
      BoxShadow(
        color: primaryColor.withValues(alpha: .16),
        blurRadius: 86,
        spreadRadius: 6,
      ),
    ],
  );

  @override
  BoxDecoration getSwitchSegmentDecoration({
    required bool active,
    required bool pressed,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: active || pressed ? primaryColor : Colors.white10,
    );
  }

  @override
  Color getDisplayPanelColor({
    required bool answerDisplayed,
    required bool equalFlash,
  }) {
    if (equalFlash) return Colors.white12;
    return answerDisplayed ? panelBackground : Colors.black;
  }

  @override
  TextStyle? get displayTextStyle => TextStyle(
    fontFamily: 'Inter',
    color: Colors.white.withValues(alpha: 0.8),
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
  );
  @override
  TextStyle? get resultTextStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.orange,
    fontSize: 62,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => Colors.transparent;
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: Colors.white38, width: 0.5));
  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: Colors.white38, width: 0.5));
  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getHistoryItemDecoration(bool isPressed) => BoxDecoration(
    color: isPressed ? secondaryColor : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  TextStyle get historyExpressionStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white54,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get historyResultStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get historyDeleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.white10, width: 2),
  );
  @override
  Color get emptyStateIconColor => Colors.white24;

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white12,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white10, width: 2),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) => 'CONFIRMATION';
  @override
  String getDialogMessage(String type) => 'Are you sure to delete all items?';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white70,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) =>
      const BoxDecoration(shape: BoxShape.circle);

  @override
  String getDialogConfirmLabel(String type) => 'YES';
  @override
  String getDialogCancelLabel(String type) => 'NO';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: Colors.white10,
    borderRadius: BorderRadius.circular(8),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    fontSize: 12,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? secondaryColor : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: isSelected ? Colors.white : Colors.white10),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white54,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}
