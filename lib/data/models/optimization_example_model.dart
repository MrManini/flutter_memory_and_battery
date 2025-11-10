import '../../domain/entities/optimization_example.dart';

/// Data model for OptimizationExample
/// This extends the domain entity and adds data-layer specific functionality
class OptimizationExampleModel extends OptimizationExample {
  const OptimizationExampleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    super.routeName,
  });

  /// Creates a model from JSON (for future API integration)
  factory OptimizationExampleModel.fromJson(Map<String, dynamic> json) {
    return OptimizationExampleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: OptimizationType.values.firstWhere(
        (e) => e.toString() == 'OptimizationType.${json['type']}',
      ),
      routeName: json['routeName'] as String?,
    );
  }

  /// Converts the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'routeName': routeName,
    };
  }

  /// Creates a model from a domain entity
  factory OptimizationExampleModel.fromEntity(OptimizationExample entity) {
    return OptimizationExampleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      type: entity.type,
      routeName: entity.routeName,
    );
  }
}
