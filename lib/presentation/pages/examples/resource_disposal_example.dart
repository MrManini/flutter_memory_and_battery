import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/utils/app_logger.dart';
import '../../widgets/comparison_view.dart';

/// Global resource manager to demonstrate persistent leaks
class GlobalResourceManager {
  static final List<Timer> _persistentTimers = [];
  static final List<StreamSubscription> _persistentSubscriptions = [];
  static final Map<String, String> _persistentData = {};
  static String _leakyTextInput = 'Leaked text - check global storage!';

  static void addTimer(Timer timer, String source) {
    _persistentTimers.add(timer);
    AppLogger.error(
      '🔥 LEAK: Timer added from $source (Total: ${_persistentTimers.length})',
    );
  }

  static void addSubscription(StreamSubscription subscription, String source) {
    _persistentSubscriptions.add(subscription);
    AppLogger.error(
      '🔥 LEAK: Subscription added from $source (Total: ${_persistentSubscriptions.length})',
    );
  }

  static void storeData(String key, String value, String source) {
    _persistentData[key] = value;
    AppLogger.error(
      '🔥 LEAK: Data stored from $source (Total entries: ${_persistentData.length})',
    );
  }

  static void cleanupTimers() {
    for (var timer in _persistentTimers) {
      timer.cancel();
    }
    final count = _persistentTimers.length;
    _persistentTimers.clear();
    AppLogger.info('✅ CLEANED: $count timers disposed');
  }

  static void cleanupSubscriptions() {
    for (var sub in _persistentSubscriptions) {
      sub.cancel();
    }
    final count = _persistentSubscriptions.length;
    _persistentSubscriptions.clear();
    AppLogger.info('✅ CLEANED: $count subscriptions disposed');
  }

  static void cleanupData() {
    final count = _persistentData.length;
    _persistentData.clear();
    AppLogger.info('✅ CLEANED: $count data entries disposed');
  }

  static void setLeakyText(String text) {
    _leakyTextInput = text;
    AppLogger.error('🔥 LEAK: Text persisted globally - "$text"');
  }

  static String getLeakyText() {
    return _leakyTextInput;
  }

  static void clearLeakyText() {
    _leakyTextInput = 'Leaked text - check global storage!';
    AppLogger.info('✅ CLEANED: Leaked text reset');
  }

  static Map<String, dynamic> getStats() {
    return {
      'timers': _persistentTimers.length,
      'subscriptions': _persistentSubscriptions.length,
      'dataEntries': _persistentData.length,
      'storedData': Map.from(_persistentData),
    };
  }
}

/// Example demonstrating proper resource disposal vs memory leaks
///
/// This example creates resources that persist globally to demonstrate
/// the difference between proper disposal and memory leaks
class ResourceDisposalExample extends StatefulWidget {
  const ResourceDisposalExample({super.key});

  @override
  State<ResourceDisposalExample> createState() =>
      _ResourceDisposalExampleState();
}

class _ResourceDisposalExampleState extends State<ResourceDisposalExample> {
  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Resource Disposal',
      optimizedWidget: const _OptimizedDisposalExample(),
      nonOptimizedWidget: const _NonOptimizedDisposalExample(),
      actionButtons: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.cleaning_services),
          tooltip: 'Cleanup Options',
          onSelected: (value) {
            switch (value) {
              case 'cleanup_all':
                GlobalResourceManager.cleanupTimers();
                GlobalResourceManager.cleanupSubscriptions();
                GlobalResourceManager.cleanupData();
                GlobalResourceManager.clearLeakyText();
                break;
              case 'show_stats':
                _showStats();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'cleanup_all',
              child: Row(
                children: [
                  Icon(Icons.cleaning_services, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Force Cleanup All'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'show_stats',
              child: Row(
                children: [
                  Icon(Icons.analytics, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Show Leak Stats'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showStats() {
    final stats = GlobalResourceManager.getStats();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Memory Leak Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leaked Timers: ${stats['timers']}'),
            Text('Leaked Subscriptions: ${stats['subscriptions']}'),
            Text('Leaked Data Entries: ${stats['dataEntries']}'),
            if ((stats['storedData'] as Map).isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Stored Data:'),
              ...(stats['storedData'] as Map).entries.map(
                (e) => Text('  ${e.key}: ${e.value}'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// OPTIMIZED: Properly disposes all resources including global ones
class _OptimizedDisposalExample extends StatefulWidget {
  const _OptimizedDisposalExample({super.key});

  @override
  State<_OptimizedDisposalExample> createState() =>
      _OptimizedDisposalExampleState();
}

class _OptimizedDisposalExampleState extends State<_OptimizedDisposalExample> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  Timer? _localTimer;
  StreamSubscription? _localSubscription;
  int _timerTicks = 0;
  final String _instanceId = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: 'Optimized text - will be cleaned',
    );
    _scrollController = ScrollController();

    // Create LOCAL timer that we'll properly dispose
    _localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timerTicks++);
      }
    });

    // Create LOCAL stream subscription
    _localSubscription = Stream.periodic(const Duration(seconds: 2), (i) => i)
        .listen((event) {
          if (mounted) {
            AppLogger.info('✅ OPTIMIZED: Local stream event $event');
          }
        });

    // Store some data that we'll clean up
    GlobalResourceManager.storeData(
      'opt_$_instanceId',
      _controller.text,
      'OptimizedExample',
    );

    AppLogger.info('✅ OPTIMIZED: Resources created properly');
  }

  @override
  void dispose() {
    // ✓ PROPERLY dispose all local resources
    _controller.dispose();
    _scrollController.dispose();
    _localTimer?.cancel();
    _localSubscription?.cancel();

    // ✓ PROPERLY clean up global resources we created
    GlobalResourceManager.cleanupData(); // Clean our stored data

    AppLogger.info('✅ OPTIMIZED: All resources properly disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = GlobalResourceManager.getStats();

    return ListView(
      controller: _scrollController,
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
                      'Proper Disposal ✓',
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
                  '✓ Controllers disposed\n✓ Timers cancelled\n✓ Subscriptions cleaned\n✓ Global data cleared',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Properly Managed Input',
            border: OutlineInputBorder(),
            helperText: 'This will be disposed when leaving screen',
          ),
          onChanged: (value) {
            // Update global storage to show it gets cleaned
            GlobalResourceManager.storeData(
              'opt_$_instanceId',
              value,
              'OptimizedExample',
            );
          },
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Local Timer (will be cancelled):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ticks: $_timerTicks',
                  style: const TextStyle(fontSize: 24, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  'Global Leaks - Timers: ${stats['timers']}, Subs: ${stats['subscriptions']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Card(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Benefits of Proper Disposal:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('• No memory leaks'),
                const Text('• Clean app lifecycle'),
                const Text('• Better performance'),
                const Text('• Prevents crashes'),
                const SizedBox(height: 8),
                Text(
                  'Current data entries: ${stats['dataEntries']}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Creates persistent global leaks that survive widget disposal
class _NonOptimizedDisposalExample extends StatefulWidget {
  const _NonOptimizedDisposalExample({super.key});

  @override
  State<_NonOptimizedDisposalExample> createState() =>
      _NonOptimizedDisposalExampleState();
}

class _NonOptimizedDisposalExampleState
    extends State<_NonOptimizedDisposalExample> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  Timer? _localTimer; // This won't be cleaned
  int _timerTicks = 0;
  final String _instanceId = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    // ✗ Use leaked text from global storage - this persists across widget recreations!
    _controller = TextEditingController(
      text: GlobalResourceManager.getLeakyText(), // Text will persist!
    );
    _scrollController = ScrollController();

    // Create LOCAL timer but don't dispose it - this creates a leak
    _localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timerTicks++);
      }
    });

    // ✗ Create GLOBAL timers that will leak
    final globalTimer1 = Timer.periodic(const Duration(seconds: 3), (timer) {
      AppLogger.error('🔥 LEAK: Global timer 1 still running!');
    });

    final globalTimer2 = Timer.periodic(const Duration(seconds: 5), (timer) {
      AppLogger.error('🔥 LEAK: Global timer 2 still running!');
    });

    GlobalResourceManager.addTimer(globalTimer1, 'NonOptimizedExample-Timer1');
    GlobalResourceManager.addTimer(globalTimer2, 'NonOptimizedExample-Timer2');

    // ✗ Create GLOBAL stream subscriptions that will leak
    final globalSub1 =
        Stream.periodic(const Duration(seconds: 4), (i) => 'leak-$i').listen((
          data,
        ) {
          AppLogger.error('🔥 LEAK: Global subscription 1 - $data');
        });

    final globalSub2 =
        Stream.periodic(
          const Duration(seconds: 7),
          (i) => 'persistent-$i',
        ).listen((data) {
          AppLogger.error('🔥 LEAK: Global subscription 2 - $data');
        });

    GlobalResourceManager.addSubscription(
      globalSub1,
      'NonOptimizedExample-Sub1',
    );
    GlobalResourceManager.addSubscription(
      globalSub2,
      'NonOptimizedExample-Sub2',
    );

    // ✗ Store data globally without cleanup
    GlobalResourceManager.storeData(
      'leak_$_instanceId',
      _controller.text,
      'NonOptimizedExample',
    );

    GlobalResourceManager.storeData(
      'persistent_data_$_instanceId',
      'This data will never be cleaned up!',
      'NonOptimizedExample',
    );

    AppLogger.error('🔥 LEAK: Created persistent resources that will leak!');
  }

  @override
  void dispose() {
    // ✗ NOT disposing local resources
    // ✗ NOT cleaning global resources
    // _controller.dispose(); // Commented out!
    // _scrollController.dispose(); // Commented out!
    // _localTimer?.cancel(); // Commented out - this creates the leak!

    AppLogger.error('🔥 LEAK: Resources NOT disposed - memory leak created!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = GlobalResourceManager.getStats();

    return ListView(
      controller: _scrollController,
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
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'No Disposal! ✗',
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
                  '✗ Controllers not disposed\n✗ Global timers running\n✗ Subscriptions active\n✗ Data accumulating',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Leaky Input (check global storage)',
            border: OutlineInputBorder(),
            helperText: 'This text will persist in global storage!',
          ),
          onChanged: (value) {
            // Store text globally without cleanup - memory leak!
            GlobalResourceManager.setLeakyText(value); // This persists!
            GlobalResourceManager.storeData(
              'leak_$_instanceId',
              value,
              'NonOptimizedExample',
            );
          },
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Local Timer (not cancelled):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ticks: $_timerTicks',
                  style: const TextStyle(fontSize: 24, color: Colors.red),
                ),
                Text(
                  'Timer active: ${_localTimer?.isActive ?? false}',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  'Global Leaks - Timers: ${stats['timers']}, Subs: ${stats['subscriptions']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Card(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Problems Created:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('• Memory leaks accumulating'),
                const Text('• Global timers keep running'),
                const Text('• Stream subscriptions active'),
                const Text('• Data never cleaned up'),
                const SizedBox(height: 8),
                Text(
                  'Total leaked data entries: ${stats['dataEntries']}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tip: Use the cleanup button to manually clean leaks!',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
