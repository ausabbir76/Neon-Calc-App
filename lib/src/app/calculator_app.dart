import 'package:flutter/material.dart';

import '../features/calculator/data/expression_calculator_engine.dart';
import '../features/calculator/domain/calculator_engine.dart';
import '../features/calculator/presentation/calculator_screen.dart';
import 'theme/theme_controller.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorEngine engine = ExpressionCalculatorEngine();
    final themeController = ThemeController();

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Neon Scientific Calculator',
          debugShowCheckedModeBanner: false,
          theme: themeController.currentTheme.themeData,
          home: CalculatorScreen(engine: engine),
        );
      },
    );
  }
}
