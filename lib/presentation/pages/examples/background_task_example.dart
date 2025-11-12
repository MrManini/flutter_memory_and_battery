import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/performance_utils.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating background task optimization with isolates
///
/// KEY OPTIMIZATION:
/// Use compute() to run expensive operations on separate isolates,
/// preventing UI blocking and distributing CPU load.
class BackgroundTaskExample extends StatelessWidget {
  const BackgroundTaskExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Background Processing',
      optimizedWidget: const _OptimizedBackgroundExample(),
      nonOptimizedWidget: const _NonOptimizedBackgroundExample(),
    );
  }
}

/// OPTIMIZED: Uses compute() for heavy tasks
class _OptimizedBackgroundExample extends StatefulWidget {
  const _OptimizedBackgroundExample();

  @override
  State<_OptimizedBackgroundExample> createState() =>
      _OptimizedBackgroundExampleState();
}

class _OptimizedBackgroundExampleState
    extends State<_OptimizedBackgroundExample> {
  bool _isProcessing = false;
  String _result = '';
  int _taskCount = 0;

  Future<void> _runHeavyTask() async {
    setState(() {
      _isProcessing = true;
      _result = 'Processing in isolate...';
    });

    AppLogger.info('✅ OPTIMIZED: Starting heavy computation in isolate...');

    try {
      final startTime = DateTime.now();
      // Run computation in a separate isolate - UI stays responsive!
      final result = await compute(PerformanceUtils.computeHeavyTask, 50);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      setState(() {
        _isProcessing = false;
        _result = 'Completed ${result.length} calculations in ${duration}ms';
        _taskCount++;
      });

      AppLogger.info(
        '✅ OPTIMIZED: Computation completed in isolate - UI stayed responsive! (${duration}ms)',
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _result = 'Error: $e';
      });
      AppLogger.error('❌ OPTIMIZED: Error in isolate computation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Isolate Processing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '✓ Uses compute() for heavy tasks',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ UI stays responsive',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ Distributes CPU load',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Heavy Computation Task',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _runHeavyTask,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(
                    _isProcessing ? 'Processing...' : 'Run Heavy Task',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _result,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tasks completed: $_taskCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try This:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Tap the button to start processing'),
                Text('• Try scrolling while processing'),
                Text('• Notice the UI stays smooth'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Animated element to show UI responsiveness
        const _AnimatedIndicator(color: Colors.green),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Benefits:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• No UI blocking'),
                Text('• Better user experience'),
                Text('• Efficient CPU usage'),
                Text('• Better battery management'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Runs heavy tasks on UI thread
class _NonOptimizedBackgroundExample extends StatefulWidget {
  const _NonOptimizedBackgroundExample();

  @override
  State<_NonOptimizedBackgroundExample> createState() =>
      _NonOptimizedBackgroundExampleState();
}

class _NonOptimizedBackgroundExampleState
    extends State<_NonOptimizedBackgroundExample> {
  bool _isProcessing = false;
  String _result = '';
  int _taskCount = 0;

  Future<void> _runHeavyTask() async {
    setState(() {
      _isProcessing = true;
      _result = 'Processing on UI thread...';
    });

    AppLogger.warning(
      '⚠️ NON-OPTIMIZED: Starting heavy computation on UI thread - UI will freeze!',
    );
    final startTime = DateTime.now();

    // PROBLEM: Running on UI thread - blocks UI!
    final result = PerformanceUtils.computeHeavyTask(50);

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;

    setState(() {
      _isProcessing = false;
      _result = 'Completed ${result.length} calculations in ${duration}ms';
      _taskCount++;
    });

    AppLogger.error(
      '❌ NON-OPTIMIZED: Computation completed on UI thread - UI was frozen for ${duration}ms!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'UI Thread Processing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '✗ Runs on UI thread',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Blocks user interface',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Causes jank and lag',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Heavy Computation Task',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _runHeavyTask,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(
                    _isProcessing ? 'Processing...' : 'Run Heavy Task',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _result,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tasks completed: $_taskCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try This:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Tap the button to start processing'),
                Text('• Try scrolling while processing'),
                Text('• Notice the UI freezes!'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Animated element to show UI blocking
        const _AnimatedIndicator(color: Colors.red),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problems:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• UI freezes during processing'),
                Text('• Poor user experience'),
                Text('• Dropped frames'),
                Text('• App feels unresponsive'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated indicator to show UI responsiveness
class _AnimatedIndicator extends StatefulWidget {
  final Color color;

  const _AnimatedIndicator({required this.color});

  @override
  State<_AnimatedIndicator> createState() => _AnimatedIndicatorState();
}

class _AnimatedIndicatorState extends State<_AnimatedIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'UI Responsiveness Test',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  minHeight: 8,
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'This should animate smoothly',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
