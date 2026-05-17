import 'dart:math' as math;

import '../domain/angle_mode.dart';
import '../domain/calculator_engine.dart';

enum _TokenType { number, operator, function, leftParen, rightParen, constant }

class _Token {
  const _Token(this.type, this.value);

  final _TokenType type;
  final String value;
}

/// A high-performance expression evaluation engine for scientific calculations.
///
/// Uses the Shunting-yard algorithm to convert infix expressions to Reverse Polish Notation (RPN)
/// and then evaluates them. Supports basic operators, scientific functions, and constants.
class ExpressionCalculatorEngine implements CalculatorEngine {
  static const _operators = <String, int>{
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
    '%': 2,
    'logxy': 4,
    'root': 4,
    '^': 4,
    'u-': 5,
    '!': 6,
  };

  static const _functions = <String>{
    'sin',
    'cos',
    'tan',
    'asin',
    'acos',
    'atan',
    'sqrt',
    'ln',
    'log',
    'abs',
    'exp',
  };

  @override
  double evaluate(String expression, {required AngleMode angleMode}) {
    final normalized = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt')
        // Implicit multiplication between number/constant/parenthesis and another number/constant/parenthesis/function
        .replaceAllMapped(
          RegExp(
            r'(\d|pi|e|\))(?=\s*(?:(?:pi|e|sin|cos|tan|asin|acos|atan|sqrt|ln|log|abs|exp)(?![A-Za-z])|\())|'
            r'(pi|e|\))(?=\s*\d)',
          ),
          (m) => '${m[1] ?? m[2]!}*',
        )
        .replaceAll(RegExp(r'\s+'), '');

    if (normalized.isEmpty) {
      return 0;
    }

    final tokens = _tokenize(normalized);
    final rpn = _toReversePolish(tokens);
    return _evaluateReversePolish(rpn, angleMode);
  }

  List<_Token> _tokenize(String expression) {
    final tokens = <_Token>[];
    var index = 0;

    while (index < expression.length) {
      final char = expression[index];

      if (_isDigit(char) || char == '.') {
        final start = index;
        index++;
        while (index < expression.length &&
            (_isDigit(expression[index]) || expression[index] == '.')) {
          index++;
        }
        tokens.add(
          _Token(_TokenType.number, expression.substring(start, index)),
        );
        continue;
      }

      if (_isLetter(char)) {
        final start = index;
        index++;
        while (index < expression.length && _isLetter(expression[index])) {
          index++;
        }
        final word = expression.substring(start, index).toLowerCase();
        if (word == 'pi' || word == 'e') {
          tokens.add(_Token(_TokenType.constant, word));
        } else if (_functions.contains(word)) {
          tokens.add(_Token(_TokenType.function, word));
        } else if (_operators.containsKey(word)) {
          tokens.add(_Token(_TokenType.operator, word));
        } else {
          throw const FormatException('Unknown function');
        }
        continue;
      }

      if (char == '(') {
        tokens.add(const _Token(_TokenType.leftParen, '('));
        index++;
        continue;
      }

      if (char == ')') {
        tokens.add(const _Token(_TokenType.rightParen, ')'));
        index++;
        continue;
      }

      if (_operators.containsKey(char)) {
        if (char == '-' &&
            (tokens.isEmpty ||
                tokens.last.type == _TokenType.operator ||
                tokens.last.type == _TokenType.leftParen ||
                tokens.last.type == _TokenType.function)) {
          tokens.add(const _Token(_TokenType.operator, 'u-'));
        } else {
          tokens.add(_Token(_TokenType.operator, char));
        }
        index++;
        continue;
      }

      throw const FormatException('Invalid character');
    }

    return tokens;
  }

  List<_Token> _toReversePolish(List<_Token> tokens) {
    final output = <_Token>[];
    final stack = <_Token>[];

    for (final token in tokens) {
      switch (token.type) {
        case _TokenType.number:
        case _TokenType.constant:
          output.add(token);
        case _TokenType.function:
          stack.add(token);
        case _TokenType.operator:
          while (stack.isNotEmpty &&
              (stack.last.type == _TokenType.function ||
                  (stack.last.type == _TokenType.operator &&
                      _shouldPopOperator(token.value, stack.last.value)))) {
            output.add(stack.removeLast());
          }
          stack.add(token);
        case _TokenType.leftParen:
          stack.add(token);
        case _TokenType.rightParen:
          while (stack.isNotEmpty && stack.last.type != _TokenType.leftParen) {
            output.add(stack.removeLast());
          }
          if (stack.isEmpty) {
            throw const FormatException('Mismatched parentheses');
          }
          stack.removeLast();
          if (stack.isNotEmpty && stack.last.type == _TokenType.function) {
            output.add(stack.removeLast());
          }
      }
    }

    while (stack.isNotEmpty) {
      if (stack.last.type == _TokenType.leftParen) {
        throw const FormatException('Mismatched parentheses');
      }
      output.add(stack.removeLast());
    }

    return output;
  }

  bool _shouldPopOperator(String incoming, String stacked) {
    final incomingPrecedence = _operators[incoming]!;
    final stackedPrecedence = _operators[stacked]!;
    final rightAssociative = incoming == '^' || incoming == 'u-';
    return rightAssociative
        ? incomingPrecedence < stackedPrecedence
        : incomingPrecedence <= stackedPrecedence;
  }

  double _evaluateReversePolish(List<_Token> tokens, AngleMode angleMode) {
    final stack = <double>[];

    for (final token in tokens) {
      switch (token.type) {
        case _TokenType.number:
          final value = double.tryParse(token.value);
          if (value == null) {
            throw const FormatException('Invalid number');
          }
          stack.add(value);
        case _TokenType.constant:
          stack.add(token.value == 'pi' ? math.pi : math.e);
        case _TokenType.operator:
          _applyOperator(token.value, stack);
        case _TokenType.function:
          if (stack.isEmpty) {
            throw const FormatException('Missing argument');
          }
          stack.add(_applyFunction(token.value, stack.removeLast(), angleMode));
        case _TokenType.leftParen:
        case _TokenType.rightParen:
          throw const FormatException('Invalid expression');
      }
    }

    if (stack.length != 1 || stack.single.isNaN || stack.single.isInfinite) {
      throw const FormatException('Invalid result');
    }

    return stack.single;
  }

  void _applyOperator(String operator, List<double> stack) {
    if (operator == 'u-') {
      if (stack.isEmpty) {
        throw const FormatException('Missing operand');
      }
      stack.add(-stack.removeLast());
      return;
    }

    if (operator == '!') {
      if (stack.isEmpty) {
        throw const FormatException('Missing operand');
      }
      stack.add(_factorial(stack.removeLast()));
      return;
    }

    if (stack.length < 2) {
      throw const FormatException('Missing operand');
    }

    final right = stack.removeLast();
    final left = stack.removeLast();

    switch (operator) {
      case '+':
        stack.add(left + right);
      case '-':
        stack.add(left - right);
      case '*':
        stack.add(left * right);
      case '/':
        if (right == 0) {
          throw const FormatException('Cannot divide by zero');
        }
        stack.add(left / right);
      case '%':
        stack.add(left % right);
      case 'logxy':
        stack.add(_logBase(left, right));
      case 'root':
        stack.add(_nthRoot(left, right));
      case '^':
        stack.add(math.pow(left, right).toDouble());
      default:
        throw const FormatException('Unknown operator');
    }
  }

  double _applyFunction(String function, double value, AngleMode angleMode) {
    final radians = angleMode == AngleMode.degrees
        ? value * math.pi / 180
        : value;

    switch (function) {
      case 'sin':
        return math.sin(radians);
      case 'cos':
        return math.cos(radians);
      case 'tan':
        return math.tan(radians);
      case 'asin':
        final result = math.asin(value);
        return angleMode == AngleMode.degrees ? result * 180 / math.pi : result;
      case 'acos':
        final result = math.acos(value);
        return angleMode == AngleMode.degrees ? result * 180 / math.pi : result;
      case 'atan':
        final result = math.atan(value);
        return angleMode == AngleMode.degrees ? result * 180 / math.pi : result;
      case 'sqrt':
        if (value < 0) {
          throw const FormatException('Invalid square root');
        }
        return math.sqrt(value);
      case 'ln':
        if (value <= 0) {
          throw const FormatException('Invalid logarithm');
        }
        return math.log(value);
      case 'log':
        if (value <= 0) {
          throw const FormatException('Invalid logarithm');
        }
        return math.log(value) / math.ln10;
      case 'abs':
        return value.abs();
      case 'exp':
        return math.exp(value);
      default:
        throw const FormatException('Unknown function');
    }
  }

  double _factorial(double value) {
    if (value < 0 || value % 1 != 0 || value > 170) {
      throw const FormatException('Invalid factorial');
    }
    var result = 1.0;
    for (var i = 2; i <= value.toInt(); i++) {
      result *= i;
    }
    return result;
  }

  double _logBase(double base, double value) {
    if (base <= 0 || base == 1 || value <= 0) {
      throw const FormatException('Invalid logarithm');
    }
    return math.log(value) / math.log(base);
  }

  double _nthRoot(double degree, double value) {
    if (!degree.isFinite || !value.isFinite || degree == 0) {
      throw const FormatException('Invalid root');
    }

    if (value < 0) {
      if (degree % 1 != 0 || degree.toInt().isEven) {
        throw const FormatException('Invalid root');
      }
      return -math.pow(value.abs(), 1 / degree).toDouble();
    }

    final result = math.pow(value, 1 / degree).toDouble();
    if (result.isNaN || result.isInfinite) {
      throw const FormatException('Invalid root');
    }
    return result;
  }

  bool _isDigit(String character) {
    final code = character.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  bool _isLetter(String character) {
    final code = character.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }
}
