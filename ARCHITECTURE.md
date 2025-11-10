# Clean Architecture in Flutter Memory and Battery Optimization Template

This document explains the clean architecture implementation used in this project.

## Table of Contents
- [Overview](#overview)
- [Layer Structure](#layer-structure)
- [Dependency Flow](#dependency-flow)
- [Implementation Details](#implementation-details)
- [Benefits](#benefits)

## Overview

Clean Architecture is a software design philosophy that separates concerns into distinct layers, each with a specific responsibility. The core principle is the **Dependency Rule**: source code dependencies can only point inward, toward higher-level policies.

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, State Management)        │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│           Data Layer                    │
│  (Repositories, Data Sources, Models)   │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)    │
│         (Pure Business Logic)           │
└─────────────────────────────────────────┘
```

## Layer Structure

### 1. Domain Layer (Core Business Logic)

**Location**: `lib/domain/`

**Purpose**: Contains the business logic and is independent of any framework or external agency.

**Components**:

#### Entities (`domain/entities/`)
Pure Dart classes representing business objects. They contain business logic and are independent of any framework.

```dart
// optimization_example.dart
class OptimizationExample extends Equatable {
  final String id;
  final String title;
  final String description;
  final OptimizationType type;
  
  // Business logic can be added here
  bool get isMemoryOptimization => type == OptimizationType.memory;
}
```

**Rules**:
- No dependencies on Flutter or any external packages
- Immutable where possible (use `final` fields)
- Use value equality (Equatable)
- Pure business logic only

#### Repository Interfaces (`domain/repositories/`)
Contracts that define how data should be accessed, but not how it's implemented.

```dart
// optimization_repository.dart
abstract class OptimizationRepository {
  List<OptimizationExample> getAllExamples();
  OptimizationExample? getExampleById(String id);
  // ...
}
```

**Rules**:
- Abstract classes only
- Define contracts, not implementations
- Return domain entities, not data models

#### Use Cases (`domain/usecases/`)
Single-responsibility classes that orchestrate data flow and execute business logic.

```dart
// get_optimization_examples.dart
class GetOptimizationExamples {
  final OptimizationRepository repository;
  
  GetOptimizationExamples(this.repository);
  
  List<OptimizationExample> execute() {
    return repository.getAllExamples();
  }
}
```

**Rules**:
- One use case per business operation
- Depend on repository interfaces, not implementations
- Contain business logic, not technical details

### 2. Data Layer (Data Operations)

**Location**: `lib/data/`

**Purpose**: Implements data operations and communicates with external data sources.

**Components**:

#### Data Sources (`data/datasources/`)
Concrete implementations that fetch data from specific sources (API, database, local storage).

```dart
// optimization_local_datasource.dart
class OptimizationLocalDataSource {
  List<OptimizationExampleModel> getAllExamples() {
    // Returns hardcoded data, but could fetch from:
    // - SharedPreferences
    // - SQLite database
    // - JSON files
    return [...];
  }
}
```

**Rules**:
- Concrete implementations
- Handle technical details (HTTP, database queries, file I/O)
- Return data models, not domain entities
- Can throw exceptions for error handling

#### Models (`data/models/`)
Data Transfer Objects (DTOs) that extend domain entities and add serialization capabilities.

```dart
// optimization_example_model.dart
class OptimizationExampleModel extends OptimizationExample {
  const OptimizationExampleModel({...}) : super(...);
  
  // Serialization methods
  factory OptimizationExampleModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  
  // Conversion methods
  factory OptimizationExampleModel.fromEntity(OptimizationExample entity) {...}
}
```

**Rules**:
- Extend domain entities
- Add JSON serialization/deserialization
- Handle data transformation
- Can be framework-dependent

#### Repository Implementations (`data/repositories/`)
Concrete implementations of repository interfaces from the domain layer.

```dart
// optimization_repository_impl.dart
class OptimizationRepositoryImpl implements OptimizationRepository {
  final OptimizationLocalDataSource localDataSource;
  
  OptimizationRepositoryImpl({required this.localDataSource});
  
  @override
  List<OptimizationExample> getAllExamples() {
    return localDataSource.getAllExamples();
  }
}
```

**Rules**:
- Implement domain repository interfaces
- Coordinate between data sources
- Convert models to entities before returning
- Handle caching, error handling, data synchronization

### 3. Presentation Layer (UI)

**Location**: `lib/presentation/`

**Purpose**: Handles user interface and user interactions.

**Components**:

#### Providers (`presentation/providers/`)
State management using Provider pattern. Manages UI state and communicates with use cases.

```dart
// optimization_provider.dart
class OptimizationProvider extends ChangeNotifier {
  final GetOptimizationExamples getOptimizationExamples;
  
  List<OptimizationExample> _allExamples = [];
  bool _isLoading = false;
  
  void loadExamples() {
    _isLoading = true;
    notifyListeners();
    
    _allExamples = getOptimizationExamples.execute();
    
    _isLoading = false;
    notifyListeners();
  }
}
```

**Rules**:
- Extend ChangeNotifier for reactive state
- Depend on use cases, not repositories
- Manage presentation logic only
- Notify listeners on state changes

#### Pages (`presentation/pages/`)
Screen-level widgets that compose the UI.

```dart
// home_page.dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OptimizationProvider>(
      builder: (context, provider, child) {
        return Scaffold(...);
      },
    );
  }
}
```

**Rules**:
- Stateless or Stateful widgets
- Use Consumer/Selector to access providers
- Compose UI from smaller widgets
- Handle navigation

#### Widgets (`presentation/widgets/`)
Reusable UI components.

```dart
// example_card.dart
class ExampleCard extends StatelessWidget {
  final OptimizationExample example;
  final VoidCallback onTap;
  
  const ExampleCard({required this.example, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return Card(...);
  }
}
```

**Rules**:
- Reusable and composable
- Use const constructors when possible
- Single responsibility
- Accept data as parameters

### 4. Core Layer (Shared Utilities)

**Location**: `lib/core/`

**Purpose**: Contains shared utilities, constants, and helpers used across layers.

**Components**:

#### Constants (`core/constants/`)
App-wide constants.

```dart
// app_constants.dart
class AppConstants {
  static const String appTitle = 'Flutter Memory & Battery';
  static const int largeListItemCount = 10000;
}
```

#### Utils (`core/utils/`)
Helper functions and utilities.

```dart
// performance_utils.dart
class PerformanceUtils {
  static Timer? debounce(Duration duration, void Function() callback) {...}
  static String formatBytes(int bytes) {...}
}
```

## Dependency Flow

The dependency flow follows the **Dependency Inversion Principle**:

```
main.dart
    ↓
Providers (Presentation Layer)
    ↓
Use Cases (Domain Layer) ← Interface
    ↓
Repository Interface (Domain Layer)
    ↑ implements
Repository Implementation (Data Layer)
    ↓
Data Sources (Data Layer)
```

### Dependency Injection

Dependencies are injected at app startup in `main.dart`:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Data layer
        Provider<OptimizationLocalDataSource>(
          create: (_) => OptimizationLocalDataSource(),
        ),
        
        // Repository
        ProxyProvider<OptimizationLocalDataSource, OptimizationRepositoryImpl>(
          update: (_, dataSource, __) => OptimizationRepositoryImpl(
            localDataSource: dataSource,
          ),
        ),
        
        // Use cases
        ProxyProvider<OptimizationRepositoryImpl, GetOptimizationExamples>(
          update: (_, repository, __) => GetOptimizationExamples(repository),
        ),
        
        // Providers
        ChangeNotifierProxyProvider<GetOptimizationExamples, OptimizationProvider>(
          create: (_) => OptimizationProvider(...),
          update: (_, useCase, previous) => previous ?? OptimizationProvider(...),
        ),
      ],
      child: MaterialApp(...),
    ),
  );
}
```

## Implementation Details

### Adding a New Feature

To add a new feature (e.g., a new optimization example):

1. **Domain Layer**:
   - Create/update entities if needed
   - Define repository contract if needed
   - Create use case

2. **Data Layer**:
   - Add data to data source
   - Create model if needed
   - Update repository implementation

3. **Presentation Layer**:
   - Update provider if needed
   - Create page/widget
   - Wire up navigation

### Example Flow: Loading Examples

```
User opens app
    ↓
HomePage widget rendered
    ↓
Consumer listens to OptimizationProvider
    ↓
Provider.loadExamples() called
    ↓
GetOptimizationExamples.execute() called
    ↓
OptimizationRepository.getAllExamples() called
    ↓
OptimizationRepositoryImpl.getAllExamples() called
    ↓
OptimizationLocalDataSource.getAllExamples() called
    ↓
Data returned up through layers
    ↓
Provider notifies listeners
    ↓
UI rebuilds with data
```

## Benefits

### 1. Testability
Each layer can be tested independently:
- Domain: Pure unit tests, no mocking needed
- Data: Mock data sources easily
- Presentation: Mock use cases, test UI logic

### 2. Maintainability
- Changes in one layer don't affect others
- Clear separation of concerns
- Easy to find and fix issues

### 3. Scalability
- Add features without modifying existing code
- Multiple developers can work independently
- Clear structure for new team members

### 4. Flexibility
- Swap data sources without changing business logic
- Change UI framework without affecting domain
- Easily add new features

### 5. Reusability
- Domain logic can be shared across platforms
- Use cases can be reused in different contexts
- Widgets are composable and reusable

## Common Patterns

### Repository Pattern
Abstracts data sources and provides a clean API for data access.

### Use Case Pattern (Interactor)
Encapsulates business logic in single-responsibility classes.

### Dependency Injection
Provides dependencies from outer layers to inner layers.

### Observer Pattern
Providers notify listeners of state changes.

## Best Practices

1. **Keep domain layer pure**: No Flutter imports in domain layer
2. **Use interfaces**: Program to interfaces, not implementations
3. **Single responsibility**: Each class should have one reason to change
4. **Dependency inversion**: Depend on abstractions, not concretions
5. **Immutability**: Use `final` and `const` where possible
6. **Error handling**: Use proper error handling at each layer
7. **Documentation**: Document intent, not implementation

## References

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

---

This architecture ensures the app is:
- ✅ Testable
- ✅ Maintainable
- ✅ Scalable
- ✅ Flexible
- ✅ Production-ready
