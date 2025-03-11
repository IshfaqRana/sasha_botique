import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entity/cart_item.dart';
import '../../domain/repository/cart_repository.dart';
import '../models/cart_model.dart';
import '../source/local_data_source.dart';
import '../source/remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Future<bool> _isConnected() async {
  //   final result = await connectivity.checkConnectivity();
  //   return result != ConnectivityResult.none;
  // }
  @override
  Future<List<CartItem>> getCartItems() async {
    return await localDataSource.getCartItems();
  }

  @override
  Future<void> addToCart(CartItem item) async {
    await localDataSource.addToCart(item);
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await localDataSource.removeFromCart(cartItemId);
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await localDataSource.updateQuantity(cartItemId, quantity);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}