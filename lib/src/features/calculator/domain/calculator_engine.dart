import 'angle_mode.dart';

abstract class CalculatorEngine {
  double evaluate(String expression, {required AngleMode angleMode});
}
