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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                        color: Colors.black.withOpacity(0.7),
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
}
