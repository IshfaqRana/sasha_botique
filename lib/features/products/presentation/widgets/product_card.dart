import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared/widgets/cache_image.dart';
import '../../../../shared/widgets/cached_network_image.dart';
import '../../../../shared/widgets/favorite_icon_widget.dart';
import '../../domain/entities/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isListView;
  final int index;

  const ProductCard({
    Key? key,
    required this.product,
    this.isListView = false,
    this.index = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Calculate responsive dimensions - more conservative approach
    final cardWidth =
        isListView ? double.infinity : (screenWidth * 0.42).clamp(150.0, 200.0);
    final imageHeight =
        (cardWidth * 0.8).clamp(120.0, 160.0); // Reduced from 1.22 to 0.8

    return Container(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: imageHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(20),
                  ),
                  child: CachedImage(
                    imageUrl: product.imageUrl.isNotEmpty
                        ? product.imageUrl.first
                        : "https",
                    placeholder: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    errorWidget: Icon(Icons.error),
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Favorite icon
              Positioned(
                top: 8,
                right: 8,
                child: FavouriteIconWidget(product: product),
              ),
            ],
          ),

          const SizedBox(
              height: 6), // Increased spacing for better text visibility

          // Content section - using SizedBox to constrain height
          SizedBox(
            height:
                70, // Increased height from 50 to 70 to accommodate text properly
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product name
                  Expanded(
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize:
                                isSmallScreen ? 12 : 13, // Reduced font size
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 4), // Spacing between name and price

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: context.colors.grey,
                          fontSize:
                              isSmallScreen ? 13 : 14, // Reduced font size
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
