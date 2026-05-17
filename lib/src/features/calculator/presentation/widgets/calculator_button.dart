import 'package:flutter/material.dart';

import '../../../../app/theme/models/calculator_theme.dart';
import '../../../../app/theme/theme_controller.dart';
import '../../../../app/sound/sound_controller.dart';
import '../calculator_key.dart';

class CalculatorButton extends StatefulWidget {
  const CalculatorButton({
    required this.calculatorKey,
    required this.onPressed,
    this.shifted = false,
    this.active = false,
    super.key,
  });

  final CalculatorKey calculatorKey;
  final ValueChanged<String> onPressed;
  final bool shifted;
  final bool active;

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _tapGlowController;

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
    return ListenableBuilder(
      listenable: ThemeController(),
      builder: (context, _) {
        final currentTheme = ThemeController().currentTheme;
        final effectiveType = widget.calculatorKey.typeFor(
          shifted: widget.shifted,
        );
        final colors = _colorsForType(effectiveType, currentTheme);

        final highlighted = _pressed || widget.active;

        // Theme-agnostic color selection
        final Color foreground = highlighted
            ? Colors.white
            : (effectiveType == CalculatorKeyType.number
                  ? currentTheme.primaryColor
                  : colors.$2);

        final effectiveForeground = widget.active ? Colors.blue : foreground;

        final effectiveLabel = widget.calculatorKey.valueFor(
          shifted: widget.shifted,
        );

        return RepaintBoundary(
          child: Semantics(
            button: true,
            label: effectiveLabel,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) {
                setState(() => _pressed = false);
                _tapGlowController
                  ..reset()
                  ..forward();

                // Play sound based on key type and label
                final soundController = SoundController();
                if (effectiveLabel == 'DEL') {
                  soundController.playDelete();
                } else if (effectiveLabel == 'AC') {
                  soundController.playCommand();
                } else {
                  switch (effectiveType) {
                    case CalculatorKeyType.number:
                      soundController.playDigit();
                    case CalculatorKeyType.operator:
                      soundController.playOperator();
                    case CalculatorKeyType.equals:
                      soundController.playEqual();
                    case CalculatorKeyType.command:
                    case CalculatorKeyType.function:
                      soundController.playCommand();
                  }
                }

                widget.onPressed(effectiveLabel);
              },
              child: AnimatedScale(
                scale: _pressed ? .92 : 1,
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOutBack,
                child: AnimatedBuilder(
                  animation: _tapGlowController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: currentTheme.getButtonGlowPainter(
                        _tapGlowController.value,
                        colors.$2,
                      ),
                      child: child,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 90),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        currentTheme.borderRadius,
                      ),
                      gradient: highlighted
                          ? LinearGradient(
                              colors: [
                                colors.$2,
                                Color.lerp(colors.$2, Colors.white, .22)!,
                              ],
                            )
                          : LinearGradient(colors: colors.$1),
                      border: Border.all(
                        color: colors.$2.withValues(
                          alpha: highlighted ? 1 : .52,
                        ),
                      ),
                      boxShadow: [
                        if (currentTheme.useGlowEffects)
                          BoxShadow(
                            color: colors.$2.withValues(
                              alpha: highlighted ? .72 : .18,
                            ),
                            blurRadius: highlighted ? 8 : 0,
                            spreadRadius: highlighted ? 2 : 1,
                          ),
                      ],
                    ),
                    child: Center(
                      child: RepaintBoundary(
                        child: _buildButtonContent(
                          context,
                          foreground: effectiveForeground,
                          highlighted: highlighted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonContent(
    BuildContext context, {
    required Color foreground,
    required bool highlighted,
  }) {
    final currentTheme = ThemeController().currentTheme;

    if (widget.calculatorKey.icon != null && !widget.shifted) {
      return Icon(widget.calculatorKey.icon, color: foreground);
    }

    final mainLabel = widget.calculatorKey.valueFor(shifted: widget.shifted);
    final secondaryLabel = widget.calculatorKey.shiftLabel == null
        ? null
        : widget.shifted
        ? (widget.calculatorKey.label == 'DEL'
              ? null
              : widget.calculatorKey.label)
        : widget.calculatorKey.shiftLabel;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (secondaryLabel != null) ...[
            Text(
              secondaryLabel,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: highlighted
                    ? Colors.white70
                    : currentTheme.secondaryColor.withValues(alpha: .6),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 2),
          ],
          Text(
            mainLabel,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foreground,
              fontSize: secondaryLabel == null ? 18 : 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  (List<Color>, Color) _colorsForType(
    CalculatorKeyType type,
    CalculatorTheme currentTheme,
  ) {
    return switch (type) {
      CalculatorKeyType.number => currentTheme.numberButtonColors,
      CalculatorKeyType.operator => currentTheme.operatorButtonColors,
      CalculatorKeyType.function => currentTheme.functionButtonColors,
      CalculatorKeyType.command => currentTheme.commandButtonColors,
      CalculatorKeyType.equals => currentTheme.equalsButtonColors,
    };
  }
}
