
import '../../../../core/network/network_manager.dart';

class ProductApiService {
  final NetworkManager networkManager;
  final String _baseEndpoint = '/item'; // Adjust based on your API

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
        // 'category': category,
        'page': offset.toString(),
        'limit': limit.toString(),
         'sort': sortOption ?? "ACS",
        if (filters != null) ...filters,
      };
        String limits = limit.toString();
       String page = (offset+1).toString();
      String sort = sortOption ?? "ACS";
      final response = await networkManager.post(
        "$_baseEndpoint/all-items?sort=$sort&page=$page&limit=$limits",
        // queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPopularProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      // final queryParams = {
      //   'category': category,
      //   'offset': offset.toString(),
      //   'limit': limit.toString(),
      //   if (sortOption != null) 'sort': sortOption,
      //   if (filters != null) ...filters,
      // };

      final response = await networkManager.get(
        "$_baseEndpoint/popular",
        // queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSaleProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      // final queryParams = {
      //   'category': category,
      //   'offset': offset.toString(),
      //   'limit': limit.toString(),
      //   if (sortOption != null) 'sort': sortOption,
      //   if (filters != null) ...filters,
      // };

      final response = await networkManager.get(
        "$_baseEndpoint/sale",
        // queryParameters: queryParams,
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

      final response = await networkManager.post(
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
      final response = await networkManager.get('/wishlist');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>> addToFavorite(String productID, {bool addingFirstProduct= false}) async {
    try {
      var response;
      if(addingFirstProduct) {
        response = await networkManager.post(
          '/wishlist',
          data: {
            "items ": [
              productID
            ]
          }
        );

      }else{
        response = await networkManager.patch(
          '/wishlist/add/$productID',
          data: {'productId': productID},
        );
      }
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>> removeFromFavorite(String productID) async {
    try {
      final response = await networkManager.patch(
        '/wishlist/remove/$productID',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> fetchProductDetail(String productID) async {
    try {
      final response = await networkManager.get(
        '/item/$productID',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}