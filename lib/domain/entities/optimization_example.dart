import 'package:equatable/equatable.dart';

/// Represents an optimization technique example
class OptimizationExample extends Equatable {
  final String id;
  final String title;
  final String description;
  final OptimizationType type;
  final String? routeName;

  const OptimizationExample({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.routeName,
  });

  @override
  List<Object?> get props => [id, title, description, type, routeName];
}

/// Types of optimization techniques
enum OptimizationType {
  memory,
  battery,
  both,
}

/// Represents performance metrics for comparison
class PerformanceMetrics extends Equatable {
  final String exampleId;
  final double memoryUsageMB;
  final int rebuildCount;
  final double frameRenderTimeMs;
  final bool isOptimized;

  const PerformanceMetrics({
    required this.exampleId,
    required this.memoryUsageMB,
    required this.rebuildCount,
    required this.frameRenderTimeMs,
    required this.isOptimized,
  });

  @override
  List<Object?> get props => [
        exampleId,
        memoryUsageMB,
        rebuildCount,
        frameRenderTimeMs,
        isOptimized,
      ];
}
