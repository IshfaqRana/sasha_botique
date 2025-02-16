import 'package:flutter/material.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

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
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: IconButton(
                icon: Icon(
                  product.isWishlisted
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: product.isWishlisted ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  // Implement wishlist toggle
                },
              ),
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
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    index.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: context.colors.infoBlue,fontSize: 12),
                  ),
                  SizedBox(width: 8,),
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