import 'package:hive/hive.dart';

import '../../domain/entity/cart_item.dart';

part 'cart_item_hive_model.g.dart';

@HiveType(typeId: 1)
class CartItemHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int quantity;

  @HiveField(6)
  final String collection;

  @HiveField(7)
  final String size;

  @HiveField(8)
  final String? color;
  CartItemHiveModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.collection,
    this.color,
    required this.size,
  });

  factory CartItemHiveModel.fromCartItem(CartItem item) {
    return CartItemHiveModel(
      id: item.id,
      productId: item.productId,
      name: item.name,
      imageUrl: item.imageUrl,
      price: item.price,
      quantity: item.quantity,
      collection: item.collection,
      color: item.color,
      size: item.size,
    );
  }

  CartItem toCartItem() {
    return CartItem(
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
  }
}