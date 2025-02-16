import '../../../../core/network/network_manager.dart';

class CartApiService {
  final NetworkManager _networkManager;

  CartApiService(this._networkManager);

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final response = await _networkManager.get<Map<String, dynamic>>('/cart');
    return List<Map<String, dynamic>>.from(response.data?['data'] ?? []);
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    await _networkManager.post('/cart', data: item);
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _networkManager.delete('/cart/$cartItemId');
  }


  Future<void> clearCart() async {
    await _networkManager.delete('/cart');
  }
}