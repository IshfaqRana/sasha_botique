import 'package:flutter/foundation.dart';
import 'package:sasha_botique/features/products/domain/entities/products.dart';

void debugPrinter(Object? object) {
  if (kDebugMode) {
    // print(object);
  }
}

bool isFavorite(String productId, List<Product> favoriteProductList){
  // debugPrinter("Favourite Products >>>>>>>>>> ${favoriteProductList.length}");
  // favoriteProductList.forEach((product)=> debugPrinter("Product ID'S >>>>>>>> ${product.id}"));
  // debugPrinter(productId);
  return favoriteProductList.any((item) => item.id == productId);
}