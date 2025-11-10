import 'package:flutter/material.dart';
import '../../widgets/comparison_view.dart';
import '../../widgets/logging_widgets.dart';
import '../../../core/utils/app_logger.dart';

/// Example demonstrating const vs non-const widgets with detailed logging
///
/// KEY OPTIMIZATION:
/// Using const constructors allows Flutter to reuse widget instances
/// instead of creating new ones on every rebuild, reducing memory allocation
/// and improving performance.
///
/// LOGGING FEATURES:
/// - Logger package provides colored, formatted output
/// - INFO level (🟢): Shows when const widgets are reused
/// - WARNING level (🔴): Shows when new widgets are created
/// - DEBUG level (🔄): Shows when build() methods are called
///
/// Run the app and watch the console to see the dramatic difference!
class ConstWidgetsExample extends StatelessWidget {
  const ConstWidgetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Const Widgets Optimization',
      optimizedWidget: const _OptimizedConstExample(),
      nonOptimizedWidget: const _NonOptimizedConstExample(),
    );
  }
}

/// OPTIMIZED: Uses const constructors
/// This widget tree is created once and reused
class _OptimizedConstExample extends StatefulWidget {
  const _OptimizedConstExample();

  @override
  State<_OptimizedConstExample> createState() => _OptimizedConstExampleState();
}

class _OptimizedConstExampleState extends State<_OptimizedConstExample> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    AppLogger.logBuildMethod('_OptimizedConstExampleState', {
      'counter': _counter,
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using const means this widget is created once and reused
          const OptimizedLoggingText(
            text: '✓ Const Text Widget',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            context: 'OPTIMIZED',
          ),
          const SizedBox(height: 20),

          // Only this Text widget is recreated on rebuild (counter changes)
          Text('Counter: $_counter', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: const Text('Increment'),
          ),
          const SizedBox(height: 20),

          // Const icon - reused on every rebuild
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 20),

          // Information card with logging instructions
          const Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Watch the logs!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('✅ Const widgets: GREEN'),
                  Text('❌ Non-const widgets: RED'),
                  Text('🔄 build() method: BLUE'),
                  Text('• Tap increment to see the difference'),
                  Text('• Check your terminal/debug console'),
                  Text('• Green = Good, Red = Bad!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// NON-OPTIMIZED: Does not use const constructors
/// All widgets are recreated on every setState call
class _NonOptimizedConstExample extends StatefulWidget {
  const _NonOptimizedConstExample();

  @override
  State<_NonOptimizedConstExample> createState() =>
      _NonOptimizedConstExampleState();
}

class _NonOptimizedConstExampleState extends State<_NonOptimizedConstExample> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    AppLogger.logBuildMethod('_NonOptimizedConstExampleState', {
      'counter': _counter,
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // No const - new widget created on every rebuild
          NonOptimizedLoggingText(
            text: '✗ Non-Const Text Widget',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            context: 'NON-OPTIMIZED',
          ),
          const SizedBox(height: 20),

          Text('Counter: $_counter', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            // No const - new Text widget created each time
            child: NonOptimizedLoggingText(
              text: 'Increment',
              context: 'BUTTON-TEXT',
            ),
          ),

          // No const - new Icon created on every rebuild
          const Icon(Icons.cancel, color: Colors.red, size: 48),

          // Information card without const
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Watch the logs!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  NonOptimizedLoggingText(
                    text: '❌ Non-const widgets: RED',
                    context: 'CARD-TEXT-1',
                  ),
                  NonOptimizedLoggingText(
                    text: '🔄 build() method: BLUE',
                    context: 'CARD-TEXT-2',
                  ),
                  NonOptimizedLoggingText(
                    text: '• Tap increment to see MORE red logs',
                    context: 'CARD-TEXT-3',
                  ),
                  NonOptimizedLoggingText(
                    text: '• Much more memory allocation!',
                    context: 'CARD-TEXT-4',
                  ),
                  NonOptimizedLoggingText(
                    text: '• Red = Bad performance!',
                    context: 'CARD-TEXT-5',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
