import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<List<Product>> call({
    required String category,
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) {
    return repository.getAllProducts(
      category: category,
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption,
    );
  }
}