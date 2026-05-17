import 'package:flutter/material.dart';
import '../models/calculator_theme.dart';

class GlassTheme extends CalculatorTheme {
  @override
  String get name => 'Glassmorphism';

  @override
  ThemeType get type => ThemeType.glass;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.calculate_rounded,
    history: Icons.history_toggle_off,
    settings: Icons.settings_input_component,
    delete: Icons.remove,
    back: Icons.chevron_left,
    check: Icons.check,
    deleteSweep: Icons.delete,
    warning: Icons.info_outline,
    modeBasic: Icons.grid_view_rounded,
    modeScientific: Icons.biotech_outlined,
    arrowForward: Icons.chevron_right,
    clear: Icons.close,
  );

  @override
  Color get primaryColor => const Color.fromARGB(255, 197, 236, 255);
  @override
  Color get secondaryColor => const Color.fromARGB(255, 62, 168, 255);
  @override
  Color get backgroundDark => const Color(0xFF1A237E); // Deep indigo
  @override
  Color get panelBackground => const Color.fromARGB(255, 34, 42, 130);
  @override
  Color get cardBackground =>
      const Color.fromARGB(46, 24, 44, 74).withValues(alpha: 0.05);

  @override
  double get borderRadius => 24.0;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'OnePlusSansRegular',
    );

    return ThemeData(
      fontFamily: 'OnePlusSansRegular',
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
  (List<Color>, Color) get numberButtonColors => (
    [
      Colors.white.withValues(alpha: 0.15),
      Colors.white.withValues(alpha: 0.05),
    ],
    Colors.white,
  );

  @override
  (List<Color>, Color) get operatorButtonColors => (
    [Colors.blue.withValues(alpha: 0.3), Colors.blue.withValues(alpha: 0.1)],
    Colors.lightBlueAccent,
  );

  @override
  (List<Color>, Color) get functionButtonColors => (
    [
      Colors.purple.withValues(alpha: 0.3),
      Colors.purple.withValues(alpha: 0.1),
    ],
    const Color(0xFFE1BEE7),
  );

  @override
  (List<Color>, Color) get commandButtonColors => (
    [
      Colors.orange.withValues(alpha: 0.4),
      Colors.orange.withValues(alpha: 0.2),
    ],
    const Color(0xFFFFE0B2),
  );

  @override
  (List<Color>, Color) get equalsButtonColors => (
    [const Color.fromARGB(255, 73, 172, 253), const Color(0xFF1E88E5)],
    Colors.white,
  );

  @override
  CustomPainter? get backgroundPainter => const _GlassBackgroundPainter();

  @override
  CustomPainter? getButtonGlowPainter(double progress, Color color) =>
      _GlassRipplePainter(progress: progress, color: color);

  @override
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  ) => _GlassRipplePainter(progress: progress, color: color);

  @override
  BoxDecoration get displayDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  @override
  BoxDecoration get panelDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
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
      color: active || pressed
          ? primaryColor.withValues(alpha: 0.2)
          : Colors.white.withValues(alpha: 0.05),
      border: Border.all(
        color: active || pressed
            ? secondaryColor
            : Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }

  @override
  Color getDisplayPanelColor({
    required bool answerDisplayed,
    required bool equalFlash,
  }) {
    if (equalFlash) return Colors.white.withValues(alpha: 0.3);
    return answerDisplayed
        ? Colors.cyan.withValues(alpha: 0.2)
        : Colors.transparent;
  }

  @override
  TextStyle? get displayTextStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white.withValues(alpha: 0.8),
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
  );

  @override
  TextStyle? get resultTextStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: primaryColor,
    fontSize: 62,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => panelBackground.withValues(alpha: 0.0);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1),
  );
  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1),
  );
  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getHistoryItemDecoration(bool isPressed) => BoxDecoration(
    color: isPressed ? primaryColor.withValues(alpha: 0.3) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isPressed ? primaryColor : primaryColor.withValues(alpha: 0.5),
      width: 1,
    ),
    boxShadow: [
      if (isPressed && useGlowEffects)
        BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10),
    ],
  );

  @override
  TextStyle get historyExpressionStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white54,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get historyResultStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get historyDeleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration =>
      const BoxDecoration(shape: BoxShape.circle);
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'ERASE SYSTEM' : 'SYSTEM ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'This action will permanently erase all calculation logs from the memory core.'
      : 'Operation in progress.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    shape: BoxShape.circle,
  );

  @override
  String getDialogConfirmLabel(String type) => 'ERASE';
  @override
  String getDialogCancelLabel(String type) => 'BACK';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    fontSize: 12,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected
        ? primaryColor.withValues(alpha: 0.2)
        : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.5),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      if (isSelected && useGlowEffects)
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 15,
          spreadRadius: 2,
        ),
    ],
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}

class _GlassBackgroundPainter extends CustomPainter {
  const _GlassBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    // Beautiful abstract background for glass to sit on
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.5, -0.5),
        radius: 1.5,
        colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Floating glass spheres
    final sphere1Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [Color(0x4481D4FA), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.8, size.height * 0.2),
              radius: 200,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      200,
      sphere1Paint,
    );

    final sphere2Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [Color(0x33CE93D8), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.8),
              radius: 250,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      250,
      sphere2Paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassBackgroundPainter oldDelegate) => false;
}

class _GlassRipplePainter extends CustomPainter {
  _GlassRipplePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: (1.0 - progress) * 0.3)
      ..style = PaintingStyle.fill;

    // A soft expanding ripple
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.8 * progress,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassRipplePainter oldDelegate) => true;
}
