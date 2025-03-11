import '../entity/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(CartItem item);
  Future<void> removeFromCart(String cartItemId);
  Future<void> updateQuantity(String cartItemId, int quantity);
  Future<void> clearCart();
}
