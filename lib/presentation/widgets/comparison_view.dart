import 'package:flutter/material.dart';

/// Widget for side-by-side comparison of optimized vs non-optimized implementations
class ComparisonView extends StatelessWidget {
  final String title;
  final Widget optimizedWidget;
  final Widget nonOptimizedWidget;
  final String optimizedLabel;
  final String nonOptimizedLabel;

  const ComparisonView({
    super.key,
    required this.title,
    required this.optimizedWidget,
    required this.nonOptimizedWidget,
    this.optimizedLabel = 'Optimized',
    this.nonOptimizedLabel = 'Non-Optimized',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Header with labels
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: _buildLabel(
                    context,
                    optimizedLabel,
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLabel(
                    context,
                    nonOptimizedLabel,
                    Colors.orange,
                    Icons.warning,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1, thickness: 2),
          
          // Side-by-side comparison
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: optimizedWidget,
                  ),
                ),
                Expanded(
                  child: nonOptimizedWidget,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
