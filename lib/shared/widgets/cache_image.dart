import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class SimpleImageCache {
  // LRU cache to store images in memory
  static final _cache = LinkedHashMap<String, Uint8List>.fromIterable([]);
  static const int _maxSize = 50; // Maximum number of images to keep in memory

  // Get image from cache or fetch from network
  static Future<Uint8List?> getImage(String url) async {
    // Return from cache if available
    if (_cache.containsKey(url)) {
      // Move this item to the end (most recently used)
      final image = _cache.remove(url);
      _cache[url] = image!;
      return image;
    }

    // Fetch from network
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final image = response.bodyBytes;

        // Add to cache, remove oldest if cache is full
        if (_cache.length >= _maxSize) {
          _cache.remove(_cache.keys.first);
        }
        _cache[url] = image;

        return image;
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
    }

    return null;
  }

  // Clear the cache
  static void clear() {
    _cache.clear();
  }
}

class CachedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Widget)? imageBuilder;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;

  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  Uint8List? _imageData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    // Schedule after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      try {
        final data = await SimpleImageCache.getImage(widget.imageUrl);

        if (data != null && mounted) {
          setState(() {
            _imageData = data;
            _isLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('Error in CachedImage: $e');
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_hasError || _imageData == null) {
      return widget.errorWidget ?? Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    final imageWidget = Image.memory(
      _imageData!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      frameBuilder: (context, child, frame, _) {
        if (frame == null) {
          return child;
        }
        return AnimatedOpacity(
          opacity: 1.0,
          duration: widget.fadeInDuration,
          curve: Curves.easeOut,
          child: child,
        );
      },
    );

    if (widget.imageBuilder != null) {
      return widget.imageBuilder!(context, imageWidget);
    }

    return imageWidget;
  }
}
