import 'package:flutter/material.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared/widgets/cache_image.dart';
import '../../domain/entities/products.dart';

class ProductTileCard extends StatelessWidget {
  final Product product;
  final Function()? onTap;
  const ProductTileCard({
    Key? key,
    required this.product,

    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.cartTileColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CachedImage(
                imageUrl: product.imageUrl.isNotEmpty? product.imageUrl.first: "",
                placeholder: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey.shade300,
                  ),
                ),
                errorWidget: Icon(Icons.error),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            // Image.network(
            //   product.imageUrl,
            //   width: 60,
            //   height: 60,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: context.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.productType,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    '\$${product.price.toStringAsFixed(2)} USD',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
