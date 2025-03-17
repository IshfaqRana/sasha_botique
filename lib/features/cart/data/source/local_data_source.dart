import '../../../../core/services/hive_service.dart';
import '../models/cart_item_hive_model.dart';
import '../../domain/entity/cart_item.dart';

abstract class CartLocalDataSource {
 Future<List<CartItem>> getCartItems();
 Future<void> addToCart(CartItem item);
 Future<void> removeFromCart(String cartItemId);
 Future<void> updateQuantity(String cartItemId, int quantity);
 Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
 final HiveService hiveService;

 CartLocalDataSourceImpl({required this.hiveService});

 @override
 Future<List<CartItem>> getCartItems() async {
  final cartHiveItems = hiveService.getAllCartItems();
  return cartHiveItems.map((hiveItem) => hiveItem.toCartItem()).toList();
 }

 @override
 Future<void> addToCart(CartItem item) async {
  final hiveModel = CartItemHiveModel.fromCartItem(item);
  await hiveService.addCartItem(hiveModel);
 }

 @override
 Future<void> removeFromCart(String cartItemId) async {
  await hiveService.removeCartItem(cartItemId);
 }

 @override
 Future<void> updateQuantity(String cartItemId, int quantity) async {
  final cartItem = hiveService.getCartItem(cartItemId);
  if (cartItem != null) {
   final updatedItem = CartItemHiveModel(
    id: cartItem.id,
    productId: cartItem.productId,
    name: cartItem.name,
    imageUrl: cartItem.imageUrl,
    price: cartItem.price,
    quantity: quantity,
    collection: cartItem.collection,
    size: cartItem.size,
    color: cartItem.color,
   );
   await hiveService.addCartItem(updatedItem);
  }
 }

 @override
 Future<void> clearCart() async {
  await hiveService.clearCart();
 }
}