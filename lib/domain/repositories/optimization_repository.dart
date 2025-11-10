import '../entities/optimization_example.dart';

/// Repository interface for optimization examples
/// Following clean architecture, this defines the contract for data operations
abstract class OptimizationRepository {
  /// Gets all available optimization examples
  List<OptimizationExample> getAllExamples();

  /// Gets examples filtered by type
  List<OptimizationExample> getExamplesByType(OptimizationType type);

  /// Gets a specific example by ID
  OptimizationExample? getExampleById(String id);

  /// Records performance metrics for an example
  void recordMetrics(PerformanceMetrics metrics);

  /// Gets recorded metrics for an example
  List<PerformanceMetrics> getMetrics(String exampleId);
}
