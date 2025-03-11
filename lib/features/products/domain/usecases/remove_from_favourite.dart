import '../repositories/product_repository.dart';

class RemoveFromFavoriteUseCase{
  final ProductRepository productRepository;
  RemoveFromFavoriteUseCase(this.productRepository);
  Future<void> call(String productID){
    return productRepository.removeFromFav(productID);
  }
}