import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'data/datasources/optimization_local_datasource.dart';
import 'data/repositories/optimization_repository_impl.dart';
import 'domain/usecases/get_optimization_examples.dart';
import 'presentation/providers/optimization_provider.dart';
import 'presentation/pages/home_page.dart';

/// Main entry point for the Flutter Memory and Battery Optimization Template
/// 
/// This app demonstrates various optimization techniques using clean architecture:
/// - Domain Layer: Business logic and entities
/// - Data Layer: Data sources and repository implementations
/// - Presentation Layer: UI and state management
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up dependency injection using Provider
    // This follows clean architecture by injecting dependencies from outer to inner layers
    return MultiProvider(
      providers: [
        // Data layer
        Provider<OptimizationLocalDataSource>(
          create: (_) => OptimizationLocalDataSource(),
        ),
        
        // Repository implementation
        ProxyProvider<OptimizationLocalDataSource, OptimizationRepositoryImpl>(
          update: (_, dataSource, __) => OptimizationRepositoryImpl(
            localDataSource: dataSource,
          ),
        ),
        
        // Use cases
        ProxyProvider<OptimizationRepositoryImpl, GetOptimizationExamples>(
          update: (_, repository, __) => GetOptimizationExamples(repository),
        ),
        
        // Presentation layer providers
        ChangeNotifierProxyProvider<GetOptimizationExamples, OptimizationProvider>(
          create: (_) => OptimizationProvider(
            getOptimizationExamples: GetOptimizationExamples(
              OptimizationRepositoryImpl(
                localDataSource: OptimizationLocalDataSource(),
              ),
            ),
          ),
          update: (_, useCase, previous) =>
              previous ?? OptimizationProvider(getOptimizationExamples: useCase),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
