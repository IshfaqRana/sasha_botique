import '../entities/products.dart';
import '../repositories/product_repository.dart';

class GetGenderProductsUseCase {
  final ProductRepository repository;

  GetGenderProductsUseCase(this.repository);

  Future<List<Product>> call({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
    String? sortOption,
    required String gender,
  }) {
    return repository.getProductsByGender(
      offset: offset,
      limit: limit,
      filters: filters,
      sortOption: sortOption, gender: gender,
    );
  }
}