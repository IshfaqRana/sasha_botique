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
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: 170,
              height: 208,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                  bottom: Radius.circular(30),
                ),
                child: CachedImage(
                  imageUrl: product.imageUrl.isNotEmpty ? product.imageUrl.first: "https",
                  placeholder: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 208,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  errorWidget: Icon(Icons.error),
                  width: 300,
                  height: 200,
                )
              ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: FavouriteIconWidget(product: product),
            ),

          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}