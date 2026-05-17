import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/calculator_theme.dart';

class SynthwaveTheme extends CalculatorTheme {
  @override
  String get name => 'Synthwave Sunset';

  @override
  ThemeType get type => ThemeType.synthwave;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.wb_sunny,
    history: Icons.speed,
    settings: Icons.linear_scale,
    delete: Icons.backspace_outlined,
    back: Icons.chevron_left,
    check: Icons.check_circle_outline,
    deleteSweep: Icons.waves,
    warning: Icons.new_releases,
    modeBasic: Icons.grid_on,
    modeScientific: Icons.biotech,
    arrowForward: Icons.arrow_forward,
    clear: Icons.cancel,
  );

  // Synthwave Palette
  static const Color synthPink = Color(0xFFFF2BD6);
  static const Color synthBlue = Color(0xFF00E5FF);
  static const Color synthPurple = Color(0xFF2E1A47);
  static const Color synthNavy = Color(0xFF080B1A);
  static const Color synthOrange = Color(0xFFFFD166);

  @override
  Color get primaryColor => synthPink;
  @override
  Color get secondaryColor => synthBlue;
  @override
  Color get backgroundDark => synthNavy;
  @override
  Color get panelBackground => synthPurple;
  @override
  Color get cardBackground => const Color.fromARGB(255, 17, 12, 32);

  @override
  double get borderRadius => 12.0;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'OnePlusSansBold',
    );

    return ThemeData(
      fontFamily: 'OnePlusSansBold',
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: synthNavy,
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
      ([const Color(0xFF251841), synthNavy], synthBlue);

  @override
  (List<Color>, Color) get operatorButtonColors =>
      ([const Color(0xFF331144), synthNavy], synthPink);

  @override
  (List<Color>, Color) get functionButtonColors =>
      ([const Color(0xFF442211), synthNavy], synthOrange);

  @override
  (List<Color>, Color) get commandButtonColors =>
      ([synthPink, const Color(0xFFB81B9B)], Colors.white);

  @override
  (List<Color>, Color) get equalsButtonColors =>
      ([synthOrange, const Color(0xFFB8964B)], synthNavy);

  @override
  CustomPainter? get backgroundPainter => const _SynthwaveBackgroundPainter();

  @override
  CustomPainter? getButtonGlowPainter(double progress, Color color) =>
      _SynthwaveNeonPainter(progress: progress, color: color);

  @override
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  ) => _SynthwaveNeonPainter(progress: progress, color: color);

  @override
  BoxDecoration get displayDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        synthPurple.withValues(alpha: 0.8),
        synthNavy.withValues(alpha: 0.9),
      ],
    ),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: synthPink, width: 2),
    boxShadow: [
      BoxShadow(
        color: synthPink.withValues(alpha: 0.4),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  );

  @override
  BoxDecoration get panelDecoration => BoxDecoration(
    color: synthPurple.withValues(alpha: 0.4),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: synthBlue.withValues(alpha: 0.3), width: 1),
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
      gradient: active || pressed
          ? const LinearGradient(colors: [synthPink, synthBlue])
          : null,
      color: active || pressed ? null : Colors.white10,
    );
  }

  @override
  Color getDisplayPanelColor({
    required bool answerDisplayed,
    required bool equalFlash,
  }) {
    if (equalFlash) return Color.lerp(panelBackground, Colors.white, 0.35)!;
    return answerDisplayed ? panelBackground : Colors.black;
  }

  @override
  TextStyle? get displayTextStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
  );
  @override
  TextStyle? get resultTextStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: synthBlue,
    fontSize: 62,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    shadows: [Shadow(color: synthBlue, blurRadius: 10)],
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => panelBackground.withValues(alpha: 0.0);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: synthPink, width: 2));

  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: synthPink, width: 2));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getHistoryItemDecoration(bool isPressed) => BoxDecoration(
    color: isPressed ? synthPurple.withValues(alpha: 0.6) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isPressed ? synthPink : synthPink.withValues(alpha: 0.2),
      width: 2,
    ),
  );
  @override
  TextStyle get historyExpressionStyle => TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.grey[300],
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get historyResultStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: synthPink,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get historyDeleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(color: synthPink.withValues(alpha: 0.3), blurRadius: 20),
    ],
  );
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: synthPurple.withValues(alpha: 0.8),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: synthPink, width: 2),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'SYSTEM PURGE' : 'ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'INITIATE TOTAL MEMORY WIPE? DATA CANNOT BE RECOVERED.'
      : 'Operation in progress.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'OnePlusSansBold',
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
  String getDialogConfirmLabel(String type) => 'CONFIRM';
  @override
  String getDialogCancelLabel(String type) => 'CANCEL';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    fontSize: 12,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected
        ? synthPurple.withValues(alpha: 0.6)
        : cardBackground.withValues(alpha: 1.0),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? synthPink : synthPink.withValues(alpha: 0.2),
      width: isSelected ? 3 : 1,
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}

class _SynthwaveBackgroundPainter extends CustomPainter {
  const _SynthwaveBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient Sky
    final skyGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        SynthwaveTheme.synthNavy,
        SynthwaveTheme.synthPurple,
        Color(0xFF5E2365),
      ],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = skyGradient);

    // Sun
    final sunRadius = size.width * 0.3;
    final sunCenter = Offset(size.width * 0.5, size.height * 0.4);
    final sunGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [SynthwaveTheme.synthOrange, SynthwaveTheme.synthPink],
    ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius));

    canvas.drawCircle(sunCenter, sunRadius, Paint()..shader = sunGradient);

    // Perspective Grid
    final gridPaint = Paint()
      ..color = SynthwaveTheme.synthBlue.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    final horizon = size.height * 0.6;
    for (var i = 0.0; i <= size.width; i += size.width / 10) {
      canvas.drawLine(
        Offset(size.width * 0.5, horizon),
        Offset(i, size.height),
        gridPaint,
      );
    }

    for (var i = 0.0; i <= 1.0; i += 0.1) {
      final y = horizon + (size.height - horizon) * math.pow(i, 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SynthwaveBackgroundPainter oldDelegate) =>
      false;
}

class _SynthwaveNeonPainter extends CustomPainter {
  _SynthwaveNeonPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 1.0 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Offset.zero & size;

    // Pulsing neon ring
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.inflate(progress * 10),
        const Radius.circular(12),
      ),
      paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.inflate(progress * 10),
        const Radius.circular(12),
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: (1.0 - progress) * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant _SynthwaveNeonPainter oldDelegate) => true;
}
