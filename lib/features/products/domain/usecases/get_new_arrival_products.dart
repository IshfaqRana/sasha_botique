import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetNewArrivalProductsUseCase {
  final ProductRepository repository;

  GetNewArrivalProductsUseCase(this.repository);

  Future<List<Product>> call({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
  }) {
    return repository.getNewArrivals(
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption,
    );
  }
}