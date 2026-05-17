import 'package:flutter/foundation.dart';
import '../domain/angle_mode.dart';
import '../domain/calculator_engine.dart';
import '../domain/calculator_state.dart';
import '../domain/utils/number_formatter.dart';

import '../data/database_helper.dart';
import '../domain/history_item.dart';

/// Manages the state and business logic of the calculator.
///
/// Handles user input, maintains the current expression and its preview,
/// manages calculation history, and controls memory operations.
class CalculatorController extends ChangeNotifier {
  CalculatorController(this._engine) {
    _loadHistory();
  }

  final CalculatorEngine _engine;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  CalculatorState _state = const CalculatorState();
  List<HistoryItem> _history = <HistoryItem>[];
  bool _disposed = false;

  CalculatorState get state => _state;
  List<HistoryItem> get history => List.unmodifiable(_history);

  Future<void> _loadHistory() async {
    _history = await _dbHelper.getAllHistory();
    _notifyListeners();
  }

  Future<void> deleteHistoryItem(int id) async {
    await _dbHelper.deleteHistory(id);
    _history.removeWhere((item) => item.id == id);
    _notifyListeners();
  }

  Future<void> clearHistory() async {
    await _dbHelper.clearAllHistory();
    _history.clear();
    _notifyListeners();
  }

  void press(String value) {
    switch (value) {
      case 'AC':
        _state = CalculatorState(
          memory: _state.memory,
          angleMode: _state.angleMode,
        );
      case 'DEL':
        _removeLast();
      case '=':
        _commit();
      case 'DEG':
      case 'RAD':
      case 'ANGLE_MODE':
        _toggleAngleMode();
      case 'MC':
        _state = _state.copyWith(memory: 0, clearError: true);
      case 'MR':
        _append(NumberFormatter.format(_state.memory));
      case 'M+':
        _memoryAdd();
      case 'M-':
        _memorySubtract();
      case 'BIN':
      case 'OCT':
      case 'DEC':
      case 'HEX':
        _convertBase(value);
      case '1/x':
        _applyReciprocal();
      default:
        _append(value);
    }
    if (value != '=') {
      _notifyListeners();
    }
  }

  void restoreExpression(String expression) {
    _state = _state.copyWith(expression: expression, clearError: true);
    _updatePreview();
    _notifyListeners();
  }

  void _append(String value) {
    final mapped = switch (value) {
      'sin' ||
      'cos' ||
      'tan' ||
      'asin' ||
      'acos' ||
      'atan' ||
      'log' ||
      'ln' ||
      'sqrt' ||
      'abs' ||
      'exp' => '$value(',
      '10^()' => '10^(',
      'e^()' => 'e^(',
      'x2' || 'x^2' => '^2',
      'xy' || 'x^()' => '^',
      _ => value,
    };

    _state = _state.copyWith(
      expression: '${_state.expression}$mapped',
      clearError: true,
    );
    _updatePreview();
  }

  void _removeLast() {
    if (_state.expression.isEmpty) {
      _state = _state.copyWith(clearError: true);
      return;
    }

    final expression = _state.expression;
    final cut =
        expression.endsWith('logxy') ||
            expression.endsWith('asin(') ||
            expression.endsWith('acos(') ||
            expression.endsWith('atan(') ||
            expression.endsWith('sqrt(')
        ? 5
        : expression.endsWith('10^(') ||
              expression.endsWith('root') ||
              expression.endsWith('sin(') ||
              expression.endsWith('cos(') ||
              expression.endsWith('tan(') ||
              expression.endsWith('log(') ||
              expression.endsWith('abs(') ||
              expression.endsWith('exp(')
        ? 4
        : expression.endsWith('ln(')
        ? 3
        : expression.endsWith('e^(')
        ? 3
        : expression.endsWith('^2')
        ? 2
        : expression.endsWith('pi')
        ? 2
        : 1;

    _state = _state.copyWith(
      expression: expression.substring(0, expression.length - cut),
      clearError: true,
    );
    _updatePreview();
  }

  Future<void> _commit() async {
    final expression = _state.expression;
    final preview = _state.preview;

    try {
      final result = _engine.evaluate(expression, angleMode: _state.angleMode);
      final formatted = NumberFormatter.format(result);

      final alreadyShowingResult =
          expression == formatted && preview == formatted;

      _state = _state.copyWith(
        expression: formatted,
        preview: formatted,
        clearError: true,
      );
      _notifyListeners();

      if (expression.isNotEmpty && !alreadyShowingResult) {
        final item = HistoryItem(
          expression: expression,
          result: formatted,
          timestamp: DateTime.now(),
        );

        if (_history.isEmpty ||
            _history.first.displayString != item.displayString) {
          final id = await _dbHelper.insertHistory(item);
          _history.insert(
            0,
            HistoryItem(
              id: id,
              expression: item.expression,
              result: item.result,
              timestamp: item.timestamp,
            ),
          );

          _notifyListeners();
        }
      }
    } on FormatException catch (error) {
      _state = _state.copyWith(error: error.message, preview: 'Error');
      _notifyListeners();
    }
  }

  void _toggleAngleMode() {
    _state = _state.copyWith(
      angleMode: _state.angleMode == AngleMode.degrees
          ? AngleMode.radians
          : AngleMode.degrees,
      clearError: true,
    );
    _updatePreview();
  }

  void _memoryAdd() {
    final value = _currentValueOrZero();
    _state = _state.copyWith(memory: _state.memory + value, clearError: true);
  }

  void _memorySubtract() {
    final value = _currentValueOrZero();
    _state = _state.copyWith(memory: _state.memory - value, clearError: true);
  }

  void _applyReciprocal() {
    try {
      final value = _engine.evaluate(
        _state.expression,
        angleMode: _state.angleMode,
      );
      if (value == 0) {
        throw const FormatException('Cannot divide by zero');
      }
      final formatted = NumberFormatter.format(1 / value);
      _state = _state.copyWith(
        expression: formatted,
        preview: formatted,
        clearError: true,
      );
    } on FormatException catch (error) {
      _state = _state.copyWith(error: error.message, preview: 'Error');
    }
  }

  void _convertBase(String base) {
    try {
      final value = _engine.evaluate(
        _state.expression,
        angleMode: _state.angleMode,
      );
      final converted = switch (base) {
        'BIN' => _formatIntegerBase(value, 2),
        'OCT' => _formatIntegerBase(value, 8),
        'DEC' => NumberFormatter.format(value),
        'HEX' => _formatIntegerBase(value, 16),
        _ => throw const FormatException('Unknown base'),
      };
      _state = _state.copyWith(preview: converted, clearError: true);
    } on FormatException catch (error) {
      _state = _state.copyWith(error: error.message, preview: 'Error');
    }
  }

  String _formatIntegerBase(double value, int radix) {
    if (!value.isFinite || value.truncateToDouble() != value) {
      throw const FormatException('Integer only');
    }
    return value.toInt().toRadixString(radix).toUpperCase();
  }

  double _currentValueOrZero() {
    try {
      return _engine.evaluate(_state.expression, angleMode: _state.angleMode);
    } on FormatException {
      return 0;
    }
  }

  void _updatePreview() {
    if (_state.expression.isEmpty) {
      _state = _state.copyWith(preview: '0', clearError: true);
      return;
    }

    try {
      final result = _engine.evaluate(
        _state.expression,
        angleMode: _state.angleMode,
      );
      _state = _state.copyWith(
        preview: NumberFormatter.format(result),
        clearError: true,
      );
    } on FormatException {
      _state = _state.copyWith(preview: '...');
    }
  }

  void _notifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
