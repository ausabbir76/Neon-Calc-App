class AppConstants {
  const AppConstants._();

  /// Maximum number of items to keep in history.
  static const int historyLimit = 10;

  /// Precision for formatting non-exponential numbers.
  static const int decimalPrecision = 10;

  /// Threshold for switching to exponential notation.
  static const double exponentialThreshold = 1e9;

  /// Lower threshold for switching to exponential notation.
  static const double smallThreshold = 1e-6;

  /// Standard border radius for cards and buttons.
  static const double borderRadius = 20.0;

  /// Duration for entrance animations.
  static const Duration entranceDuration = Duration(milliseconds: 450);

  /// Duration for quick UI feedback animations.
  static const Duration feedbackDuration = Duration(milliseconds: 90);
}
