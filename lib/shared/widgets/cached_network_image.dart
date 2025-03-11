import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetworkShimmer extends StatelessWidget {
  const CustomCachedNetworkShimmer({
    super.key,
    required this.height,
    required this.imageUrl,
    required this.width,
    this.cacheKey,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
    this.colorFilter,
  });

  final String imageUrl;
  final double height;
  final double width;
  final String? cacheKey;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.error, color: Colors.red)),
      ),
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }
}