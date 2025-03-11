
import 'package:sasha_botique/features/products/domain/entities/products.dart';

import '../repositories/product_repository.dart';

class FetchProductDetailUseCase{
  final ProductRepository productRepository;
  FetchProductDetailUseCase(this.productRepository);
  Future<Product?> call(String productID){
    return productRepository.fetchProductDetail(productID);
  }
}