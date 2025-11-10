import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/comparison_view.dart';

/// Example demonstrating proper resource disposal
/// 
/// KEY OPTIMIZATION:
/// Always dispose of controllers, streams, and listeners to prevent memory leaks.
/// Undisposed resources continue to consume memory even after the widget is removed.
class ResourceDisposalExample extends StatelessWidget {
  const ResourceDisposalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Resource Disposal',
      optimizedWidget: const _OptimizedDisposalExample(),
      nonOptimizedWidget: const _NonOptimizedDisposalExample(),
    );
  }
}

/// OPTIMIZED: Properly disposes all resources
class _OptimizedDisposalExample extends StatefulWidget {
  const _OptimizedDisposalExample();

  @override
  State<_OptimizedDisposalExample> createState() =>
      _OptimizedDisposalExampleState();
}

class _OptimizedDisposalExampleState extends State<_OptimizedDisposalExample> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  Timer? _timer;
  StreamSubscription? _subscription;
  int _timerTicks = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    
    // Start a periodic timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timerTicks++);
      }
    });

    // Create a stream subscription
    _subscription = Stream.periodic(const Duration(seconds: 2))
        .listen((event) {
      if (mounted) {
        debugPrint('Stream event: $event');
      }
    });
  }

  @override
  void dispose() {
    // ✓ IMPORTANT: Dispose all controllers and cancel subscriptions
    _controller.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
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
                      'Proper Disposal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'All resources are properly disposed:',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text('✓ TextEditingController', style: TextStyle(color: Colors.white)),
                Text('✓ ScrollController', style: TextStyle(color: Colors.white)),
                Text('✓ Timer subscription', style: TextStyle(color: Colors.white)),
                Text('✓ Stream subscription', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Text Input',
            border: OutlineInputBorder(),
            helperText: 'Controller will be disposed',
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Timer is running:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ticks: $_timerTicks',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Timer will be cancelled on dispose',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  'Result:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• No memory leaks'),
                Text('• Clean resource cleanup'),
                Text('• Better app stability'),
                Text('• Prevents crashes'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Does not dispose resources properly
class _NonOptimizedDisposalExample extends StatefulWidget {
  const _NonOptimizedDisposalExample();

  @override
  State<_NonOptimizedDisposalExample> createState() =>
      _NonOptimizedDisposalExampleState();
}

class _NonOptimizedDisposalExampleState
    extends State<_NonOptimizedDisposalExample> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  Timer? _timer;
  StreamSubscription? _subscription;
  int _timerTicks = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    
    // Start a periodic timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timerTicks++);
      }
    });

    // Create a stream subscription
    _subscription = Stream.periodic(const Duration(seconds: 2))
        .listen((event) {
      if (mounted) {
        debugPrint('Stream event: $event');
      }
    });
  }

  @override
  void dispose() {
    // ✗ NOT disposing resources - MEMORY LEAK!
    // Controllers, timers, and subscriptions continue to run
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'No Disposal!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Resources are NOT disposed:',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text('✗ TextEditingController leaks', style: TextStyle(color: Colors.white)),
                Text('✗ ScrollController leaks', style: TextStyle(color: Colors.white)),
                Text('✗ Timer keeps running', style: TextStyle(color: Colors.white)),
                Text('✗ Stream subscription active', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Text Input',
            border: OutlineInputBorder(),
            helperText: 'Controller will NOT be disposed!',
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Timer is running:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ticks: $_timerTicks',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Timer will continue after widget disposal!',
                  style: TextStyle(fontSize: 12, color: Colors.red),
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
                  'Problems:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Memory leaks accumulate'),
                Text('• Resources stay allocated'),
                Text('• App becomes unstable'),
                Text('• Potential crashes'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
