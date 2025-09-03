import 'package:flutter/material.dart';

import '../../domain/entities/products.dart';
import '../widgets/product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Product> productList;
  final Function(Product) onProductTap;

  const SearchResultsScreen({
    Key? key,
    required this.productList,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth < 900;

    // Responsive grid configuration - using adjusted aspect ratios
    int crossAxisCount;
    double childAspectRatio;
    double crossAxisSpacing;
    double mainAxisSpacing;

    if (isSmallScreen) {
      crossAxisCount = 2;
      childAspectRatio =
          0.8; // Adjusted to accommodate increased content height
      crossAxisSpacing = 12;
      mainAxisSpacing = 12;
    } else if (isMediumScreen) {
      crossAxisCount = 3;
      childAspectRatio =
          0.85; // Adjusted to accommodate increased content height
      crossAxisSpacing = 16;
      mainAxisSpacing = 16;
    } else {
      crossAxisCount = 4;
      childAspectRatio =
          0.9; // Adjusted to accommodate increased content height
      crossAxisSpacing = 20;
      mainAxisSpacing = 20;
    }

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => onProductTap(productList[index]),
          child: ProductCard(
            product: productList[index],
            index: index + 1,
          ),
        ),
        itemCount: productList.length,
      ),
    );
  }
}
