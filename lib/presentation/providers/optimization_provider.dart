import 'package:flutter/foundation.dart';
import '../../domain/entities/optimization_example.dart';
import '../../domain/usecases/get_optimization_examples.dart';

/// Provider for optimization examples
/// This manages the state for the presentation layer
class OptimizationProvider extends ChangeNotifier {
  final GetOptimizationExamples getOptimizationExamples;

  List<OptimizationExample> _allExamples = [];
  List<OptimizationExample> _memoryExamples = [];
  List<OptimizationExample> _batteryExamples = [];
  bool _isLoading = false;

  OptimizationProvider({required this.getOptimizationExamples}) {
    loadExamples();
  }

  List<OptimizationExample> get allExamples => _allExamples;
  List<OptimizationExample> get memoryExamples => _memoryExamples;
  List<OptimizationExample> get batteryExamples => _batteryExamples;
  bool get isLoading => _isLoading;

  /// Loads all optimization examples
  void loadExamples() {
    _isLoading = true;
    notifyListeners();

    _allExamples = getOptimizationExamples.execute();
    _memoryExamples = getOptimizationExamples.executeByType(OptimizationType.memory);
    _batteryExamples = getOptimizationExamples.executeByType(OptimizationType.battery);

    _isLoading = false;
    notifyListeners();
  }

  /// Gets an example by ID
  OptimizationExample? getExampleById(String id) {
    try {
      return _allExamples.firstWhere((example) => example.id == id);
    } catch (e) {
      return null;
    }
  }
}
