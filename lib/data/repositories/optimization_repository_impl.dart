import '../../domain/entities/optimization_example.dart';
import '../../domain/repositories/optimization_repository.dart';
import '../datasources/optimization_local_datasource.dart';

/// Implementation of the OptimizationRepository
/// This is part of the data layer and implements the domain layer interface
class OptimizationRepositoryImpl implements OptimizationRepository {
  final OptimizationLocalDataSource localDataSource;
  final List<PerformanceMetrics> _metricsCache = [];

  OptimizationRepositoryImpl({required this.localDataSource});

  @override
  List<OptimizationExample> getAllExamples() {
    return localDataSource.getAllExamples();
  }

  @override
  List<OptimizationExample> getExamplesByType(OptimizationType type) {
    return localDataSource.getExamplesByType(type);
  }

  @override
  OptimizationExample? getExampleById(String id) {
    return localDataSource.getExampleById(id);
  }

  @override
  void recordMetrics(PerformanceMetrics metrics) {
    _metricsCache.add(metrics);
  }

  @override
  List<PerformanceMetrics> getMetrics(String exampleId) {
    return _metricsCache
        .where((metrics) => metrics.exampleId == exampleId)
        .toList();
  }
}
