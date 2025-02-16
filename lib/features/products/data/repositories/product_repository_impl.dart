import 'package:sasha_botique/core/utils/app_utils.dart';

import '../source/product_local_data_source.dart';
import '../source/product_remote_data_source.dart';

import '../../domain/entities/products.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Product>> getAllProducts({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      return await localDataSource.getProducts(
        category: category,
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption,
      );
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<Product>> getPopularProducts({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      return await localDataSource.getPopularProducts(
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption,
      );
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<Product>> getSaleProducts({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      return await localDataSource.getSaleProducts(
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption,
      );
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<Product>> getProductsByGender({
    required int offset,
    required int limit,
    required String gender,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      return await localDataSource.getProductsByGender(
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption,
        gender: gender,
      );
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<Product>> getNewArrivals({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) async {
    try {
      return await localDataSource.getNewArrivals(
        offset: offset,
        limit: limit,
        filters: filters,
        sortOption: sortOption,
      );
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<List<Product>> searchProducts(String query,Map<String,dynamic>? filters) async {
    try {
      return await remoteDataSource.searchProducts(query,filters);
    } catch (e) {
      // Implement local search or throw
      throw Exception('Search failed');
    }
  }

  @override
  Future<void> addToFav(String productID) async {
    try{
      await remoteDataSource.addToFavorite(productID);
    }catch(e){
      debugPrinter(e.toString());

    }
  }

  @override
  Future<List<Product>> getFavouriteProducts() async {
    try{
      final items = await remoteDataSource.getFavoriteProducts();
      return items;
    }catch(e){
      debugPrinter(e.toString());

      return [];
    }
  }

  @override
  Future<void> removeFromFav(String productID) async {
    try{
      await remoteDataSource.removeFromFavorite(productID);
    }catch(e){
      debugPrinter(e.toString());
    }
  }

}
