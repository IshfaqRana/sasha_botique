

import 'package:sasha_botique/features/cart/domain/repository/cart_repository.dart';

class UpdateCartItemQuantityUseCase {
  final CartRepository cartRepository;
  UpdateCartItemQuantityUseCase( this.cartRepository);

  Future<void> call(String cartItemId,int  quantity)  {
    return cartRepository.updateQuantity(cartItemId,quantity);
  }
}
