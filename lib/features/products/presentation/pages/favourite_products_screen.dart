import 'package:flutter/material.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/products/domain/entities/products.dart';

import '../widgets/product_tile_card.dart';

class FavouriteProductsScreen extends StatelessWidget {
  const FavouriteProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title:  Text('Favorite',style: context.headlineSmall?.copyWith(fontSize: 18),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Replace with actual data length
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => ProductTileCard(
                product: Product(id: "id-${index+1}", name: "name-${index+1}", price: 12, imageUrl: "imageUrl", category: "category", createdAt: DateTime(2024), gender: "Male", colors: ["Black"], sizes: ["S"], productType: "stiched", season: "Summer", fitType: "Slim", brand: "sasha"),
                onTap: () {
                  // Handle product tap
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Handle add all to cart
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'ADD ALL TO CART',
                    style: TextStyle(color: Colors.white),
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
