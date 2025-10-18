import 'package:flutter/material.dart';
import 'package:sasha_botique/core/di/injections.dart';
import 'package:sasha_botique/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared/widgets/auth_required_dialog.dart';
import '../../../../shared/widgets/cache_image.dart';
import '../../../../shared/widgets/favorite_icon_widget.dart';
import '../../../../shared/widgets/quantity_selector_dialog.dart';
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

  Future<void> _showQuantityDialog(BuildContext context) async {
    final isAuthenticated = await AuthRequiredMixin.checkAuthAndPrompt(
      context,
      title: 'Login Required',
      message: 'You need to login to add items to your cart.',
    );

    if (!isAuthenticated) {
      return;
    }

    if (product.sizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No sizes available for this product')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => QuantitySelectorDialog(
        product: product,
        initialSize: product.sizes.isNotEmpty ? product.sizes.first : null,
        onAddToCart: (product, size, quantity) {
          final cartBloc = getIt<CartBloc>();
          cartBloc.add(AddProductToCart(
            product: product,
            quantity: quantity,
            size: size,
          ));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added to cart'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isListView ? _buildListViewCard(context) : _buildGridViewCard(context);
  }

  Widget _buildGridViewCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: CachedImage(
                      imageUrl: product.imageUrl.isNotEmpty
                          ? product.imageUrl.first
                          : "https",
                      placeholder: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      errorWidget: Icon(Icons.error),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavouriteIconWidget(product: product),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _showQuantityDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: context.colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListViewCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedImage(
              imageUrl: product.imageUrl.isNotEmpty
                  ? product.imageUrl.first
                  : "https",
              placeholder: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 140,
                  width: 120,
                  color: Colors.grey.shade300,
                ),
              ),
              errorWidget: Icon(Icons.error),
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.brandName,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.colors.grey,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      FavouriteIconWidget(product: product),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.colors.blackWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showQuantityDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('Add to Cart'),
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
