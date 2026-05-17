import 'package:flutter/material.dart';
import '../models/calculator_theme.dart';

class AmberGlassTheme extends CalculatorTheme {
  @override
  String get name => 'Amber Glass';

  @override
  ThemeType get type => ThemeType.amberGlass;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.auto_awesome_rounded,
    history: Icons.history_rounded,
    settings: Icons.auto_fix_high_rounded,
    delete: Icons.backspace_outlined,
    back: Icons.chevron_left,
    check: Icons.verified_rounded,
    deleteSweep: Icons.delete,
    warning: Icons.warning_amber_rounded,
    modeBasic: Icons.apps_rounded,
    modeScientific: Icons.functions_rounded,
    arrowForward: Icons.arrow_forward_ios_rounded,
    clear: Icons.close_rounded,
  );

  // Amber Glass Palette
  static const Color amberDeep = Color(0xFFFF8F00);
  static const Color amberGlow = Color(0xFFFFD54F);
  static const Color obsidian = Color(0xFF080808);
  static const Color indigoDark = Color(0xFF1A1A2E);

  @override
  Color get primaryColor => amberDeep;
  @override
  Color get secondaryColor => amberGlow;
  @override
  Color get backgroundDark => obsidian;
  @override
  Color get panelBackground => const Color(0xFF121212);
  @override
  Color get cardBackground => Colors.white.withValues(alpha: 0.05);

  @override
  double get borderRadius => 28.0;
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
      scaffoldBackgroundColor: obsidian,
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
      Colors.white.withValues(alpha: 0.08),
      Colors.white.withValues(alpha: 0.02),
    ],
    Colors.white70,
  );

  @override
  (List<Color>, Color) get operatorButtonColors => (
    [amberDeep.withValues(alpha: 0.3), amberDeep.withValues(alpha: 0.1)],
    amberGlow,
  );

  @override
  (List<Color>, Color) get functionButtonColors => (
    [
      const Color(0xFF1E3A8A).withValues(alpha: 0.3),
      const Color(0xFF1E3A8A).withValues(alpha: 0.1),
    ],
    const Color(0xFF60A5FA),
  );

  @override
  (List<Color>, Color) get commandButtonColors => (
    [
      Colors.redAccent.withValues(alpha: 0.4),
      Colors.redAccent.withValues(alpha: 0.2),
    ],
    const Color(0xFFFF8A80),
  );

  @override
  (List<Color>, Color) get equalsButtonColors =>
      ([amberDeep, const Color(0xFFFF6F00)], Colors.black);

  @override
  CustomPainter? get backgroundPainter => const _AmberGlassBackgroundPainter();

  @override
  CustomPainter? getButtonGlowPainter(double progress, Color color) =>
      _AmberRipplePainter(progress: progress, color: color);

  @override
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  ) => _AmberRipplePainter(progress: progress, color: color);

  @override
  BoxDecoration get displayDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: amberDeep.withValues(alpha: 0.3), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: amberDeep.withValues(alpha: 0.2),
        blurRadius: 30,
        spreadRadius: -10,
      ),
    ],
  );

  @override
  BoxDecoration get panelDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
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
          ? amberDeep.withValues(alpha: 0.2)
          : Colors.white.withValues(alpha: 0.05),
      border: Border.all(
        color: active || pressed ? amberGlow : amberDeep.withValues(alpha: 0.3),
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
        ? amberDeep.withValues(alpha: 0.15)
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
  TextStyle? get resultTextStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 62,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    shadows: [Shadow(color: amberDeep, blurRadius: 20)],
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => Colors.transparent;
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: amberDeep.withValues(alpha: 0.4), width: 1),
  );
  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: amberDeep.withValues(alpha: 0.4), width: 1),
  );
  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  Color get appBarIconColor => amberGlow;

  @override
  BoxDecoration getHistoryItemDecoration(bool isPressed) => BoxDecoration(
    color: isPressed ? amberDeep.withValues(alpha: 0.3) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isPressed ? amberGlow : amberDeep.withValues(alpha: 0.5),
      width: 1,
    ),
    boxShadow: [
      if (isPressed)
        BoxShadow(color: amberDeep.withValues(alpha: 0.25), blurRadius: 15),
    ],
  );

  @override
  TextStyle get historyExpressionStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Color(0xFFE0E0E0),
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get historyResultStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get historyDeleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: amberDeep.withValues(alpha: 0.2), width: 2),
  );
  @override
  Color get emptyStateIconColor => amberGlow.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(32),
    border: Border.all(color: amberDeep.withValues(alpha: 0.4), width: 2),
    boxShadow: [
      BoxShadow(color: amberDeep.withValues(alpha: 0.2), blurRadius: 60),
    ],
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'ERASE SYSTEM' : 'SYSTEM ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'Initialize memory wipe? This will permanently erase all amber-core calculation logs.'
      : 'System notification.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white.withValues(alpha: 0.7),
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
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: baseColor == Colors.white38 ? Colors.white54 : baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    fontSize: 12,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? amberDeep.withValues(alpha: 0.25) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? amberGlow : amberDeep.withValues(alpha: 0.5),
      width: isSelected ? 2 : 1,
    ),
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
    color: amberGlow.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}

class _AmberGlassBackgroundPainter extends CustomPainter {
  const _AmberGlassBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    // Beautiful abstract background for amber glass to sit on (Subdued Orange version)
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.5, -0.5),
        radius: 1.5,
        colors: [
          Color(0xFF802B00),
          Color(0xFF0D0500),
        ], // Darker, more muted orange and deep black
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Floating glass spheres - Subdued Amber version
    final sphere1Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [
              Color(0x22FFD54F),
              Colors.transparent,
            ], // Reduced opacity from 0x44 to 0x22
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.8, size.height * 0.2),
              radius: 180,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      180,
      sphere1Paint,
    );

    final sphere2Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [
              Color(0x18FFB74D),
              Colors.transparent,
            ], // Reduced opacity from 0x33 to 0x18
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.8),
              radius: 220,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      220,
      sphere2Paint,
    );
  }

  @override
  bool shouldRepaint(covariant _AmberGlassBackgroundPainter oldDelegate) =>
      false;
}

class _AmberRipplePainter extends CustomPainter {
  _AmberRipplePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint()
      ..color = color.withValues(alpha: (1.0 - progress) * 0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.9 * progress,
      paint,
    );

    final borderPaint = Paint()
      ..color = color.withValues(alpha: (1.0 - progress) * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.8 * progress,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AmberRipplePainter oldDelegate) => true;
}
