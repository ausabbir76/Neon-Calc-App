import 'package:flutter/material.dart';
import '../calculator_controller.dart';
import '../../domain/angle_mode.dart';
import '../../domain/utils/number_formatter.dart';
import '../../../../app/theme/theme_controller.dart';
import '../../../../app/sound/sound_controller.dart';
import '../../../../app/app_constants.dart';
import 'header_controls.dart';

class DisplayPanel extends StatefulWidget {
  const DisplayPanel({
    required this.controller,
    required this.onHistoryPressed,
    required this.onThemePressed,
    required this.answerDisplayed,
    required this.equalFlash,
    required this.logoGlowToken,
    super.key,
  });

  final CalculatorController controller;
  final VoidCallback onHistoryPressed;
  final VoidCallback onThemePressed;
  final bool answerDisplayed;
  final bool equalFlash;
  final int logoGlowToken;

  @override
  State<DisplayPanel> createState() => _DisplayPanelState();
}

class _DisplayPanelState extends State<DisplayPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _equalGlowController;

  @override
  void initState() {
    super.initState();
    _equalGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void didUpdateWidget(covariant DisplayPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.equalFlash && !oldWidget.equalFlash) {
      _equalGlowController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _equalGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController(),
      builder: (context, _) {
        final currentTheme = ThemeController().currentTheme;
        final baseDecoration = currentTheme.displayDecoration;

        return RepaintBoundary(
          child: AnimatedScale(
            scale: widget.equalFlash ? 1.025 : 1,
            duration: AppConstants.feedbackDuration,
            curve: Curves.easeOutCubic,
            child: Container(
              decoration: baseDecoration,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    currentTheme.borderRadius,
                  ),
                  color: currentTheme.getDisplayPanelColor(
                    answerDisplayed: widget.answerDisplayed,
                    equalFlash: widget.equalFlash,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _LogoMark(triggerToken: widget.logoGlowToken),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NEON CALC',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: currentTheme.primaryColor,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Arcade',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: currentTheme.appBarIconColor
                                          .withValues(alpha: 0.7),
                                      letterSpacing: 0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        HeaderActionButton(
                          icon: currentTheme.icons.settings,
                          label: 'Themes',
                          onPressed: widget.onThemePressed,
                        ),
                        const SizedBox(width: 8),
                        HeaderActionButton(
                          icon: currentTheme.icons.history,
                          label: 'History',
                          onPressed: widget.onHistoryPressed,
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              SoundController().playTopButton();
                              widget.controller.press('ANGLE_MODE');
                            },
                            child: ListenableBuilder(
                              listenable: widget.controller,
                              builder: (context, _) {
                                return ModePill(
                                  label:
                                      widget.controller.state.angleMode ==
                                          AngleMode.degrees
                                      ? 'DEG'
                                      : 'RAD',
                                  active: true,
                                  fixedHeaderSize: true,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: ListenableBuilder(
                          listenable: widget.controller,
                          builder: (context, _) {
                            return _AnimatedExpressionText(
                              expression: widget.controller.state.expression,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, _) {
                        final state = widget.controller.state;
                        final baseStyle =
                            currentTheme.resultTextStyle ??
                            Theme.of(context).textTheme.headlineLarge!;

                        final textColor = state.error == null
                            ? baseStyle.color ?? currentTheme.secondaryColor
                            : currentTheme.historyDeleteIconColor;

                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 240),
                          style: baseStyle.copyWith(color: textColor),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: _AnimatedResultText(
                              value: state.error ?? state.preview,
                              style: baseStyle.copyWith(color: textColor),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, _) {
                        return Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          alignment: WrapAlignment.end,
                          children: [
                            ModePill(
                              label:
                                  'MEM ${NumberFormatter.formatMemory(widget.controller.state.memory)}',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogoMark extends StatefulWidget {
  const _LogoMark({required this.triggerToken});

  final int triggerToken;

  @override
  State<_LogoMark> createState() => _LogoMarkState();
}

class _LogoMarkState extends State<_LogoMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didUpdateWidget(covariant _LogoMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerToken != oldWidget.triggerToken) {
      _glowController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return CustomPaint(
          painter: currentTheme.getHeaderGlowPainter(
            _glowController.value,
            currentTheme.primaryColor,
            currentTheme.borderRadius,
          ),
          child: child,
        );
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(currentTheme.borderRadius),
          gradient: LinearGradient(
            colors: [currentTheme.primaryColor, currentTheme.secondaryColor],
          ),
          boxShadow: [
            if (currentTheme.useGlowEffects) ...[
              BoxShadow(
                color: currentTheme.primaryColor.withValues(alpha: 0.4),
                blurRadius: 16,
              ),
              BoxShadow(
                color: currentTheme.secondaryColor.withValues(alpha: 0.33),
                blurRadius: 24,
              ),
            ],
          ],
        ),
        child: Icon(currentTheme.icons.logo, color: Colors.white, size: 22),
      ),
    );
  }
}

class _AnimatedExpressionText extends StatelessWidget {
  const _AnimatedExpressionText({required this.expression});

  final String expression;

  @override
  Widget build(BuildContext context) {
    if (expression.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentTheme = ThemeController().currentTheme;
    final style =
        currentTheme.displayTextStyle ??
        Theme.of(context).textTheme.headlineMedium!;

    final prefix = expression.length > 1
        ? expression.substring(0, expression.length - 1)
        : '';
    final latest = expression.substring(expression.length - 1);

    return RepaintBoundary(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Static prefix - no animation
            Text(prefix, maxLines: 1, style: style),
            // Only the newest character animates
            _NewestCharacter(
              key: ValueKey(expression),
              char: latest,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewestCharacter extends StatelessWidget {
  const _NewestCharacter({required this.char, required this.style, super.key});

  final String char;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.5, end: 1),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: (2.5 - scale).clamp(0.0, 1.0), child: child),
        );
      },
      child: Text(char, maxLines: 1, style: style),
    );
  }
}

class _AnimatedResultText extends StatefulWidget {
  const _AnimatedResultText({required this.value, required this.style});

  final String value;
  final TextStyle style;

  @override
  State<_AnimatedResultText> createState() => _AnimatedResultTextState();
}

class _AnimatedResultTextState extends State<_AnimatedResultText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.42), weight: 18),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.42,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 82,
      ),
    ]).animate(_controller);
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 18),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 82,
      ),
    ]).animate(_controller);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedResultText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomRight,
        child: Text(widget.value, style: widget.style),
      ),
    );
  }
}

class ModePill extends StatefulWidget {
  const ModePill({
    required this.label,
    this.active = false,
    this.fixedHeaderSize = false,
    super.key,
  });

  final String label;
  final bool active;
  final bool fixedHeaderSize;

  @override
  State<ModePill> createState() => _ModePillState();
}

class _ModePillState extends State<ModePill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _changeGlowController;

  @override
  void initState() {
    super.initState();
    _changeGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void didUpdateWidget(covariant ModePill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && oldWidget.label != widget.label) {
      _changeGlowController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _changeGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return AnimatedBuilder(
      animation: _changeGlowController,
      builder: (context, child) {
        final flashing =
            widget.active &&
            _changeGlowController.value > 0 &&
            _changeGlowController.value < .12;
        return CustomPaint(
          painter: widget.active
              ? currentTheme.getHeaderGlowPainter(
                  _changeGlowController.value,
                  currentTheme.primaryColor,
                  currentTheme.borderRadius,
                )
              : null,
          child: AnimatedContainer(
            duration: AppConstants.feedbackDuration,
            curve: Curves.easeOutCubic,
            width: widget.fixedHeaderSize ? HeaderControlSize.width : null,
            height: widget.fixedHeaderSize ? HeaderControlSize.height : null,
            padding: widget.fixedHeaderSize
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            constraints: widget.fixedHeaderSize
                ? null
                : const BoxConstraints(minHeight: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(currentTheme.borderRadius),
              gradient: flashing
                  ? LinearGradient(
                      colors: [
                        currentTheme.primaryColor,
                        currentTheme.secondaryColor,
                      ],
                    )
                  : null,
              color: flashing
                  ? null
                  : widget.active
                  ? currentTheme.primaryColor.withValues(alpha: 0.2)
                  : currentTheme.cardBackground.withValues(alpha: 0.15),
              border: Border.all(
                color: widget.active
                    ? currentTheme.primaryColor
                    : Colors.white.withValues(alpha: 0.26),
              ),
              boxShadow: [
                if (widget.active && currentTheme.useGlowEffects)
                  BoxShadow(
                    color: currentTheme.primaryColor.withValues(
                      alpha: flashing ? .72 : .18,
                    ),
                    blurRadius: 0,
                    spreadRadius: flashing ? 2 : 0,
                  ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: widget.active ? currentTheme.primaryColor : Colors.white70,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
