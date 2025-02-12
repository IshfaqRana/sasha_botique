import '../entities/products.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<Product>> call(String query) async {
    return await repository.searchProducts(query);
  }
}