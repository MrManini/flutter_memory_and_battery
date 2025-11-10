import 'package:flutter/material.dart';

/// Widget for top-down comparison of optimized vs non-optimized implementations
/// Shows non-optimized (bad practice) first, then optimized (good practice) below
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
    this.optimizedLabel = 'Optimized ✓',
    this.nonOptimizedLabel = 'Non-Optimized ✗',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        children: [
          // Non-Optimized section (shown first - bad practice)
          _buildSection(
            context: context,
            label: nonOptimizedLabel,
            color: Colors.red,
            icon: Icons.cancel,
            widget: nonOptimizedWidget,
            isFirst: true,
          ),
          

          
          // Optimized section (shown second - good practice)
          _buildSection(
            context: context,
            label: optimizedLabel,
            color: Colors.green,
            icon: Icons.check_circle,
            widget: optimizedWidget,
            isFirst: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
    required Widget widget,
    required bool isFirst,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            border: Border(
              bottom: BorderSide(color: color, width: 2),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Section content
        Container(
          constraints: const BoxConstraints(
            minHeight: 300,
            maxHeight: 500,
          ),
          child: widget,
        ),
      ],
    );
  }
}
