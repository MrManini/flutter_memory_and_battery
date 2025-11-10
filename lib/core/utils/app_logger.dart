import 'package:logger/logger.dart';

/// Centralized logging utility for the app
///
/// Provides consistent logging across all optimization examples with:
/// - GREEN for good/optimized behavior (INFO level)
/// - RED for bad/non-optimized behavior (ERROR level)
/// - BLUE for debug information (DEBUG level)
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      colors: true, // Enable colors
      levelColors: {
        Level.debug: AnsiColor.fg(4), // Blue for debug info
        Level.info: AnsiColor.fg(2), // GREEN for good behavior
        Level.warning: AnsiColor.fg(3), // Yellow for warnings
        Level.error: AnsiColor.fg(1), // RED for bad behavior
      },
      methodCount: 0, // No stack trace for cleaner output
      errorMethodCount: 0,
      lineLength: 100,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  /// Log widget reuse (optimized behavior) - INFO level (GREEN)
  static void logWidgetReused(String widgetType, String context) {
    _logger.i('✅ REUSED: $widgetType in $context');
  }

  /// Log widget creation (non-optimized behavior) - ERROR level (RED)
  static void logWidgetCreated(String widgetType, String context) {
    _logger.e('❌ CREATED: $widgetType in $context');
  }

  /// Log build method calls - DEBUG level (BLUE)
  static void logBuildMethod(String widgetClass, Map<String, dynamic>? state) {
    final stateStr = state != null
        ? ' - ${state.entries.map((e) => '${e.key}: ${e.value}').join(', ')}'
        : '';
    _logger.d('🔄 BUILD: $widgetClass$stateStr');
  }

  /// Log optimization events - INFO level (GREEN)
  static void logOptimization(String optimization, String details) {
    _logger.i('✅ OPTIMIZATION: $optimization - $details');
  }

  /// Log performance issues - ERROR level (RED)
  static void logPerformanceIssue(String issue, String details) {
    _logger.e('⚠️ PERFORMANCE: $issue - $details');
  }

  /// Log resource lifecycle events - INFO level
  static void logResourceLifecycle(String resource, String action) {
    _logger.i('📦 RESOURCE: $resource - $action');
  }

  /// Log memory events - INFO level with memory emoji
  static void logMemoryEvent(String event, String details) {
    _logger.i('🧠 MEMORY: $event - $details');
  }

  /// Log battery events - INFO level with battery emoji
  static void logBatteryEvent(String event, String details) {
    _logger.i('🔋 BATTERY: $event - $details');
  }

  /// Log network events - INFO level with network emoji
  static void logNetworkEvent(String event, String details) {
    _logger.i('🌐 NETWORK: $event - $details');
  }

  /// Log timer/stream events - INFO level with clock emoji
  static void logTimerEvent(String event, String details) {
    _logger.i('⏰ TIMER: $event - $details');
  }

  /// Generic debug log
  static void debug(String message) {
    _logger.d(message);
  }

  /// Generic info log
  static void info(String message) {
    _logger.i(message);
  }

  /// Generic warning log
  static void warning(String message) {
    _logger.w(message);
  }

  /// Generic error log
  static void error(String message) {
    _logger.e(message);
  }
}
