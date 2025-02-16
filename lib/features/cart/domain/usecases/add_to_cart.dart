import 'package:sasha_botique/features/cart/domain/entity/cart_item.dart';
import 'package:sasha_botique/features/cart/domain/repository/cart_repository.dart';

class AddToCartItemUseCase{
  final CartRepository cartRepository;
  AddToCartItemUseCase( this.cartRepository);

  Future<void> call(CartItem item) {
    return cartRepository.addToCart(item);
  }

}