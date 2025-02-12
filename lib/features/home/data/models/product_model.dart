

import '../../domain/entities/products.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String name,
    required double price,
    required String imageUrl,
    required String category,
    bool isWishlisted = false,
    bool isPopular = false,
    bool isOnSale = false,
    double? salePrice,
    required DateTime createdAt,
    required String gender,
    required List<String> colors,
    required List<String> sizes,
    required String productType,
    required String season,
    required String fitType,
    required String brand,
  }) : super(
    id: id,
    name: name,
    price: price,
    imageUrl: imageUrl,
    category: category,
    isWishlisted: isWishlisted,
    isPopular: isPopular,
    isOnSale: isOnSale,
    salePrice: salePrice,
    createdAt: createdAt,
    gender: gender,
    colors: colors,
    sizes: sizes,
    productType: productType,
    season: season,
    fitType: fitType,
    brand: brand,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      isWishlisted: json['isWishlisted'] ?? false,
      isPopular: json['isPopular'] ?? false,
      isOnSale: json['isOnSale'] ?? false,
      salePrice: json['salePrice']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      gender: json['gender'] ?? 'unisex',
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      productType: json['productType'] ?? '',
      season: json['season'] ?? '',
      fitType: json['fitType'] ?? '',
      brand: json['brand'] ?? '',
    );
  }
}