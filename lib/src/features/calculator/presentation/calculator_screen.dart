import 'package:flutter/material.dart';
import 'package:neon_calc/src/features/calculator/presentation/theme_screen.dart';
import '../../../app/theme/theme_controller.dart';
import '../domain/angle_mode.dart';
import '../domain/calculator_engine.dart';
import 'calculator_controller.dart';
import 'calculator_key.dart';
import 'widgets/display_panel.dart';
import 'history_screen.dart';
import 'widgets/key_panel.dart';
import 'widgets/neon_background.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({required this.engine, super.key});

  final CalculatorEngine engine;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorController _controller;

  bool _showScientific = false;
  bool _shiftActive = false;
  bool _answerDisplayed = false;
  bool _equalFlash = false;
  int _logoGlowToken = 0;
  int _shakeToken = 0;

  static const _basicKeys = <CalculatorKey>[
    CalculatorKey('MC', CalculatorKeyType.command),
    CalculatorKey('MR', CalculatorKeyType.command),
    CalculatorKey('M+', CalculatorKeyType.command),
    CalculatorKey('M-', CalculatorKeyType.command),
    CalculatorKey('AC', CalculatorKeyType.command),
    CalculatorKey(
      'DEL',
      CalculatorKeyType.command,
      icon: Icons.backspace_outlined,
    ),
    CalculatorKey('(', CalculatorKeyType.operator),
    CalculatorKey(')', CalculatorKeyType.operator),
    CalculatorKey('7', CalculatorKeyType.number),
    CalculatorKey('8', CalculatorKeyType.number),
    CalculatorKey('9', CalculatorKeyType.number),
    CalculatorKey('/', CalculatorKeyType.operator),
    CalculatorKey('4', CalculatorKeyType.number),
    CalculatorKey('5', CalculatorKeyType.number),
    CalculatorKey('6', CalculatorKeyType.number),
    CalculatorKey('*', CalculatorKeyType.operator),
    CalculatorKey('1', CalculatorKeyType.number),
    CalculatorKey('2', CalculatorKeyType.number),
    CalculatorKey('3', CalculatorKeyType.number),
    CalculatorKey('-', CalculatorKeyType.operator),
    CalculatorKey('0', CalculatorKeyType.number),
    CalculatorKey('.', CalculatorKeyType.number),
    CalculatorKey('+', CalculatorKeyType.operator),
    CalculatorKey('=', CalculatorKeyType.equals),
  ];

  List<CalculatorKey> _getScientificKeys() {
    return [
      const CalculatorKey('AC', CalculatorKeyType.command),
      const CalculatorKey(
        'DEL',
        CalculatorKeyType.command,
        icon: Icons.backspace_outlined,
        shiftLabel: '=',
        shiftType: CalculatorKeyType.equals,
      ),
      const CalculatorKey('SHIFT', CalculatorKeyType.command),
      const CalculatorKey('e', CalculatorKeyType.function, shiftLabel: 'logxy'),
      const CalculatorKey(
        'sin',
        CalculatorKeyType.function,
        shiftLabel: 'asin',
      ),
      const CalculatorKey(
        'cos',
        CalculatorKeyType.function,
        shiftLabel: 'acos',
      ),
      const CalculatorKey(
        'tan',
        CalculatorKeyType.function,
        shiftLabel: 'atan',
      ),
      const CalculatorKey(
        'x^2',
        CalculatorKeyType.operator,
        shiftLabel: 'sqrt',
      ),
      const CalculatorKey(
        'log',
        CalculatorKeyType.function,
        shiftLabel: '10^()',
      ),
      const CalculatorKey('ln', CalculatorKeyType.function, shiftLabel: 'e^()'),
      const CalculatorKey('exp', CalculatorKeyType.function, shiftLabel: '1/x'),
      const CalculatorKey(
        'x^()',
        CalculatorKeyType.operator,
        shiftLabel: 'root',
      ),
      const CalculatorKey('pi', CalculatorKeyType.function),
      const CalculatorKey('%', CalculatorKeyType.operator),
      const CalculatorKey('!', CalculatorKeyType.function),
      CalculatorKey(
        _controller.state.angleMode == AngleMode.degrees ? 'DEG' : 'RAD',
        CalculatorKeyType.command,
      ),
      const CalculatorKey('BIN', CalculatorKeyType.command),
      const CalculatorKey('OCT', CalculatorKeyType.command),
      const CalculatorKey('DEC', CalculatorKeyType.command),
      const CalculatorKey('HEX', CalculatorKeyType.command),
    ];
  }

  // Loading stages for staggered build
  bool _showDisplay = false;
  // ignore: unused_field
  bool _showMode = false;
  bool _showKeypad = false;
  bool _keypadFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController(widget.engine);

    // Sequence the loading stages
    _startStagedEntrance();
  }

  Future<void> _startStagedEntrance() async {
    // 1. Background is already loaded by the Scaffold/NeonBackground.

    // 2. Load display (Stage 1)
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _showDisplay = true);

    // 3. Load mode switch (Stage 2)
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _showMode = true);

    // 4. Load keypad (Stage 3)
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mounted) setState(() => _showKeypad = true);

    // Mark that initial load is complete so animation triggers on mode switches
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() => _keypadFirstLoad = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return Scaffold(
      body: NeonBackground(
        theme: currentTheme,
        isZoomed: _answerDisplayed && _controller.state.error == null,
        shakeToken: _shakeToken,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 720;
                final horizontalPadding = wide ? 12.0 : 0.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: RepaintBoundary(
                        child: wide
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildDisplaySection(),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        _buildModeSection(),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: _buildKeypadSection(wide),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * .34,
                                    child: _buildDisplaySection(),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildModeSection(),
                                  const SizedBox(height: 10),
                                  Expanded(child: _buildKeypadSection(wide)),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplaySection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.1, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _showDisplay
          ? DisplayPanel(
              controller: _controller,
              onHistoryPressed: _navigateToHistory,
              onThemePressed: _navigateToThemes,
              answerDisplayed: _answerDisplayed,
              equalFlash: _equalFlash,
              logoGlowToken: _logoGlowToken,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildModeSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _showMode
          ? CalculatorModeSwitch(
              showScientific: _showScientific,
              onChanged: (value) {
                setState(() {
                  _showScientific = value;
                  _shiftActive = false;
                });
              },
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildKeypadSection(bool wide) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.15, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _showKeypad
          ? KeyPanel(
              controller: _controller,
              keys: _showScientific ? _getScientificKeys() : _basicKeys,
              columns: _showScientific ? 4 : (wide ? 6 : 4),
              showScientific: _showScientific,
              shiftActive: _shiftActive,
              onShiftChanged: (value) {
                setState(() => _shiftActive = value);
              },
              onInputPressed: _clearAnswerDisplay,
              onEqualPressed: _boostDisplay,
              onAcPressed: _pulseLogoAndClearDisplay,
              isInitialLoad: _keypadFirstLoad,
            )
          : const SizedBox.shrink(),
    );
  }

  void _navigateToHistory() async {
    final expression = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => HistoryScreen(controller: _controller),
      ),
    );

    if (expression != null && mounted) {
      // Wait for the transition to fully finish before loading data
      await Future.delayed(const Duration(milliseconds: 350));
      _controller.restoreExpression(expression);
    }
  }

  void _navigateToThemes() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ThemeScreen()));

    if (mounted) {
      setState(() {});
    }
  }

  void _boostDisplay() {
    setState(() {
      _answerDisplayed = true;
      _equalFlash = true;
      _logoGlowToken++;
      if (_controller.state.error != null) {
        _shakeToken++;
      }
    });
    Future<void>.delayed(const Duration(milliseconds: 140), () {
      if (mounted) {
        setState(() => _equalFlash = false);
      }
    });
  }

  void _pulseLogoAndClearDisplay() {
    setState(() {
      _answerDisplayed = false;
      _equalFlash = false;
      _logoGlowToken++;
    });
  }

  void _clearAnswerDisplay() {
    if (_answerDisplayed || _controller.state.error != null) {
      setState(() {
        _answerDisplayed = false;
      });
    }
  }
}
