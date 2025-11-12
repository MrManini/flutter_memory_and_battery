import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/performance_utils.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating debouncing for battery optimization
/// 
/// KEY OPTIMIZATION:
/// Debouncing delays the execution of expensive operations until the user
/// has stopped typing/interacting, reducing unnecessary work and battery drain.
class DebouncingExample extends StatelessWidget {
  const DebouncingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Debouncing Optimization',
      optimizedWidget: const _OptimizedDebouncingExample(),
      nonOptimizedWidget: const _NonOptimizedDebouncingExample(),
    );
  }
}

/// OPTIMIZED: Uses debouncing for search operations
class _OptimizedDebouncingExample extends StatefulWidget {
  const _OptimizedDebouncingExample();

  @override
  State<_OptimizedDebouncingExample> createState() =>
      _OptimizedDebouncingExampleState();
}

class _OptimizedDebouncingExampleState
    extends State<_OptimizedDebouncingExample> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: AppConstants.debounceMilliseconds),
  );
  int _searchCount = 0;
  String _lastSearch = '';

  @override
  void initState() {
    super.initState();
    AppLogger.info('✅ OPTIMIZED: Debouncer initialized with ${AppConstants.debounceMilliseconds}ms delay');
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    AppLogger.info('✅ OPTIMIZED: Debouncer disposed - search operations cancelled');
    super.dispose();
  }

  void _onSearchChanged(String query) {
    AppLogger.debug('🔤 OPTIMIZED: User typed: "$query" - debouncing...');
    _debouncer(() {
      // This only executes after user stops typing for 500ms
      setState(() {
        _searchCount++;
        _lastSearch = query;
      });
      // Simulate API call
      AppLogger.info('🔍 OPTIMIZED: Debounced search performed for: "$query" (Search #$_searchCount)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Debounced Search',
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
                  '✓ Waits for user to finish typing',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ Reduces API calls',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ Saves battery',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            helperText: 'Search executes after 500ms pause',
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search Count:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_searchCount',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_lastSearch.isNotEmpty)
                  Text('Last search: "$_lastSearch"'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Benefits:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Fewer network requests'),
                Text('• Less CPU usage'),
                Text('• Better battery life'),
                Text('• Improved user experience'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Try typing quickly - search only triggers after you pause',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Executes search on every keystroke
class _NonOptimizedDebouncingExample extends StatefulWidget {
  const _NonOptimizedDebouncingExample();

  @override
  State<_NonOptimizedDebouncingExample> createState() =>
      _NonOptimizedDebouncingExampleState();
}

class _NonOptimizedDebouncingExampleState
    extends State<_NonOptimizedDebouncingExample> {
  final TextEditingController _controller = TextEditingController();
  int _searchCount = 0;
  String _lastSearch = '';

  @override
  void initState() {
    super.initState();
    AppLogger.warning('⚠️ NON-OPTIMIZED: No debouncing - will search on every keystroke!');
  }

  @override
  void dispose() {
    _controller.dispose();
    AppLogger.warning('⚠️ NON-OPTIMIZED: Controller disposed but no debouncer to clean up');
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // PROBLEM: This executes on EVERY keystroke!
    AppLogger.debug('🔤 NON-OPTIMIZED: User typed: "$query" - searching immediately...');
    setState(() {
      _searchCount++;
      _lastSearch = query;
    });
    // Simulate API call on every keystroke - very inefficient!
    AppLogger.error('❌ NON-OPTIMIZED: Immediate search on keystroke for: "$query" (Search #$_searchCount)');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Immediate Search',
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
                  '✗ Searches on every keystroke',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Excessive API calls',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Drains battery',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            helperText: 'Search executes on EVERY keystroke!',
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search Count:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_searchCount',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_lastSearch.isNotEmpty)
                  Text('Last search: "$_lastSearch"'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problems:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Excessive network requests'),
                Text('• High CPU usage'),
                Text('• Battery drain'),
                Text('• Wasted bandwidth'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Watch the counter explode as you type!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
