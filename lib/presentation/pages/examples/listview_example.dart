import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_logger.dart';

/// Example demonstrating ListView vs ListView.builder with horizontal swipe interface
///
/// KEY OPTIMIZATION:
/// ListView.builder only creates widgets for items that are visible on screen,
/// dramatically reducing memory usage for large lists.
class ListViewExample extends StatefulWidget {
  const ListViewExample({super.key});

  @override
  State<ListViewExample> createState() => _ListViewExampleState();
}

class _ListViewExampleState extends State<ListViewExample> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    AppLogger.logOptimization(
      'ListView Comparison',
      'Initialized with PageView for better UX',
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Optimization'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _currentPage == 0
                            ? Colors.blueGrey
                            : Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '❌ Non-Optimized\n(Regular ListView)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _currentPage == 1
                            ? Colors.blueGrey
                            : Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '✅ Optimized\n(ListView.builder)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Instruction banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: const Text(
              'Tap tabs above or swipe left/right to compare, and watch terminal for logging!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // PageView for swiping between examples
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                AppLogger.logBuildMethod('PageView', {'currentPage': index});
              },
              children: const [_NonOptimizedListView(), _OptimizedListView()],
            ),
          ),
        ],
      ),
    );
  }
}

/// OPTIMIZED: Uses ListView.builder for lazy loading
class _OptimizedListView extends StatelessWidget {
  const _OptimizedListView();

  @override
  Widget build(BuildContext context) {
    AppLogger.logOptimization(
      'ListView.builder',
      'Only renders visible items - efficient memory usage',
    );

    return Container(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'ListView.builder',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '✅ Only renders visible items\n✅ Lazy loading for performance\n✅ Minimal memory footprint',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          // List content
          Expanded(
            child: ListView.builder(
              // Only creates widgets for visible items
              itemCount: AppConstants.largeListItemCount,
              itemBuilder: (context, index) {
                // Log only occasionally to avoid spam
                if (index % 100 == 0) {
                  AppLogger.logMemoryEvent(
                    'ListView.builder',
                    'Lazy-loaded item $index',
                  );
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        '${(index + 1) ~/ 1000}K',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    title: Text('Optimized Item $index'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rendered on-demand • Memory efficient'),
                        SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: 1.0, // Always full to show efficiency
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '#${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Lazy',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green,
            child: Text(
              '🎯 ${AppConstants.largeListItemCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} items available with minimal memory usage!',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// NON-OPTIMIZED: Creates all items at once
class _NonOptimizedListView extends StatelessWidget {
  const _NonOptimizedListView();

  @override
  Widget build(BuildContext context) {
    // Using a much larger count to show performance degradation
    const itemCount = 2500; // Enough to show sluggishness on most devices

    AppLogger.logPerformanceIssue(
      'Regular ListView',
      'Creating ALL $itemCount widgets at once - memory intensive!',
    );

    return Container(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.redAccent[700],
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'ListView (Regular)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '❌ Creates ALL widgets upfront\n❌ High memory usage\n❌ Slower initial load',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          // List content
          Expanded(
            child: ListView(
              // Creates ALL widgets immediately - memory intensive!
              children: List.generate(itemCount, (index) {
                // Log every 50 items to show the mass creation
                if (index % 50 == 0) {
                  AppLogger.logMemoryEvent(
                    'Regular ListView',
                    'Pre-created widget $index (wasteful!)',
                  );
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  elevation: 2,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.memory,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    title: Text('Non-Optimized Item $index'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Created upfront • Wastes memory'),
                        LinearProgressIndicator(
                          value:
                              ((index * 2.5 + 15) % 50) /
                              50, // Progress based on memory usage
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '#${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${(index * 2.5 + 15).toStringAsFixed(1)}KB',
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'This widget was pre-created even though you might never see it! '
                              'It contains complex nested widgets that consume memory unnecessarily.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Chip(
                                  label: Text(
                                    'Memory: ${(index * 2.5 + 15).toInt()}KB',
                                  ),
                                  backgroundColor: Colors.redAccent[700],
                                ),
                                Chip(
                                  label: Text('ID: $index'),
                                  backgroundColor: Colors.grey[700],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.redAccent[700],
            child: Text(
              '⚠️ Only $itemCount items (limited to prevent memory crash!)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
