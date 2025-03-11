import 'package:sasha_botique/features/products/domain/repositories/product_repository.dart';

class AddToFavouriteUseCase{
  final ProductRepository productRepository;
  AddToFavouriteUseCase(this.productRepository);
  Future<void> call(String productID){
    return productRepository.addToFav(productID);
  }
}