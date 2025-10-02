import 'package:flutter/material.dart';

import '../../domain/entities/products.dart';
import '../widgets/product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Product> productList;
  final Function(Product) onProductTap;
  const SearchResultsScreen(
      {Key? key, required this.productList, required this.onProductTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => onProductTap(productList[index]),
          child: ProductCard(
            product: productList[index],
            index: index + 1,
          ),
        ),
        itemCount: productList.length, // Replace with actual product count
      ),
    );
  }
}
