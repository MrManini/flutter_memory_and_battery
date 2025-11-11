import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating image caching vs non-caching with timing measurements
///
/// Demonstrates:
/// - First load: Both sides fetch normally
/// - Non-optimized: Always fetches from network (no caching)
/// - Optimized: Uses cache after first load
class ImageOptimizationExample extends StatefulWidget {
  const ImageOptimizationExample({super.key});

  @override
  State<ImageOptimizationExample> createState() =>
      _ImageOptimizationExampleState();
}

class _ImageOptimizationExampleState extends State<ImageOptimizationExample> {
  int reloadCount = 0;

  void _reload() {
    setState(() {
      reloadCount++;
    });
    AppLogger.info('🔄 Reload #$reloadCount initiated');
  }

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Image Optimization',
      optimizedWidget: _OptimizedImageExample(
        key: ValueKey('opt_$reloadCount'),
      ),
      nonOptimizedWidget: _NonOptimizedImageExample(
        key: ValueKey('non_$reloadCount'),
      ),
      actionButtons: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Reload Images',
          onPressed: _reload,
        ),
      ],
    );
  }
}

/// OPTIMIZED: Uses image caching - shows timing difference after first load
class _OptimizedImageExample extends StatefulWidget {
  const _OptimizedImageExample({super.key});

  @override
  State<_OptimizedImageExample> createState() => _OptimizedImageExampleState();
}

class _OptimizedImageExampleState extends State<_OptimizedImageExample> {
  int _loadTime = 0;
  bool _isLoading = false;
  DateTime? _startTime;

  // Hardcoded image URLs for consistent testing
  final String _imageUrl = 'https://picsum.photos/600/400?random=1';

  @override
  void initState() {
    super.initState();
    // Start timing immediately when widget is created
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Card(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optimized (Cached)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '✓ First load: fetches normally\n✓ Reload: uses cache (faster)',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Timer display
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isLoading ? 'Loading...' : 'Load time: ${_loadTime}ms',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Image with caching
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: _imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.error)),
                ),
                imageBuilder: (context, imageProvider) {
                  // Stop timer when image is successfully loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _stopTimer();
                  });
                  return Image(image: imageProvider, fit: BoxFit.cover);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _loadTime = 0;
      _startTime = DateTime.now();
    });

    AppLogger.info('🖼️ CACHED: Starting image load');
  }

  void _stopTimer() {
    if (!_isLoading || _startTime == null) return;

    final endTime = DateTime.now();
    final loadTime = endTime.difference(_startTime!).inMilliseconds;

    setState(() {
      _isLoading = false;
      _loadTime = loadTime;
    });

    AppLogger.info('🖼️ CACHED: Image loaded in ${loadTime}ms');
  }
}

/// NON-OPTIMIZED: No caching - always fetches from network
class _NonOptimizedImageExample extends StatefulWidget {
  const _NonOptimizedImageExample({super.key});

  @override
  State<_NonOptimizedImageExample> createState() =>
      _NonOptimizedImageExampleState();
}

class _NonOptimizedImageExampleState extends State<_NonOptimizedImageExample> {
  int _loadTime = 0;
  bool _isLoading = false;
  DateTime? _startTime;
  String _imageUrl = 'https://picsum.photos/600/400?random=2';

  @override
  void initState() {
    super.initState();
    // Start timing immediately when widget is created
    _startTimer();
  }

  @override
  void didUpdateWidget(_NonOptimizedImageExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Force new URL on reload to prevent any browser caching
    _imageUrl =
        'https://picsum.photos/600/400?random=${DateTime.now().millisecondsSinceEpoch}';
    // Restart timer on reload
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Card(
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Non-Optimized (No Cache)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '✗ Always fetches from network\n✗ Slower reload times',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Timer display
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isLoading ? 'Loading...' : 'Load time: ${_loadTime}ms',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Image without caching
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    // Image finished loading
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _stopTimer();
                    });
                    return child;
                  }

                  // Still loading - show progress indicator
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _stopTimer();
                  });
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isLoading = true;
      _loadTime = 0;
      _startTime = DateTime.now();
    });

    AppLogger.error('🖼️ NO CACHE: Starting image load (always from network)');
  }

  void _stopTimer() {
    if (!_isLoading || _startTime == null) return;

    final endTime = DateTime.now();
    final loadTime = endTime.difference(_startTime!).inMilliseconds;

    setState(() {
      _isLoading = false;
      _loadTime = loadTime;
    });

    AppLogger.error(
      '🖼️ NO CACHE: Image loaded in ${loadTime}ms (from network)',
    );
  }
}
