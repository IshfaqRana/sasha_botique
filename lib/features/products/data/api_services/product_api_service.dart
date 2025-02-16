
import '../../../../core/network/network_manager.dart';

class ProductApiService {
  final NetworkManager networkManager;
  final String _baseEndpoint = '/api/products'; // Adjust based on your API

  ProductApiService(this.networkManager);


  Future<Map<String, dynamic>> getProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      final queryParams = {
        'category': category,
        'offset': offset.toString(),
        'limit': limit.toString(),
        if (sortOption != null) 'sort': sortOption,
        if (filters != null) ...filters,
      };

      final response = await networkManager.get(
        _baseEndpoint,
        queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>> searchProducts(String query,
      Map<String, dynamic>? filters,) async {
    try {
      final queryParams = {
        'query': query,
        if (filters != null) ...filters,
      };

      final response = await networkManager.get(
        '$_baseEndpoint/search',
        queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>> getFavoriteProducts() async {
    try {
      final response = await networkManager.get('$_baseEndpoint/favorites');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> addToFavorite(String productID) async {
    try {
      await networkManager.post(
        '$_baseEndpoint/favorites',
        data: {'productId': productID},
      );
    } catch (e) {
      rethrow;
    }
  }


  Future<void> removeFromFavorite(String productID) async {
    try {
      await networkManager.delete(
        '$_baseEndpoint/favorites/$productID',
      );
    } catch (e) {
      rethrow;
    }
  }
}