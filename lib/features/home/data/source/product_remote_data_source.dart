import '../models/product_model.dart';

class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts() async {

    return [];
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    // Implement search API call
    return [];
  }

  Future<List<ProductModel>> filterProducts(Map<String, dynamic> filters) async {
    // Implement filter API call
    return [];
  }
}