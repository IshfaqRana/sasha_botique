import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetAccessoriesProductsUseCase {
  final ProductRepository repository;

  GetAccessoriesProductsUseCase(this.repository);

  Future<List<Product>> call({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) {
    return repository.getAccessoriesProducts(
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption,
    );
  }
}


