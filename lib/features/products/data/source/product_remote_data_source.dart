import 'package:sasha_botique/features/products/data/api_services/product_api_service.dart';

import '../models/favourite_products_response_model.dart';
import '../models/get_all_items_response_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });
  Future<List<ProductModel>> getPopularProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });
  Future<List<ProductModel>> getSaleProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });
  Future<List<ProductModel>> getClearanceProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  });
  Future<List<ProductModel>> getAccessoriesProducts({
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
  Future<ProductModel?> fetchProductDetail(String productID);
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
    final response = await productApiService.getProducts(
        category: category,
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption);
    GetItemsResponseModel productModelResponse =
        GetItemsResponseModel.fromJson(response);
    if (productModelResponse.status ?? false) {
      return productModelResponse.payload?.products ?? [];
    }
    return [];
  }

  @override
  Future<List<ProductModel>> getSaleProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    final response = await productApiService.getSaleProducts(
        category: category,
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption);
    ProductModelResponse productModelResponse =
        ProductModelResponse.fromJson(response);
    if (productModelResponse.status ?? false) {
      return productModelResponse.products ?? [];
    }
    return [];
  }

  @override
  Future<List<ProductModel>> getClearanceProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    final response = await productApiService.getClearanceProducts(
        category: category,
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption);
    ProductModelResponse productModelResponse =
        ProductModelResponse.fromJson(response);
    if (productModelResponse.status ?? false) {
      return productModelResponse.products ?? [];
    }
    return [];
  }

  @override
  Future<List<ProductModel>> getAccessoriesProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    final response = await productApiService.getAccessoriesProducts(
        category: category,
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption);
    ProductModelResponse productModelResponse =
        ProductModelResponse.fromJson(response);
    if (productModelResponse.status ?? false) {
      return productModelResponse.products ?? [];
    }
    return [];
  }

  @override
  Future<List<ProductModel>> getPopularProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    print(filters);
    final response = await productApiService.getPopularProducts(
        category: category,
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption);
    ProductModelResponse productModelResponse =
        ProductModelResponse.fromJson(response);
    if (productModelResponse.status ?? false) {
      return productModelResponse.products ?? [];
    }
    return [];
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query,
    Map<String, dynamic>? filters,
  ) async {
    try {
      final response = await productApiService.searchProducts(query, filters);
      GetItemsResponseModel productModelResponse =
          GetItemsResponseModel.fromJson(response);
      if (productModelResponse.status ?? false) {
        return productModelResponse.payload?.products ?? [];
      }
      return [];
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts() async {
    final response = await productApiService.getFavoriteProducts();
    FavouriteProductsResponseModel favouriteProductsResponseModel =
        FavouriteProductsResponseModel.fromJson(response);
    if (favouriteProductsResponseModel.status ?? false) {
      return favouriteProductsResponseModel.payload?.products ?? [];
    }
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

  @override
  Future<ProductModel?> fetchProductDetail(String productID) async {
    try {
      final response = await productApiService.fetchProductDetail(productID);
      SingleProductModelResponse productModelResponse =
          SingleProductModelResponse.fromJson(response);
      if (productModelResponse.status ?? false) {
        return productModelResponse.product;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
