import '../entities/optimization_example.dart';
import '../repositories/optimization_repository.dart';

/// Use case for retrieving optimization examples
/// This encapsulates business logic and keeps it separate from UI
class GetOptimizationExamples {
  final OptimizationRepository repository;

  GetOptimizationExamples(this.repository);

  /// Executes the use case to get all examples
  List<OptimizationExample> execute() {
    return repository.getAllExamples();
  }

  /// Gets examples filtered by type
  List<OptimizationExample> executeByType(OptimizationType type) {
    return repository.getExamplesByType(type);
  }
}
