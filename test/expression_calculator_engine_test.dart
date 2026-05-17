import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:neon_calc/src/features/calculator/data/expression_calculator_engine.dart';
import 'package:neon_calc/src/features/calculator/domain/angle_mode.dart';

void main() {
  late ExpressionCalculatorEngine engine;

  setUp(() {
    engine = ExpressionCalculatorEngine();
  });

  group('ExpressionCalculatorEngine', () {
    test('evaluates operator precedence and powers', () {
      expect(engine.evaluate('2+3*4', angleMode: AngleMode.degrees), 14);
      expect(engine.evaluate('2^3+1', angleMode: AngleMode.degrees), 9);
    });

    test('evaluates supported scientific functions', () {
      expect(
        engine.evaluate('sin(90)', angleMode: AngleMode.degrees),
        closeTo(1, 0.000001),
      );
      expect(engine.evaluate('log(100)', angleMode: AngleMode.degrees), 2);
      expect(engine.evaluate('sqrt(81)', angleMode: AngleMode.degrees), 9);
      expect(engine.evaluate('abs(-12)', angleMode: AngleMode.degrees), 12);
      expect(
        engine.evaluate('ln(e)', angleMode: AngleMode.radians),
        closeTo(1, 0.000001),
      );
    });

    test('evaluates inverse trig functions and custom operators', () {
      expect(engine.evaluate('asin(1)', angleMode: AngleMode.degrees), 90);
      expect(engine.evaluate('2logxy8', angleMode: AngleMode.degrees), 3);
      expect(engine.evaluate('3root27', angleMode: AngleMode.degrees), 3);
      expect(engine.evaluate('5!', angleMode: AngleMode.degrees), 120);
    });

    test('rejects invalid math', () {
      expect(
        () => engine.evaluate('1/0', angleMode: AngleMode.degrees),
        throwsFormatException,
      );
    });

    test('handles implicit multiplication with parentheses', () {
      expect(engine.evaluate('2(3)', angleMode: AngleMode.degrees), 6);
      expect(engine.evaluate('(1+2)(3+4)', angleMode: AngleMode.degrees), 21);
      expect(engine.evaluate('(2)3', angleMode: AngleMode.degrees), 6);
      expect(engine.evaluate('(2)sin(0)', angleMode: AngleMode.degrees), 0);
      expect(
        engine.evaluate('(2)pi', angleMode: AngleMode.radians),
        closeTo(2 * math.pi, 1e-10),
      );
    });

    test('handles implicit multiplication with constants and functions', () {
      expect(
        engine.evaluate('2pi', angleMode: AngleMode.radians),
        closeTo(2 * math.pi, 1e-10),
      );
      expect(
        engine.evaluate('pi(2)', angleMode: AngleMode.radians),
        closeTo(2 * math.pi, 1e-10),
      );
      expect(engine.evaluate('2sin(0)', angleMode: AngleMode.degrees), 0);
      expect(
        engine.evaluate('pi sin(pi/2)', angleMode: AngleMode.radians),
        closeTo(math.pi, 1e-10),
      );
    });

    test('handles complex scientific expressions', () {
      expect(
        engine.evaluate('sin(pi/2)', angleMode: AngleMode.radians),
        closeTo(1, 1e-10),
      );
      expect(engine.evaluate('log(100)', angleMode: AngleMode.degrees), 2);
    });
  });
}
