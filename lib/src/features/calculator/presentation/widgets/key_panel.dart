import 'package:flutter/material.dart';
import '../calculator_controller.dart';
import '../calculator_key.dart';
import '../../../../app/theme/theme_controller.dart';
import '../../../../app/sound/sound_controller.dart';
import '../../../../app/app_constants.dart';
import 'calculator_button.dart';

class KeyPanel extends StatelessWidget {
  const KeyPanel({
    required this.controller,
    required this.keys,
    required this.columns,
    required this.showScientific,
    required this.shiftActive,
    required this.onShiftChanged,
    required this.onInputPressed,
    required this.onEqualPressed,
    required this.onAcPressed,
    this.isInitialLoad = false,
    super.key,
  });

  final CalculatorController controller;
  final List<CalculatorKey> keys;
  final int columns;
  final bool showScientific;
  final bool shiftActive;
  final ValueChanged<bool> onShiftChanged;
  final VoidCallback onInputPressed;
  final VoidCallback onEqualPressed;
  final VoidCallback onAcPressed;
  final bool isInitialLoad;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final spacing = constraints.maxWidth < 380 ? 8.0 : 10.0;
          final rows = _buildRows(keys, columns);

          final keypadContent = Column(
            key: ValueKey(showScientific),
            children: [
              for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: rowIndex == rows.length - 1 ? 0 : spacing,
                    ),
                    child: Row(
                      children: [
                        for (
                          var keyIndex = 0;
                          keyIndex < rows[rowIndex].length;
                          keyIndex++
                        )
                          Expanded(
                            flex: rows[rowIndex][keyIndex].flex,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: keyIndex == rows[rowIndex].length - 1
                                    ? 0
                                    : spacing,
                              ),
                              child: CalculatorButton(
                                calculatorKey: rows[rowIndex][keyIndex],
                                shifted:
                                    shiftActive &&
                                    showScientific &&
                                    rows[rowIndex][keyIndex].label != 'SHIFT',
                                active:
                                    shiftActive &&
                                    showScientific &&
                                    rows[rowIndex][keyIndex].label == 'SHIFT',
                                onPressed: (value) {
                                  if (value == 'SHIFT') {
                                    onShiftChanged(!shiftActive);
                                    onInputPressed();
                                    return;
                                  }

                                  controller.press(value);
                                  if (shiftActive && showScientific) {
                                    onShiftChanged(false);
                                  }
                                  if (value == '=') {
                                    onEqualPressed();
                                  } else if (value == 'AC') {
                                    onAcPressed();
                                  } else {
                                    onInputPressed();
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                child: _KeypadUnderGlow(active: showScientific && shiftActive),
              ),
              if (isInitialLoad)
                keypadContent
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOut,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [?currentChild],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.88, end: 1).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: keypadContent,
                ),
            ],
          );
        },
      ),
    );
  }

  List<List<CalculatorKey>> _buildRows(
    List<CalculatorKey> source,
    int columns,
  ) {
    final rows = <List<CalculatorKey>>[];
    var current = <CalculatorKey>[];
    var width = 0;

    for (final key in source) {
      if (width + key.flex > columns && current.isNotEmpty) {
        rows.add(current);
        current = <CalculatorKey>[];
        width = 0;
      }
      current.add(key);
      width += key.flex;
      if (width == columns) {
        rows.add(current);
        current = <CalculatorKey>[];
        width = 0;
      }
    }

    if (current.isNotEmpty) {
      rows.add(current);
    }

    return rows;
  }
}

class _KeypadUnderGlow extends StatelessWidget {
  const _KeypadUnderGlow({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        child: DecoratedBox(decoration: currentTheme.keypadUnderGlowDecoration),
      ),
    );
  }
}

class CalculatorModeSwitch extends StatelessWidget {
  const CalculatorModeSwitch({
    required this.showScientific,
    required this.onChanged,
    super.key,
  });

  final bool showScientific;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(currentTheme.borderRadius),
        color: currentTheme.panelBackground.withValues(alpha: 0.66),
        border: Border.all(
          color: currentTheme.primaryColor.withValues(alpha: 0.26),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SwitchSegment(
              label: 'Basic',
              icon: currentTheme.icons.modeBasic,
              active: !showScientific,
              onTap: () => onChanged(false),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: _SwitchSegment(
              label: 'Scientific',
              icon: currentTheme.icons.modeScientific,
              active: showScientific,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchSegment extends StatefulWidget {
  const _SwitchSegment({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SwitchSegment> createState() => _SwitchSegmentState();
}

class _SwitchSegmentState extends State<_SwitchSegment>
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
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _tapGlowController
          ..reset()
          ..forward();
      },
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        SoundController().playModeSwitch();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? .96 : 1,
        duration: AppConstants.feedbackDuration,
        curve: Curves.easeOutBack,
        child: AnimatedBuilder(
          animation: _tapGlowController,
          builder: (context, child) {
            return CustomPaint(
              painter: currentTheme.getHeaderGlowPainter(
                _tapGlowController.value,
                widget.active
                    ? currentTheme.primaryColor
                    : currentTheme.secondaryColor,
                currentTheme.borderRadius,
              ),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: currentTheme.getSwitchSegmentDecoration(
              active: widget.active,
              pressed: _pressed,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, size: 17, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      widget.label,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
