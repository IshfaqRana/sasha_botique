import 'package:flutter/material.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared/widgets/cache_image.dart';

class CartItemCard extends StatelessWidget {
  final String name;
  final String collection;
  final double price;
  final String imageUrl;
  final int quantity;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const     CartItemCard({
    Key? key,
    required this.name,
    required this.collection,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.onRemove,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cartTileColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            height: 80,
            child: CachedImage(
              imageUrl: imageUrl,
              placeholder: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
              ),
              errorWidget: Icon(Icons.error),
              width: 80,
              height: 80,
            ),
          ),
          // Image.network(
          //   imageUrl,
          //   width: 70,
          //   height: 70,
          //   fit: BoxFit.cover,
          // ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  collection,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${price.toStringAsFixed(2)} USD',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: quantity <= 1 ? context.colors.grey : context.colors.primary,
                    ),
                    onPressed: () => quantity <= 1 ? null : onQuantityChanged(quantity - 1),
                    padding: EdgeInsets.zero,
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => onQuantityChanged(quantity + 1),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
