import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/optimization_example.dart';
import '../providers/optimization_provider.dart';
import '../widgets/example_card.dart';
import 'examples/const_widgets_example.dart';
import 'examples/listview_example.dart';
import 'examples/image_optimization_example.dart';
import 'examples/resource_disposal_example.dart';
import 'examples/rebuild_optimization_example.dart';
import 'examples/debouncing_example.dart';
import 'examples/background_task_example.dart';
import 'examples/network_optimization_example.dart';

/// Home page displaying all optimization examples
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
      ),
      body: Consumer<OptimizationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome! 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore various memory and battery optimization techniques with side-by-side comparisons.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Memory optimization section
              _buildSectionHeader(context, 'Memory Optimization', Icons.memory, Colors.blue),
              ...provider.memoryExamples.map((example) => ExampleCard(
                    example: example,
                    onTap: () => _navigateToExample(context, example),
                  )),
              
              const SizedBox(height: 24),
              
              // Battery optimization section
              _buildSectionHeader(
                context,
                'Battery Optimization',
                Icons.battery_charging_full,
                Colors.green,
              ),
              ...provider.batteryExamples.map((example) => ExampleCard(
                    example: example,
                    onTap: () => _navigateToExample(context, example),
                  )),
              
              const SizedBox(height: 32),
              
              // Info section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.blue,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'About This Template',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Each example demonstrates a specific optimization technique with a side-by-side comparison. '
                          'The left side shows the optimized implementation, while the right side shows the non-optimized version. '
                          'This app follows clean architecture principles with separation of concerns across domain, data, and presentation layers.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  void _navigateToExample(BuildContext context, OptimizationExample example) {
    Widget? page;
    
    switch (example.id) {
      case AppConstants.constWidgetsExample:
        page = const ConstWidgetsExample();
        break;
      case AppConstants.listViewExample:
        page = const ListViewExample();
        break;
      case AppConstants.imageOptimizationExample:
        page = const ImageOptimizationExample();
        break;
      case AppConstants.resourceDisposalExample:
        page = const ResourceDisposalExample();
        break;
      case AppConstants.rebuildOptimizationExample:
        page = const RebuildOptimizationExample();
        break;
      case AppConstants.debouncingExample:
        page = const DebouncingExample();
        break;
      case AppConstants.backgroundTaskExample:
        page = const BackgroundTaskExample();
        break;
      case AppConstants.networkOptimizationExample:
        page = const NetworkOptimizationExample();
        break;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }
}
