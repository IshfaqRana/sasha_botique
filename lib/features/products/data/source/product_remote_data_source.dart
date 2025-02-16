import 'package:sasha_botique/features/products/data/api_services/product_api_service.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });
  Future<List<ProductModel>> searchProducts(
    String query,
    Map<String, dynamic>? filters,
  );
  Future<List<ProductModel>> getFavoriteProducts();
  Future<void> addToFavorite(String productID);
  Future<void> removeFromFavorite(String productID);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ProductApiService productApiService;
  ProductRemoteDataSourceImpl(this.productApiService);
  @override
  Future<List<ProductModel>> getProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    await productApiService.getProducts(category: category, offset: offset, limit: limit,filters: filters,sortOption: sortOption);
    return [];
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query,
    Map<String, dynamic>? filters,
  ) async {
    await productApiService.searchProducts(query, filters);
    return [];
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts() async {
    await productApiService.getFavoriteProducts();
    return [];
  }

  @override
  Future<void> addToFavorite(String productID) async {
    await productApiService.addToFavorite(productID);
  }

  @override
  Future<void> removeFromFavorite(String productID) async {
    await productApiService.removeFromFavorite(productID);
  }
}
