import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String collection;
  final String size; // Added size field
  final String? color; // Added optional color field for future expansion

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.collection,
    required this.size, // Required size
    this.color,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    imageUrl,
    price,
    quantity,
    collection,
    size,
    color,
  ];

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? collection,
    String? size,
    String? color,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      collection: collection ?? this.collection,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  // Factory method to create CartItem from Product
  factory CartItem.fromProduct({
    required String id,
    required String productId,
    required String name,
    required String imageUrl,
    required double price,
    required String collection,
    required String size,
    String? color,
    int quantity = 1,
  }) {
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