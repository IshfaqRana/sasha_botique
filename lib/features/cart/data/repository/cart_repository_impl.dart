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
    try {
final items = await localDataSource.getCartItems();
      print('CartRepositoryImpl.getCartItems: ${items.length}');
      return items;
    } catch (e) {
      return await localDataSource.getCartItems();
    }
  }

  @override
  Future<void> addToCart(CartItem item) async {
    final cartItemModel = CartItemModel(
      id: item.id,
      productId: item.productId,
      name: item.name,
      imageUrl: item.imageUrl,
      price: item.price,
      quantity: item.quantity,
      collection: item.collection,
    );


    final localItems = await localDataSource.getCartItems();
    localItems.add(cartItemModel);
    localItems;
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {


    final localItems = await localDataSource.getCartItems();
    // localItems.removeWhere((item) => item.id == cartItemId);
   localItems;
  }

  @override
  Future<void> clearCart() {
    throw UnimplementedError();
  }

}