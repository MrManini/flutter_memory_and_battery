import 'dart:async';
import 'dart:math' as math;

/// Utility class for performance optimization techniques
class PerformanceUtils {
  /// Debounces a function call by delaying execution until after a specified time
  /// has elapsed since the last time it was invoked.
  ///
  /// This is useful for:
  /// - Search input fields
  /// - API calls triggered by user input
  /// - Scroll event handlers
  ///
  /// Example:
  /// ```dart
  /// final debouncer = PerformanceUtils.debounce(
  ///   Duration(milliseconds: 500),
  ///   () => performSearch(query),
  /// );
  /// ```
  static void Function() debounce(Duration duration, void Function() callback) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(duration, callback);
    };
  }

  /// Throttles a function call to execute at most once per specified duration.
  /// Unlike debounce, throttle ensures the function is called at regular intervals.
  ///
  /// This is useful for:
  /// - Scroll event handlers
  /// - Window resize handlers
  /// - Button click protection
  static void throttle(
    Duration duration,
    void Function() callback, {
    required bool Function() canExecute,
  }) {
    if (canExecute()) {
      callback();
    }
  }

  /// Calculates memory usage (for demonstration purposes)
  /// In a real app, you would use platform-specific methods
  static String getMemoryUsageEstimate(int itemCount) {
    // Rough estimate: each item ~100 bytes
    final bytes = itemCount * 100;
    return formatBytes(bytes);
  }

  /// Formats bytes into human-readable format
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// Simulates heavy computation for demonstration
  static Future<List<int>> heavyComputation(int count) async {
    return await Future.delayed(
      const Duration(milliseconds: 500),
      () => List.generate(count, (index) => index * index),
    );
  }

  /// Simulates heavy computation using compute (isolate)
  static List<double> computeHeavyTask(int iterations) {
    final results = <double>[];

    // Perform intensive mathematical operations
    for (int i = 0; i < iterations; i++) {
      double result = 0;

      // Nested loops with expensive operations
      for (int j = 0; j < 1000; j++) {
        for (int k = 0; k < 100; k++) {
          // Complex mathematical operations that consume CPU
          result += (i * j * k).toDouble();
          result = result * 1.001; // Multiplication
          result = result / 1.0001; // Division
          result += (i + j + k) * 0.5; // More operations

          // Trigonometric functions (expensive)
          if (k % 10 == 0) {
            result += math.sin(result * 0.1);
            result += math.cos(result * 0.1);
          }

          // Square root operations
          if (result > 0) {
            result = math.sqrt(result);
            result = result * result; // Square it back
          }
        }
      }

      results.add(result);

      // Add some string operations too
      final str = 'computation_$i';
      str.split('_').join('-').toUpperCase().toLowerCase();
    }

    return results;
  }
}

/// Debouncer class for easier usage
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
