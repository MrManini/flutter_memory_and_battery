import '../../core/constants/app_constants.dart';
import '../../domain/entities/optimization_example.dart';
import '../models/optimization_example_model.dart';

/// Local data source for optimization examples
/// In a real app, this might use shared preferences or a local database
class OptimizationLocalDataSource {
  /// Gets all optimization examples from local storage
  /// Currently returns hardcoded examples, but could be expanded to use actual storage
  List<OptimizationExampleModel> getAllExamples() {
    return [
      // Memory Optimization Examples
      const OptimizationExampleModel(
        id: AppConstants.constWidgetsExample,
        title: 'Const Widgets',
        description:
            'Compare const vs non-const widget constructors. Const widgets are instantiated once and reused, reducing memory allocation and improving rebuild performance.',
        type: OptimizationType.memory,
      ),
      const OptimizationExampleModel(
        id: AppConstants.listViewExample,
        title: 'ListView Optimization',
        description:
            'Compare ListView vs ListView.builder for large lists. ListView.builder only creates widgets that are visible on screen, dramatically reducing memory usage.',
        type: OptimizationType.memory,
      ),
      const OptimizationExampleModel(
        id: AppConstants.imageOptimizationExample,
        title: 'Image Optimization',
        description:
            'Compare loading full-resolution images vs optimized images with cacheWidth/cacheHeight. Proper image sizing can reduce memory usage by 90%+.',
        type: OptimizationType.memory,
      ),
      const OptimizationExampleModel(
        id: AppConstants.resourceDisposalExample,
        title: 'Resource Disposal',
        description:
            'Demonstrate proper disposal of controllers and streams. Failure to dispose resources causes memory leaks over time.',
        type: OptimizationType.memory,
      ),
      
      // Battery Optimization Examples
      const OptimizationExampleModel(
        id: AppConstants.rebuildOptimizationExample,
        title: 'Rebuild Optimization',
        description:
            'Compare unnecessary rebuilds vs optimized widget trees with const and RepaintBoundary. Each rebuild consumes CPU and battery.',
        type: OptimizationType.battery,
      ),
      const OptimizationExampleModel(
        id: AppConstants.debouncingExample,
        title: 'Debouncing',
        description:
            'Compare immediate execution vs debounced operations for search and API calls. Debouncing reduces unnecessary work and network requests.',
        type: OptimizationType.battery,
      ),
      const OptimizationExampleModel(
        id: AppConstants.backgroundTaskExample,
        title: 'Background Processing',
        description:
            'Compare UI thread blocking vs compute isolates for heavy tasks. Isolates prevent UI jank and distribute CPU load.',
        type: OptimizationType.battery,
      ),
      const OptimizationExampleModel(
        id: AppConstants.networkOptimizationExample,
        title: 'Network Optimization',
        description:
            'Compare frequent network calls vs cached/batched requests. Network radios are one of the biggest battery drains.',
        type: OptimizationType.battery,
      ),
    ];
  }

  /// Gets examples filtered by type
  List<OptimizationExampleModel> getExamplesByType(OptimizationType type) {
    return getAllExamples().where((example) => example.type == type).toList();
  }

  /// Gets a specific example by ID
  OptimizationExampleModel? getExampleById(String id) {
    try {
      return getAllExamples().firstWhere((example) => example.id == id);
    } catch (e) {
      return null;
    }
  }
}
