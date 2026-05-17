import 'package:flutter/material.dart';
import '../../../../app/app_constants.dart';
import '../../../../app/theme/theme_controller.dart';
import '../../../../app/theme/models/calculator_theme.dart';

class HeaderActionButton extends StatefulWidget {
  const HeaderActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  State<HeaderActionButton> createState() => _HeaderActionButtonState();
}

class HeaderControlSize {
  const HeaderControlSize._();
  static const width = 42.0;
  static const height = 30.0;
}

class _HeaderActionButtonState extends State<HeaderActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapGlowController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _tapGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _tapGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return Tooltip(
      message: widget.label,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressed = true);
          _tapGlowController
            ..reset()
            ..forward();
        },
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed();
        },
        child: AnimatedScale(
          scale: _pressed ? .92 : 1,
          duration: AppConstants.feedbackDuration,
          curve: Curves.easeOutBack,
          child: AnimatedBuilder(
            animation: _tapGlowController,
            builder: (context, child) {
              return CustomPaint(
                painter: currentTheme.getHeaderGlowPainter(
                  _tapGlowController.value,
                  currentTheme.primaryColor,
                  currentTheme.borderRadius,
                ),
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: AppConstants.feedbackDuration,
              curve: Curves.easeOutCubic,
              width: HeaderControlSize.width,
              height: HeaderControlSize.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(currentTheme.borderRadius),
                gradient: _pressed
                    ? LinearGradient(
                        colors: [
                          currentTheme.equalsButtonColors.$1[1],
                          currentTheme.equalsButtonColors.$1[0],
                        ],
                      )
                    : (currentTheme.type == ThemeType.retro ? null : null),
                color: _pressed
                    ? null
                    : (currentTheme.type == ThemeType.retro
                          ? currentTheme.primaryColor.withValues(alpha: 0.1)
                          : currentTheme.primaryColor.withValues(alpha: 0.2)),
                border: Border.all(
                  color: currentTheme.type == ThemeType.retro
                      ? currentTheme.primaryColor
                      : currentTheme.primaryColor,
                  width: currentTheme.type == ThemeType.retro ? 2 : 1,
                ),
                boxShadow: [
                  if (_pressed && currentTheme.useGlowEffects)
                    BoxShadow(
                      color: currentTheme.primaryColor.withValues(alpha: .72),
                      blurRadius: 0,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: _pressed
                    ? (currentTheme.type == ThemeType.retro
                          ? currentTheme.backgroundDark
                          : Colors.white)
                    : currentTheme.primaryColor,
                size: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
