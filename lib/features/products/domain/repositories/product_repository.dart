import '../entities/products.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });

  Future<List<Product>> getPopularProducts({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });

  Future<List<Product>> getNewArrivals({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });

  Future<List<Product>> getSaleProducts({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });

  Future<List<Product>> getProductsByGender({
    required String gender,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });

  Future<List<Product>> searchProducts(String query,Map<String, dynamic>? filters);

  Future<List<Product>> getFavouriteProducts();

  Future<void> addToFav(String productID);
  Future<Product?> fetchProductDetail(String productID);
  Future<void> removeFromFav(String productID);

}
