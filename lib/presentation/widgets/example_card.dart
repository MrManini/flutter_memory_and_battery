import 'package:flutter/material.dart';
import '../../domain/entities/optimization_example.dart';

/// Reusable card widget for displaying optimization examples
/// Uses const constructor for better memory performance
class ExampleCard extends StatelessWidget {
  final OptimizationExample example;
  final VoidCallback onTap;

  const ExampleCard({
    super.key,
    required this.example,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForType(example.type),
                    color: _getColorForType(example.type),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      example.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                example.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  _getTypeLabel(example.type),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: _getColorForType(example.type).withOpacity(0.2),
                side: BorderSide.none,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(OptimizationType type) {
    switch (type) {
      case OptimizationType.memory:
        return Icons.memory;
      case OptimizationType.battery:
        return Icons.battery_charging_full;
      case OptimizationType.both:
        return Icons.speed;
    }
  }

  Color _getColorForType(OptimizationType type) {
    switch (type) {
      case OptimizationType.memory:
        return Colors.blue;
      case OptimizationType.battery:
        return Colors.green;
      case OptimizationType.both:
        return Colors.purple;
    }
  }

  String _getTypeLabel(OptimizationType type) {
    switch (type) {
      case OptimizationType.memory:
        return 'MEMORY';
      case OptimizationType.battery:
        return 'BATTERY';
      case OptimizationType.both:
        return 'BOTH';
    }
  }
}
