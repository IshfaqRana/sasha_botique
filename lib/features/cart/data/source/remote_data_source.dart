import 'package:dio/dio.dart';

import '../../../../core/network/network_exceptions.dart';
import '../api_service/api_service.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart();
}
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final CartApiService _cartApiService;

  CartRemoteDataSourceImpl(this._cartApiService);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final response = await _cartApiService.getCartItems();
      return response.map((json) => CartItemModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    try {
      await _cartApiService.addToCart(item.toJson());
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _cartApiService.removeFromCart(cartItemId);
    } catch (e) {
      throw _handleError(e);
    }
  }
  @override
  Future<void> clearCart() async {
    try {
      await _cartApiService.clearCart();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is UnauthorizedException) {
      return CartException('Authentication required');
    } else if (error is NetworkException) {
      return CartException('Network error occurred');
    } else if (error is TimeoutException) {
      return CartException('Request timed out');
    }
    return CartException('Failed to perform cart operation');
  }


}