import 'package:sasha_botique/features/products/domain/repositories/product_repository.dart';

import '../entities/products.dart';

class GetFavoriteProductsUseCase {
  final ProductRepository productRepository;
  GetFavoriteProductsUseCase(this.productRepository);
  Future<List<Product>> call() {
    return productRepository.getFavouriteProducts();
  }
}
