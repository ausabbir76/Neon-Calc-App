import 'package:flutter/material.dart';
import '../models/calculator_theme.dart';

class RetroTheme extends CalculatorTheme {
  @override
  String get name => 'Retro GameBoy';

  @override
  ThemeType get type => ThemeType.retro;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.videogame_asset_outlined,
    history: Icons.save_outlined,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back,
    check: Icons.check_box_outlined,
    deleteSweep: Icons.delete_forever_outlined,
    warning: Icons.priority_high,
    modeBasic: Icons.grid_view,
    modeScientific: Icons.science_outlined,
    arrowForward: Icons.arrow_forward,
    clear: Icons.cancel_outlined,
  );

  // GameBoy Palette
  static const Color gbDarkest = Color(0xFF0F380F);
  static const Color gbDark = Color(0xFF306230);
  static const Color gbLight = Color(0xFF8BAC0F);
  static const Color gbLightest = Color(0xFF9BBC0F);

  @override
  Color get primaryColor => gbDarkest;
  @override
  Color get secondaryColor => gbDark;
  @override
  Color get backgroundDark => gbLightest;
  @override
  Color get panelBackground => gbLight;
  @override
  Color get cardBackground => gbLightest;

  @override
  double get borderRadius => 2.0; // Almost square
  @override
  bool get useGlowEffects => false;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.light().textTheme.apply(
      fontFamily: 'PressStart2P',
    );

    return ThemeData(
      fontFamily: 'PressStart2P',
      useMaterial3: false,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: panelBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: gbDarkest,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: gbDarkest,
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
      ([gbLightest, gbLight], gbDarkest);

  @override
  (List<Color>, Color) get operatorButtonColors =>
      ([gbDark, gbDarkest], gbLightest);

  @override
  (List<Color>, Color) get functionButtonColors =>
      ([gbLight, gbDark], gbDarkest);

  @override
  (List<Color>, Color) get commandButtonColors => (
    [
      const Color(0xFF7E2217),
      const Color(0xFF5E1914),
    ], // A bit of "Start/Select" red
    Colors.white,
  );

  @override
  (List<Color>, Color) get equalsButtonColors =>
      ([gbDarkest, Colors.black], gbLightest);

  @override
  CustomPainter? get backgroundPainter => const _RetroBackgroundPainter();

  @override
  CustomPainter? getButtonGlowPainter(double progress, Color color) =>
      _RetroPixelGlowPainter(progress: progress, color: color);

  @override
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  ) => _RetroPixelGlowPainter(progress: progress, color: color);

  @override
  BoxDecoration get displayDecoration => BoxDecoration(
    color: const Color.fromARGB(
      255,
      160,
      188,
      0,
    ), // Slightly different shade for screen
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: gbDarkest, width: 4),
  );

  @override
  BoxDecoration get panelDecoration => BoxDecoration(
    color: gbLight,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: gbDarkest, width: 2),
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
      stops: const [0, .48, 1],
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
      color: active || pressed ? gbDarkest : cardBackground,
      border: Border.all(color: gbDarkest, width: 2),
    );
  }

  @override
  Color getDisplayPanelColor({
    required bool answerDisplayed,
    required bool equalFlash,
  }) {
    return Colors.transparent;
  }

  @override
  TextStyle? get displayTextStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
  );

  @override
  TextStyle? get resultTextStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 62,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => panelBackground.withValues(alpha: 0.1);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: gbDarkest, width: 4));

  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: gbDarkest, width: 4));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  Color get appBarIconColor => gbDarkest;

  @override
  BoxDecoration getHistoryItemDecoration(bool isPressed) => BoxDecoration(
    color: isPressed ? primaryColor.withValues(alpha: 0.3) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: gbDarkest, width: 2),
  );

  @override
  TextStyle get historyExpressionStyle => TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest.withValues(alpha: 0.5),
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get historyResultStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get historyDeleteIconColor => gbDarkest;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.rectangle,
    border: Border.all(color: gbDarkest, width: 4),
  );
  @override
  Color get emptyStateIconColor => gbDarkest.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white12,
    border: Border.all(color: gbDarkest, width: 4),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? '!!! WARNING !!!' : '!!! ALERT !!!';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'ALL DATA WILL BE LOST FOREVER. CONTINUE?'
      : 'SYSTEM ERROR DETECTED.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 18,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest.withValues(alpha: 0.7),
    fontSize: 12,
    height: 1.1,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) => BoxDecoration(
    shape: BoxShape.rectangle,
    border: Border.all(color: baseColor, width: 2),
  );

  @override
  String getDialogConfirmLabel(String type) => '[YES]';
  @override
  String getDialogCancelLabel(String type) => '[NO]';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: gbDarkest, width: 2),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    fontSize: 12,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? primaryColor.withValues(alpha: 0.3) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: gbDarkest, width: isSelected ? 4 : 1),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}

class _RetroBackgroundPainter extends CustomPainter {
  const _RetroBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = RetroTheme.gbLightest;
    canvas.drawRect(Offset.zero & size, paint);

    // Subtle pixel grid
    final gridPaint = Paint()
      ..color = RetroTheme.gbLight.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    const spacing = 10.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RetroBackgroundPainter oldDelegate) => false;
}

class _RetroPixelGlowPainter extends CustomPainter {
  _RetroPixelGlowPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    // Invert "glow" for retro - more like a bold blocky expansion
    final paint = Paint()
      ..color = RetroTheme.gbDarkest.withValues(alpha: 1.0 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final rect = Offset.zero & size;
    canvas.drawRect(rect.inflate(progress * 8), paint);
  }

  @override
  bool shouldRepaint(covariant _RetroPixelGlowPainter oldDelegate) => true;
}
