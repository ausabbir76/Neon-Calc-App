import 'package:flutter/material.dart';

enum CalculatorKeyType { number, operator, function, command, equals }

class CalculatorKey {
  const CalculatorKey(
    this.label,
    this.type, {
    this.flex = 1,
    this.icon,
    this.shiftLabel,
    this.shiftValue,
    this.shiftType,
  });

  final String label;
  final CalculatorKeyType type;
  final int flex;
  final IconData? icon;
  final String? shiftLabel;
  final String? shiftValue;
  final CalculatorKeyType? shiftType;

  String valueFor({required bool shifted}) {
    if (!shifted) return label;
    return shiftValue ?? shiftLabel ?? label;
  }

  CalculatorKeyType typeFor({required bool shifted}) {
    if (!shifted) return type;
    return shiftType ?? type;
  }
}
