import '../../../../app/app_constants.dart';

class NumberFormatter {
  const NumberFormatter._();

  static String format(double value) {
    if (value == 0) return '0';

    if (value.abs() >= AppConstants.exponentialThreshold ||
        value.abs() < AppConstants.smallThreshold) {
      return _formatScientific(value);
    }

    final rounded = value.toStringAsFixed(AppConstants.decimalPrecision);
    return rounded.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  static String formatMemory(double value) {
    if (value == 0) return '0';
    return value.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  static String _formatScientific(double value) {
    final parts = value.toStringAsExponential(8).split('e');
    final coefficient = parts.first.replaceFirst(RegExp(r'\.?0+$'), '');
    final exponent = int.parse(parts.last);
    return '$coefficient*10^$exponent';
  }
}
