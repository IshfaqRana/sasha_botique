import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetClearanceProductsUseCase {
  final ProductRepository repository;

  GetClearanceProductsUseCase(this.repository);

  Future<List<Product>> call({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) {
    return repository.getClearanceProducts(
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption,
    );
  }
}


