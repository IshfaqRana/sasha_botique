import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetPopularProductsUseCase {
  final ProductRepository repository;

  GetPopularProductsUseCase(this.repository);

  Future<List<Product>> call({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) {
    return repository.getPopularProducts(
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption,
    );
  }
}