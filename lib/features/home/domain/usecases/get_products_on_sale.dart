import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetProductsOnSaleUseCase {
  final ProductRepository repository;

  GetProductsOnSaleUseCase(this.repository);

  Future<List<Product>> call({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) {
    return repository.getSaleProducts(
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption,
    );
  }
}