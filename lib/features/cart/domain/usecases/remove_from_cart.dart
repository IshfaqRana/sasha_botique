import 'package:sasha_botique/features/cart/domain/entity/cart_item.dart';
import 'package:sasha_botique/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository cartRepository;
  RemoveFromCartUseCase( this.cartRepository);

  Future<void> call(String cartItemId)  {
    return cartRepository.removeFromCart(cartItemId);
  }
}
