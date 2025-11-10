import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/comparison_view.dart';

/// Example demonstrating image optimization techniques
/// 
/// KEY OPTIMIZATIONS:
/// 1. Use cacheWidth/cacheHeight to decode images at appropriate size
/// 2. Use cached_network_image for automatic caching
/// 3. Load images lazily
class ImageOptimizationExample extends StatelessWidget {
  const ImageOptimizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparisonView(
      title: 'Image Optimization',
      optimizedWidget: const _OptimizedImageExample(),
      nonOptimizedWidget: const _NonOptimizedImageExample(),
    );
  }
}

/// OPTIMIZED: Uses image caching and size optimization
class _OptimizedImageExample extends StatelessWidget {
  const _OptimizedImageExample();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Optimized Images',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text('✓ Cached network images'),
                Text('✓ Decoded at display size'),
                Text('✓ Lazy loading'),
                Text('✓ Memory efficient'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Example with optimized network image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: 'https://picsum.photos/400/300',
            cacheKey: 'optimized_image_1',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Asset image with optimization
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/placeholder.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            // These parameters decode the image at the specified size
            cacheWidth: AppConstants.optimizedImageWidth,
            cacheHeight: AppConstants.optimizedImageHeight,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Placeholder image'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        const Card(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Memory saved: ~90% compared to full-resolution',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/// NON-OPTIMIZED: Loads full-resolution images without optimization
class _NonOptimizedImageExample extends StatelessWidget {
  const _NonOptimizedImageExample();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Non-Optimized Images',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text('✗ No caching'),
                Text('✗ Full resolution decoded'),
                Text('✗ High memory usage'),
                Text('✗ Potential lag'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Non-optimized network image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://picsum.photos/1920/1080',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            // No cacheWidth/cacheHeight - decodes at full resolution!
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Asset image without optimization
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/placeholder.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            // No cacheWidth/cacheHeight parameters
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Placeholder image'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        const Card(
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Warning: Using 10x more memory than necessary',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
