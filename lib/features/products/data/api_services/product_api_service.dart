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
      String page = (offset + 1).toString();
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

  Future<Map<String, dynamic>> getClearanceProducts({
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
        "$_baseEndpoint/clearance",
        // queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAccessoriesProducts({
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
        "$_baseEndpoint/accessories",
        // queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> searchProducts(
    String query,
    Map<String, dynamic>? filters,
  ) async {
    try {
      // Prepare filter data for backend - always send all filter fields
      Map<String, dynamic> filterData = {
        "brand_name": "",
        "product_type": "",
        "season": "",
        "fit_type": "",
        "collection": ""
      };

      // Update with actual filter values if provided
      if (filters != null && filters.isNotEmpty) {
        if (filters.containsKey('brand_name') &&
            filters['brand_name'] != null &&
            (filters['brand_name'] as List).isNotEmpty) {
          filterData['brand_name'] = (filters['brand_name'] as List).first;
        }
        if (filters.containsKey('product_type') &&
            filters['product_type'] != null &&
            (filters['product_type'] as List).isNotEmpty) {
          filterData['product_type'] = (filters['product_type'] as List).first;
        }
        if (filters.containsKey('season') &&
            filters['season'] != null &&
            (filters['season'] as List).isNotEmpty) {
          filterData['season'] = (filters['season'] as List).first;
        }
        if (filters.containsKey('fit_type') &&
            filters['fit_type'] != null &&
            (filters['fit_type'] as List).isNotEmpty) {
          filterData['fit_type'] = (filters['fit_type'] as List).first;
        }
        if (filters.containsKey('collection') &&
            filters['collection'] != null &&
            (filters['collection'] as List).isNotEmpty) {
          filterData['collection'] = (filters['collection'] as List).first;
        }
      }

      final response = await networkManager.post(
        '$_baseEndpoint/search?search=$query&sort=ACS&page=1&limit=10',
        data: filterData,
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

  Future<Map<String, dynamic>> addToFavorite(String productID,
      {bool addingFirstProduct = false}) async {
    try {
      var response;
      if (addingFirstProduct) {
        response = await networkManager.post('/wishlist', data: {
          "items ": [productID]
        });
      } else {
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

  /// New unified filter API endpoint
  /// Supports filtering, sorting, search, and pagination in a single request
  Future<Map<String, dynamic>> filterProducts({
    List<String>? filterList, // e.g., ["Sasha Basics", "Popular", "Clearance", "Accessories"]
    String? sortBy, // e.g., "price", "name", "createdAt", "popularity", "id"
    String? sortOrder, // "ASC" or "DESC"
    int page = 1,
    int limit = 10,
    String? search,
    Map<String, String>? filters, // Additional filters object
  }) async {
    try {
      final requestBody = {
        "filterList": filterList ?? [],
        "sortBy": sortBy ?? "id",
        "sortOrder": sortOrder ?? "DESC",
        "page": page,
        "limit": limit,
        "search": search ?? "",
        "filters": filters ?? {},
      };

      final response = await networkManager.post(
        '$_baseEndpoint/filter',
        data: requestBody,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
