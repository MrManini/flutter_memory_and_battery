import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/comparison_view.dart';

/// Example demonstrating network request optimization
/// 
/// KEY OPTIMIZATION:
/// Batch network requests, implement caching, and avoid frequent calls
/// to reduce radio usage and battery drain.
class NetworkOptimizationExample extends StatelessWidget {
  const NetworkOptimizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Network Optimization',
      optimizedWidget: const _OptimizedNetworkExample(),
      nonOptimizedWidget: const _NonOptimizedNetworkExample(),
    );
  }
}

/// OPTIMIZED: Batches and caches network requests
class _OptimizedNetworkExample extends StatefulWidget {
  const _OptimizedNetworkExample();

  @override
  State<_OptimizedNetworkExample> createState() =>
      _OptimizedNetworkExampleState();
}

class _OptimizedNetworkExampleState extends State<_OptimizedNetworkExample> {
  final Map<String, dynamic> _cache = {};
  int _requestCount = 0;
  int _cacheHits = 0;
  List<String> _log = [];

  Future<void> _fetchData(String id) async {
    // Check cache first
    if (_cache.containsKey(id)) {
      setState(() {
        _cacheHits++;
        _log.insert(0, 'Cache hit for: $id');
        if (_log.length > 5) _log.removeLast();
      });
      return;
    }

    // Simulate network request
    setState(() {
      _requestCount++;
      _log.insert(0, 'Fetching: $id');
      if (_log.length > 5) _log.removeLast();
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // Store in cache
    setState(() {
      _cache[id] = {'data': 'Data for $id', 'timestamp': DateTime.now()};
      _log.insert(0, 'Cached: $id');
      if (_log.length > 5) _log.removeLast();
    });
  }

  Future<void> _batchFetch(List<String> ids) async {
    setState(() {
      _log.insert(0, 'Batch request for ${ids.length} items');
      if (_log.length > 5) _log.removeLast();
    });

    // Single network request for multiple items
    _requestCount++;
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      for (var id in ids) {
        _cache[id] = {'data': 'Data for $id', 'timestamp': DateTime.now()};
      }
      _log.insert(0, 'Batch cached ${ids.length} items');
      if (_log.length > 5) _log.removeLast();
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
                      'Optimized Network',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('✓ Caching enabled', style: TextStyle(color: Colors.white)),
                Text('✓ Batch requests', style: TextStyle(color: Colors.white)),
                Text('✓ Reduced radio usage', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetric('Requests', _requestCount, Colors.green),
                    _buildMetric('Cache Hits', _cacheHits, Colors.blue),
                    _buildMetric('Cached', _cache.length, Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _fetchData('item1'),
                      child: const Text('Fetch Item 1'),
                    ),
                    ElevatedButton(
                      onPressed: () => _fetchData('item2'),
                      child: const Text('Fetch Item 2'),
                    ),
                    ElevatedButton(
                      onPressed: () => _batchFetch(['item3', 'item4', 'item5']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Batch Fetch 3 Items'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity Log',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (_log.isEmpty)
                  const Text('No activity yet', style: TextStyle(color: Colors.grey))
                else
                  ..._log.map((log) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $log', style: const TextStyle(fontSize: 12)),
                      )),
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
                Text('• Reduced radio usage'),
                Text('• Better battery life'),
                Text('• Faster response times'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Makes individual requests without caching
class _NonOptimizedNetworkExample extends StatefulWidget {
  const _NonOptimizedNetworkExample();

  @override
  State<_NonOptimizedNetworkExample> createState() =>
      _NonOptimizedNetworkExampleState();
}

class _NonOptimizedNetworkExampleState
    extends State<_NonOptimizedNetworkExample> {
  int _requestCount = 0;
  List<String> _log = [];

  Future<void> _fetchData(String id) async {
    // No caching - always makes a network request!
    setState(() {
      _requestCount++;
      _log.insert(0, 'Network request for: $id');
      if (_log.length > 5) _log.removeLast();
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _log.insert(0, 'Received: $id');
      if (_log.length > 5) _log.removeLast();
    });
  }

  Future<void> _fetchMultiple(List<String> ids) async {
    // Makes individual requests instead of batching
    setState(() {
      _log.insert(0, 'Fetching ${ids.length} items individually...');
      if (_log.length > 5) _log.removeLast();
    });

    for (var id in ids) {
      _requestCount++;
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _log.insert(0, 'Individual request for: $id');
        if (_log.length > 5) _log.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          color: Colors.orange,
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
                      'Non-Optimized Network',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('✗ No caching', style: TextStyle(color: Colors.white)),
                Text('✗ Individual requests', style: TextStyle(color: Colors.white)),
                Text('✗ High battery drain', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetric('Requests', _requestCount, Colors.orange),
                    _buildMetric('Cache Hits', 0, Colors.grey),
                    _buildMetric('Cached', 0, Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _fetchData('item1'),
                      child: const Text('Fetch Item 1'),
                    ),
                    ElevatedButton(
                      onPressed: () => _fetchData('item2'),
                      child: const Text('Fetch Item 2'),
                    ),
                    ElevatedButton(
                      onPressed: () => _fetchMultiple(['item3', 'item4', 'item5']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Fetch 3 Items'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity Log',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (_log.isEmpty)
                  const Text('No activity yet', style: TextStyle(color: Colors.grey))
                else
                  ..._log.map((log) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $log', style: const TextStyle(fontSize: 12)),
                      )),
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
                Text('• High radio usage'),
                Text('• Battery drain'),
                Text('• Wasted bandwidth'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
