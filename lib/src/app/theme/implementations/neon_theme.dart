import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../models/calculator_theme.dart';

class NeonTheme extends CalculatorTheme {
  @override
  String get name => 'Neon Glow';

  @override
  ThemeType get type => ThemeType.neon;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.bolt,
    history: Icons.auto_graph,
    settings: Icons.auto_fix_high,
    delete: Icons.backspace_outlined,
    back: Icons.chevron_left,
    check: Icons.done_all,
    deleteSweep: Icons.delete_sweep,
    warning: Icons.gpp_maybe,
    modeBasic: Icons.apps,
    modeScientific: Icons.functions,
    arrowForward: Icons.chevron_right,
    clear: Icons.highlight_off,
  );

  @override
  Color get primaryColor => const Color(0xFF00E5FF);
  @override
  Color get secondaryColor => const Color(0xFFFF2BD6);
  @override
  Color get backgroundDark => const Color(0xFF080A18);
  @override
  Color get panelBackground => const Color.fromARGB(255, 0, 43, 64);
  @override
  Color get cardBackground => const Color(0xFF11152D);

  @override
  double get borderRadius => AppConstants.borderRadius;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'Orbitron',
    );

    return ThemeData(
      fontFamily: 'Orbitron',
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
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
          fontWeight: FontWeight.w900,
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
    [const Color(0xFF18203B), const Color(0xFF10142A)],
    const Color(0xFF5161FF),
  );

  @override
  (List<Color>, Color) get operatorButtonColors => (
    [const Color(0xFF23285A), const Color(0xFF111B45)],
    const Color(0xFF00E5FF),
  );

  @override
  (List<Color>, Color) get functionButtonColors => (
    [const Color(0xFF321B47), const Color(0xFF181130)],
    const Color(0xFFFF2BD6),
  );

  @override
  (List<Color>, Color) get commandButtonColors => (
    [const Color(0xFF3F2D13), const Color(0xFF19160D)],
    const Color(0xFFFFD166),
  );

  @override
  (List<Color>, Color) get equalsButtonColors =>
      ([const Color(0xFF9B1BB8), const Color(0xFF0097B8)], Colors.white);

  @override
  CustomPainter? get backgroundPainter => const _NeonBackgroundPainter();

  @override
  String? get backgroundImage => null;

  @override
  CustomPainter? getButtonGlowPainter(double progress, Color color) =>
      _ButtonTapGlowPainter(progress: progress, color: color);

  @override
  CustomPainter? getHeaderGlowPainter(
    double progress,
    Color color,
    double borderRadius,
  ) => _HeaderTapGlowPainter(
    progress: progress,
    color: color,
    borderRadius: borderRadius,
  );

  @override
  BoxDecoration get displayDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.15),
        blurRadius: 40,
        spreadRadius: 4,
        offset: const Offset(-4, -4),
      ),
      BoxShadow(
        color: const Color(0xFF9B1BB8).withValues(alpha: 0.15),
        blurRadius: 40,
        spreadRadius: 4,
        offset: const Offset(4, 4),
      ),
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.1),
        blurRadius: 15,
        spreadRadius: 1,
      ),
    ],
  );

  @override
  BoxDecoration get panelDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    color: primaryColor.withValues(alpha: 0.2),
    border: Border.all(color: primaryColor),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.1),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ],
  );

  @override
  BoxDecoration get keypadUnderGlowDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    gradient: RadialGradient(
      center: Alignment.center,
      radius: 1.05,
      colors: [
        secondaryColor.withValues(alpha: .12),
        primaryColor.withValues(alpha: .08),
        Colors.transparent,
      ],
      stops: const [0, .48, 1],
    ),
    boxShadow: [
      BoxShadow(
        color: secondaryColor.withValues(alpha: .15),
        blurRadius: 40,
        spreadRadius: 5,
      ),
      BoxShadow(
        color: primaryColor.withValues(alpha: .12),
        blurRadius: 50,
        spreadRadius: 3,
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
          ? LinearGradient(
              colors: [equalsButtonColors.$1[0], equalsButtonColors.$1[1]],
            )
          : null,
      color: active || pressed ? null : cardBackground.withValues(alpha: 0.15),
      boxShadow: active || pressed
          ? [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.44),
                blurRadius: 0,
                spreadRadius: 1,
              ),
            ]
          : null,
    );
  }

  @override
  Color getDisplayPanelColor({
    required bool answerDisplayed,
    required bool equalFlash,
  }) {
    if (equalFlash) {
      return Color.lerp(panelBackground, Colors.white, 0.35)!;
    }
    return answerDisplayed ? panelBackground : Colors.black;
  }

  @override
  TextStyle? get displayTextStyle => const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 38,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
  );
  @override
  TextStyle? get resultTextStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: primaryColor,
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
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
  );

  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
  );

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getHistoryItemDecoration(bool isPressed) => BoxDecoration(
    color: isPressed ? primaryColor.withValues(alpha: 0.1) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isPressed ? primaryColor : primaryColor.withValues(alpha: 0.1),
      width: 1,
    ),
    boxShadow: [
      if (isPressed && useGlowEffects)
        BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10),
    ],
  );

  @override
  TextStyle get historyExpressionStyle =>
      TextStyle(fontFamily: 'Orbitron', color: Colors.grey[300], fontSize: 13);
  @override
  TextStyle get historyResultStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: primaryColor,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get historyDeleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.25),
        blurRadius: 22,
        spreadRadius: 2,
      ),
    ],
  );
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: primaryColor.withValues(alpha: 0.5), width: 1),
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 40),
    ],
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'PURGE SYSTEM' : 'SYSTEM ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'This action will permanently erase all calculation logs from the memory core.'
      : 'Operation in progress.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 4,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: 14,
    height: 1.5,
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
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'Orbitron',
    color: baseColor == Colors.white38 ? Colors.white54 : baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
    fontSize: 12,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? primaryColor.withValues(alpha: 0.2) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.1),
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
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}

class _NeonBackgroundPainter extends CustomPainter {
  const _NeonBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Gradient Sky (Synthwave style but neon colors)
    final skyGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF080A18), // backgroundDark
        Color(0xFF120E2B), // Deep navy
        Color(0xFF2B0E2B), // Deep purple-ish
      ],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = skyGradient);

    // 2. Neon Glowed Diamond Triangle
    _drawNeonTriangle(canvas, size);

    // 3. Perspective Grid (Synthwave style)
    final gridPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    final horizon = size.height * 0.6;

    // Radial lines
    for (var i = 0.0; i <= size.width; i += size.width / 10) {
      canvas.drawLine(
        Offset(size.width * 0.5, horizon),
        Offset(i, size.height),
        gridPaint,
      );
    }

    // Horizontal lines with perspective compression
    for (var i = 0.0; i <= 1.0; i += 0.1) {
      final y = horizon + (size.height - horizon) * math.pow(i, 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 4. Subtle Vignette
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: .5)],
        stops: const [0.5, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  void _drawNeonTriangle(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.4);
    final radius = size.width * 0.3; // Similar to synthwave sun

    final path = Path();
    // Equilateral triangle pointing up
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(
      center.dx + radius * math.cos(math.pi / 6),
      center.dy + radius * math.sin(math.pi / 6),
    );
    path.lineTo(
      center.dx - radius * math.cos(math.pi / 6),
      center.dy + radius * math.sin(math.pi / 6),
    );
    path.close();

    // Outer glow
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF2BD6).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32)
        ..style = PaintingStyle.fill,
    );

    // Triangle gradient
    final triangleGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF00E5FF), Color(0xFFFF2BD6)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(
      path,
      Paint()
        ..shader = triangleGradient
        ..style = PaintingStyle.fill,
    );

    // Diamond themed lines (facets)
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Lines from center to vertices
    canvas.drawLine(center, Offset(center.dx, center.dy - radius), linePaint);
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * math.cos(math.pi / 6),
        center.dy + radius * math.sin(math.pi / 6),
      ),
      linePaint,
    );
    canvas.drawLine(
      center,
      Offset(
        center.dx - radius * math.cos(math.pi / 6),
        center.dy + radius * math.sin(math.pi / 6),
      ),
      linePaint,
    );

    // Internal triangle
    final innerPath = Path();
    final innerRadius = radius * 0.45;
    innerPath.moveTo(center.dx, center.dy - innerRadius);
    innerPath.lineTo(
      center.dx + innerRadius * math.cos(math.pi / 6),
      center.dy + innerRadius * math.sin(math.pi / 6),
    );
    innerPath.lineTo(
      center.dx - innerRadius * math.cos(math.pi / 6),
      center.dy + innerRadius * math.sin(math.pi / 6),
    );
    innerPath.close();
    canvas.drawPath(innerPath, linePaint);

    // Add a diamond-like glow on top
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _NeonBackgroundPainter oldDelegate) => false;
}

class _ButtonTapGlowPainter extends CustomPainter {
  const _ButtonTapGlowPainter({required this.progress, required this.color});
  final double progress;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress >= 1) return;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.2),
      const Radius.circular(AppConstants.borderRadius),
    );
    final opacity = (math.sin(progress * math.pi) * 1.25).clamp(0.0, 1.0);
    final shader = SweepGradient(
      transform: GradientRotation(progress * math.pi * 2),
      colors: [
        color.withValues(alpha: .12 * opacity),
        color.withValues(alpha: .95 * opacity),
        Colors.white.withValues(alpha: opacity),
        color.withValues(alpha: .9 * opacity),
        color.withValues(alpha: .12 * opacity),
      ],
      stops: const [0, .25, .42, .62, 1],
    ).createShader(rect);
    final glowPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRRect(rrect, glowPaint);
    final outerGlowPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawRRect(rrect.inflate(1), outerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant _ButtonTapGlowPainter oldDelegate) => true;
}

class _HeaderTapGlowPainter extends CustomPainter {
  const _HeaderTapGlowPainter({
    required this.progress,
    required this.color,
    this.borderRadius = 8,
  });
  final double progress;
  final Color color;
  final double borderRadius;
  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress >= 1) return;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.2),
      Radius.circular(borderRadius),
    );
    final opacity = (math.sin(progress * math.pi) * 1.25).clamp(0.0, 1.0);
    final shader = SweepGradient(
      transform: GradientRotation(progress * math.pi * 2),
      colors: [
        color.withValues(alpha: .12 * opacity),
        color.withValues(alpha: .95 * opacity),
        Colors.white.withValues(alpha: opacity),
        color.withValues(alpha: .9 * opacity),
        color.withValues(alpha: .12 * opacity),
      ],
      stops: const [0, .25, .42, .62, 1],
    ).createShader(rect);
    final outerGlowPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawRRect(rrect.inflate(1), outerGlowPaint);
    final glowPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _HeaderTapGlowPainter oldDelegate) => true;
}
