import 'package:flutter/material.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating const vs non-const widgets
/// 
/// KEY OPTIMIZATION:
/// Using const constructors allows Flutter to reuse widget instances
/// instead of creating new ones on every rebuild, reducing memory allocation
/// and improving performance.
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using const means this Text widget is created once
          const Text(
            '✓ Const Text Widget',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Only this Text widget is recreated on rebuild
          Text(
            'Counter: $_counter',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: const Text('Increment'),
          ),
          const SizedBox(height: 20),
          
          // Const icon - reused on every rebuild
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 20),
          
          // Information card
          const Card(
            margin: EdgeInsets.all(16),
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
                  Text('• Widgets marked const are reused'),
                  Text('• Reduces memory allocations'),
                  Text('• Faster rebuilds'),
                  Text('• Better performance'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // No const - new Text widget created on every rebuild
          Text(
            '✗ Non-Const Text Widget',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          
          Text(
            'Counter: $_counter',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: Text('Increment'),
          ),
          SizedBox(height: 20),
          
          // No const - new Icon created on every rebuild
          Icon(Icons.warning, color: Colors.orange, size: 48),
          SizedBox(height: 20),
          
          // Information card without const
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Issues:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('• All widgets recreated on rebuild'),
                  Text('• More memory allocations'),
                  Text('• Slower rebuilds'),
                  Text('• Unnecessary CPU usage'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
