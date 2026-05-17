class HistoryItem {
  const HistoryItem({
    this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  final int? id;
  final String expression;
  final String result;
  final DateTime timestamp;

  String get displayString => '$expression = $result';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as int?,
      expression: map['expression'] as String,
      result: map['result'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }
}
