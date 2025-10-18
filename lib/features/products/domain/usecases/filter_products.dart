import '../entities/filter_result.dart';
import '../repositories/product_repository.dart';

class FilterProductsUseCase {
  final ProductRepository repository;

  FilterProductsUseCase(this.repository);

  Future<FilterResult> call({
    List<String>? filters,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return repository.filterProducts(
      filters: filters,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: page,
      limit: limit,
      search: search,
    );
  }
}
