import 'package:flutter/material.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating rebuild optimization
/// 
/// KEY OPTIMIZATION:
/// Minimize unnecessary widget rebuilds by using const widgets,
/// RepaintBoundary, and proper state management.
class RebuildOptimizationExample extends StatelessWidget {
  const RebuildOptimizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Rebuild Optimization',
      optimizedWidget: const _OptimizedRebuildExample(),
      nonOptimizedWidget: const _NonOptimizedRebuildExample(),
    );
  }
}

/// OPTIMIZED: Minimizes rebuilds with const and RepaintBoundary
class _OptimizedRebuildExample extends StatefulWidget {
  const _OptimizedRebuildExample();

  @override
  State<_OptimizedRebuildExample> createState() =>
      _OptimizedRebuildExampleState();
}

class _OptimizedRebuildExampleState extends State<_OptimizedRebuildExample> {
  int _counter = 0;
  int _rebuilds = 0;

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
                Text(
                  'Optimized Rebuilds',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '✓ Using const widgets',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ RepaintBoundary for isolation',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ Only necessary widgets rebuild',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // This card doesn't rebuild because it's const
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                SizedBox(height: 8),
                Text(
                  'Static Content',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('This widget never rebuilds'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // RepaintBoundary prevents this from triggering parent rebuilds
        RepaintBoundary(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Dynamic Counter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_counter',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(() => _counter++),
                    child: const Text('Increment'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Isolated by RepaintBoundary',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Another const widget that never rebuilds
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Benefits:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Less CPU usage'),
                Text('• Better battery life'),
                Text('• Smoother UI'),
                Text('• Faster performance'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Everything rebuilds unnecessarily
class _NonOptimizedRebuildExample extends StatefulWidget {
  const _NonOptimizedRebuildExample();

  @override
  State<_NonOptimizedRebuildExample> createState() =>
      _NonOptimizedRebuildExampleState();
}

class _NonOptimizedRebuildExampleState
    extends State<_NonOptimizedRebuildExample> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // PROBLEM: Everything rebuilds on every setState call
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Non-Optimized Rebuilds',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '✗ No const widgets',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ No RepaintBoundary',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Everything rebuilds',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // This rebuilds unnecessarily
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 48),
                SizedBox(height: 8),
                Text(
                  'Static Content',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('This rebuilds unnecessarily!'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // No RepaintBoundary - causes full tree rebuild
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Dynamic Counter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '$_counter',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _counter++),
                  child: Text('Increment'),
                ),
                SizedBox(height: 8),
                Text(
                  'Causes entire tree to rebuild',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // This also rebuilds unnecessarily
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problems:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Higher CPU usage'),
                Text('• Drains battery faster'),
                Text('• UI lag possible'),
                Text('• Inefficient rendering'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
