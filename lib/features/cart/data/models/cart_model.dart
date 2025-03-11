import 'dart:convert';

import '../../domain/entity/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required String id,
    required String productId,
    required String name,
    required String imageUrl,
    required double price,
    required int quantity,
    required String collection,
    required String size,
     String? color,
  }) : super(
    id: id,
    productId: productId,
    name: name,
    imageUrl: imageUrl,
    price: price,
    quantity: quantity,
    collection: collection,
    size: size,
    color: color,
  );

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? "",
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 1,
      collection: json['season'],
      size: json['size'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'quantity': quantity,
      'season': collection,
      'size': size,
    };
  }
}