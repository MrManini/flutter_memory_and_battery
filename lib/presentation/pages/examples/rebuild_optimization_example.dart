import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating advanced rebuild optimization techniques
///
/// KEY OPTIMIZATIONS:
/// 1. RepaintBoundary - Isolates repaints to prevent unnecessary painting
/// 2. AutomaticKeepAliveClientMixin - Preserves widget state in lists
/// 3. Keys - Maintains widget identity during rebuilds
/// 4. Local state management - Keeps state close to where it's used
///
/// This is different from const widgets - focuses on WHEN and HOW widgets rebuild
class RebuildOptimizationExample extends StatelessWidget {
  const RebuildOptimizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Rebuild Optimization',
      optimizedWidget: const _OptimizedRebuildExample(),
      nonOptimizedWidget: const _NonOptimizedRebuildExample(),
    );
  }
}

/// OPTIMIZED: Uses RepaintBoundary, Keys, and KeepAlive to minimize rebuilds
class _OptimizedRebuildExample extends StatefulWidget {
  const _OptimizedRebuildExample({super.key});

  @override
  State<_OptimizedRebuildExample> createState() =>
      _OptimizedRebuildExampleState();
}

class _OptimizedRebuildExampleState extends State<_OptimizedRebuildExample> {
  int _globalCounter = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    AppLogger.debug('🔄 OPTIMIZED: Parent rebuild - counter: $_globalCounter');

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
                Text(
                  'Advanced Rebuild Optimization ✓',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '✓ RepaintBoundary isolation',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ Proper key usage',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ KeepAlive for expensive widgets',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✓ Local state management',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Global counter that triggers rebuilds
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Global Counter (triggers parent rebuilds)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_globalCounter',
                  style: const TextStyle(fontSize: 32, color: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _globalCounter++);
                    AppLogger.info(
                      '✅ OPTIMIZED: Global counter incremented to $_globalCounter',
                    );
                  },
                  child: const Text('Increment Global'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // RepaintBoundary isolates this expensive widget
        const RepaintBoundary(
          child: _ExpensiveWidget(key: ValueKey('expensive_optimized')),
        ),
        const SizedBox(height: 16),

        // List with proper keys and keepAlive
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Optimized List (with keys & keepAlive)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    return _KeepAliveColorCard(
                      key: ValueKey('color_$index'), // Proper key usage
                      color: _colors[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: No isolation, poor key usage, no state preservation
class _NonOptimizedRebuildExample extends StatefulWidget {
  const _NonOptimizedRebuildExample({super.key});

  @override
  State<_NonOptimizedRebuildExample> createState() =>
      _NonOptimizedRebuildExampleState();
}

class _NonOptimizedRebuildExampleState
    extends State<_NonOptimizedRebuildExample> {
  int _globalCounter = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    AppLogger.error(
      '🔄 NON-OPTIMIZED: Parent rebuild causes EVERYTHING to rebuild - counter: $_globalCounter',
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Poor Rebuild Optimization ✗',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '✗ No RepaintBoundary isolation',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Missing/poor key usage',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ No KeepAlive - expensive widgets rebuild',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '✗ Everything rebuilds together',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Global counter that triggers rebuilds
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Global Counter (triggers ALL rebuilds)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_globalCounter',
                  style: TextStyle(fontSize: 32, color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _globalCounter++);
                    AppLogger.error(
                      '❌ NON-OPTIMIZED: Global counter incremented - EVERYTHING rebuilds!',
                    );
                  },
                  child: Text('Increment Global'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // NO RepaintBoundary - expensive widget rebuilds with parent
        _NonOptimizedExpensiveWidget(), // No key - bad for performance
        SizedBox(height: 16),

        // List without proper keys or keepAlive
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Non-Optimized List (no keys, no keepAlive)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    return _SimpleColorCard(
                      // No key, no keepAlive
                      color: _colors[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Expensive widget that simulates heavy computation - OPTIMIZED VERSION
class _ExpensiveWidget extends StatefulWidget {
  const _ExpensiveWidget({super.key});

  @override
  State<_ExpensiveWidget> createState() => _ExpensiveWidgetState();
}

class _ExpensiveWidgetState extends State<_ExpensiveWidget> {
  int _computationCount = 0;
  int _internalCounter = 0;

  @override
  void initState() {
    super.initState();
    // Only increment computation count on actual widget creation
    _computationCount = 1;
    AppLogger.info('✅ EXPENSIVE: Widget created once (optimized)');
  }

  @override
  Widget build(BuildContext context) {
    // This should NOT increment on parent rebuilds if properly optimized
    AppLogger.debug('🔄 EXPENSIVE: build() called $_computationCount times');

    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.psychology, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            const Text(
              'Expensive Widget',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Created $_computationCount times',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Internal count: $_internalCounter',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() => _internalCounter++);
                AppLogger.info('✅ EXPENSIVE: Internal state updated');
              },
              child: const Text('Internal +1'),
            ),
            const SizedBox(height: 4),
            const Text(
              'Should NOT rebuild with parent!',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// NON-OPTIMIZED expensive widget that rebuilds with parent
class _NonOptimizedExpensiveWidget extends StatefulWidget {
  const _NonOptimizedExpensiveWidget({super.key});

  @override
  State<_NonOptimizedExpensiveWidget> createState() =>
      _NonOptimizedExpensiveWidgetState();
}

class _NonOptimizedExpensiveWidgetState
    extends State<_NonOptimizedExpensiveWidget> {
  int _computationCount = 0;
  int _internalCounter = 0;

  @override
  Widget build(BuildContext context) {
    // This WILL increment on every parent rebuild - BAD!
    _computationCount++;
    AppLogger.error(
      '❌ EXPENSIVE: Widget rebuilt $_computationCount times (BAD!)',
    );

    return Card(
      color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.warning, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            const Text(
              'Expensive Widget',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Rebuilt $_computationCount times',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Internal count: $_internalCounter',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() => _internalCounter++);
                AppLogger.error(
                  '❌ EXPENSIVE: Internal state updated (will be lost on parent rebuild!)',
                );
              },
              child: const Text('Internal +1'),
            ),
            const SizedBox(height: 4),
            const Text(
              'Rebuilds with parent - BAD!',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Optimized color card with KeepAlive
class _KeepAliveColorCard extends StatefulWidget {
  final Color color;
  final int index;

  const _KeepAliveColorCard({
    super.key,
    required this.color,
    required this.index,
  });

  @override
  State<_KeepAliveColorCard> createState() => _KeepAliveColorCardState();
}

class _KeepAliveColorCardState extends State<_KeepAliveColorCard>
    with AutomaticKeepAliveClientMixin {
  int _localCounter = 0;

  @override
  bool get wantKeepAlive => true; // Preserves state when scrolled away

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    AppLogger.info('✅ KEEP ALIVE: Color card ${widget.index} preserved state');

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Card ${widget.index}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Local count: $_localCounter',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() => _localCounter++);
              AppLogger.info(
                '✅ OPTIMIZED: Local state updated in card ${widget.index}',
              );
            },
            child: const Text('+1'),
          ),
          const SizedBox(height: 8),
          const Text(
            'State preserved!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Non-optimized color card without KeepAlive
class _SimpleColorCard extends StatefulWidget {
  final Color color;
  final int index;

  const _SimpleColorCard({required this.color, required this.index});

  @override
  State<_SimpleColorCard> createState() => _SimpleColorCardState();
}

class _SimpleColorCardState extends State<_SimpleColorCard> {
  int _localCounter = 0;

  @override
  Widget build(BuildContext context) {
    AppLogger.error(
      '❌ NO KEEP ALIVE: Color card ${widget.index} state lost on rebuild',
    );

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Card ${widget.index}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Local count: $_localCounter',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() => _localCounter++);
              AppLogger.error(
                '❌ NON-OPTIMIZED: Local state in card ${widget.index} (will be lost!)',
              );
            },
            child: const Text('+1'),
          ),
          const SizedBox(height: 8),
          const Text(
            'State will be lost!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
