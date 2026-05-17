import 'angle_mode.dart';

class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.preview = '0',
    this.memory = 0,
    this.angleMode = AngleMode.degrees,
    this.error,
  });

  final String expression;
  final String preview;
  final double memory;
  final AngleMode angleMode;
  final String? error;

  CalculatorState copyWith({
    String? expression,
    String? preview,
    double? memory,
    AngleMode? angleMode,
    String? error,
    bool clearError = false,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      preview: preview ?? this.preview,
      memory: memory ?? this.memory,
      angleMode: angleMode ?? this.angleMode,
      error: clearError ? null : error ?? this.error,
    );
  }
}
