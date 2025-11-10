import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating ListView vs ListView.builder
/// 
/// KEY OPTIMIZATION:
/// ListView.builder only creates widgets for items that are visible on screen,
/// dramatically reducing memory usage for large lists.
class ListViewExample extends StatelessWidget {
  const ListViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'ListView Optimization',
      optimizedWidget: const _OptimizedListView(),
      nonOptimizedWidget: const _NonOptimizedListView(),
    );
  }
}

/// OPTIMIZED: Uses ListView.builder for lazy loading
class _OptimizedListView extends StatelessWidget {
  const _OptimizedListView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green[50],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ListView.builder',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Only renders visible items',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            // Only creates widgets for visible items
            itemCount: AppConstants.largeListItemCount,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                title: Text('Item $index'),
                subtitle: Text('Efficiently rendered item'),
                trailing: Text('${index + 1}'),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.green[100],
          child: Text(
            '✓ ${AppConstants.largeListItemCount} items with minimal memory',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Creates all items at once
class _NonOptimizedListView extends StatelessWidget {
  const _NonOptimizedListView();

  @override
  Widget build(BuildContext context) {
    // Using a smaller count to prevent memory issues in the demo
    const itemCount = 100;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.orange[50],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ListView (all items)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Creates all widgets upfront',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            // Creates ALL widgets immediately - memory intensive!
            children: List.generate(
              itemCount,
              (index) => ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.warning, color: Colors.white),
                ),
                title: Text('Item $index'),
                subtitle: const Text('All created at once'),
                trailing: Text('${index + 1}'),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.orange[100],
          child: Text(
            '✗ Only $itemCount items (to avoid memory issues)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
